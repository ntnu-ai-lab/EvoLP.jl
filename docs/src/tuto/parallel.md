# Parallel Evaluation in EvoLP.jl

Evaluation of multiple solutions in parallel can dramatically reduce computational time.
This tutorial will illustrate how to do so with Threads and MPI.
However, you might also want to check Julia's built-in [Distributed](https://docs.julialang.org/en/v1/manual/distributed-computing/) module.

## Threads

Julia has built-in [multithreaded support](https://docs.julialang.org/en/v1/manual/multi-threading/) via the `Base.Threads` package.

First, make sure you are running Julia with several threads.

!!! details
    By using the the `-t` option, Julia can be started with several threads.
    For example, `julia -t 4` will start Julia with 4 threads.

Then, you can add the `@threads` macro to the evaluation loop of your algorithms:

```julia
# generate population
# set selection, crossover and mutation operators
# set fitness function f
N = length(population)
fitnesses = zeros(N)
@threads for i in eachindex(fitnesses)
    fitnesses[i] = f(population[i])
end
# do selection, crossover, mutation...
# repeat
```

The scheduler will automatically spawn and sync all available threads to Julia in order to finish the computation.
This is the easiest way to do parallel computations with EvoLP, but it is limited to a single physical processor.
If you need many more processes/cores, consider using Distributed or MPI.

## MPI

!!! note
    This is a somewhat advanced topic, as you need to specify and handle the communication between processors yourself.
    However, it can scale very well, up to HPC clusters.

[MPI](https://www.mpi-forum.org/) (short for _Message Passing Interface_) is a library interface specification that addresses the parallel model in which data moves between computers through messages.
It is one of the most widely used standards for parallel programming in High-Performance Computing (HPC) systems, and so it is available on many clusters.
Nevertheless, you can run MPI on your local device as well.

In EvoLP, we use the MPI bindings for Julia included in the [MPI.jl](https://juliaparallel.org/MPI.jl/stable/) package.
It is important to remark that EvoLP does not load MPI.jl by default. Instead, it is used as an [extension](https://pkgdocs.julialang.org/v1/creating-packages/#Conditional-loading-of-code-in-packages-(Extensions)), so it will be available if you load MPI.jl in your code along with EvoLP.jl.

### Installing MPI Locally

For installation and configuration, kindly follow the steps defined in the [MPI.jl documentation](https://juliaparallel.org/MPI.jl/stable/configuration/).

Nonetheless, you might be able to install it through a package manager.
We have tested the [MPICH](https://www.mpich.org/) implementation on both Ubuntu 22 (using `apt`) and Fedora 42 (using `dnf`).

In some cases, the MPICH package might get installed as in a SLURM cluster.
In such situations, the module needs to be loaded first to see the available executables:

```sh-session
$ module load mpi
```

This will allow the `mpiexec` and `mpirun` commands&mdash;which are needed to execute Julia scripts in parallel&mdash;to become available in your shell.

We highly suggest that you try first the [MPI.jl Basic Example](https://juliaparallel.org/MPI.jl/stable/usage/).

### Island Models using MPI

#### Step 1: Code your island

If you have not done so, please read the documentation page on [island models](../man/islands.md).

Assume you have a very basic island model using the following settings:

An archipelago with 4 islands, optimising the [`michalewicz`](@ref) function.
All islands are identical, and each island features:

- A population ``P`` of ``N=30`` 2-dimensional vectors (individuals)
  - where ``P \sim \mathcal{U}(\{\boldsymbol{x} | \boldsymbol{x} \in \mathbb{R}^2, x \in [0, \pi]\})``
- A rank-based selector: [`RankBasedSelector`](@ref)
- A uniform crossover operator: [`UniformRecombinator`](@ref)
- A Gaussian mutation operator with ``\sigma = 0.1``: [`GaussianMutator`](@ref)

The algorithm will run for 100 iterations, and every ``\mu=10`` iterations, it will send a deme of 10% of the population size, i.e., ``k=0.1N`` (3 individuals).
It will select the ``k`` individuals at random, and will replace the worst ``k`` individuals in the new island.

The migration topology is a ring, so each island will send its deme to the next island:

```math
1 \to 2 \to 3 \to 4 \to 1
```

Then, the code would look similar to this:

```julia
using EvoLP  # Load EvoLP
using OrderedCollections
using MPI  # Load MPI.jl!
using Statistics

MPI.Init()  # Initialize MPI

comm = MPI.COMM_WORLD  # Initialize the MPI communication world
ranks = MPI.Comm_size(comm)  # Create a rank for each island
myrank = MPI.Comm_rank(comm)  # Assign each island to its rank

dest = mod(myrank+1, ranks)  # Set destination (Deme I am sending)
src = mod(myrank-1, ranks)  # Set source (Deme I am receiving)

# GA operators
N = 30
S_P = RankBasedSelector()
X = UniformRecombinator()
Mut = GaussianMutator(0.1)
max_it = 100

# Island operators
k = 0.1*N # deme size
S_M = RandomDemeSelector(k)  # migration selection policy
R_M = WorstDemeSelector(k)  # migration replacement policy
μ = 10  # number of iterations between migration

P = unif_rand_vector_pop(N, [0, 0], [π, π])

thelog = Logbook()

res = islandGA!(thelog, michalewicz, P, max_it, S_P, X, Mut, μ, S_M, R_M, dest, src, comm)

print("""Result on run from rank $(myrank) was $(optimum(res)) achieved by $(optimizer(res))\n""")
```

In this snippet of code, we are using the toy built-in algorithm [`islandGA!`](@ref).

#### Step 2: Run your model

Once the script is finished, you can run it using MPI from the terminal.
Assuming our script is called `scratch.jl`:

You can run it using `mpiexec`, as such:

```sh-session
$ mpiexec -n 4 julia --project=./ ./scratch.jl
```

Notice we are using `-n 4` to run 4 islands, but this is where MPI really shines as it can scale very easily.

The result should look something like this:

```sh-session
$ mpiexec -n 4 julia --project=./ ./scratch.jl
Result on run from rank 0 was -1.7918109629302714 achieved by [2.1799811139347045, 1.5759514028959793]
Result on run from rank 1 was -1.7687392718383559 achieved by [2.2092215285901076, 1.5988409423611978]
Result on run from rank 3 was -1.784211505064787 achieved by [2.213698645080214, 1.5512366106384692]
Result on run from rank 2 was -1.7738196053483932 achieved by [2.2115479736169856, 1.54495573080501]
```

### Running on an HPC cluster

!!! warning
    Each HPC system is different, so you might need to adapt these instructions.
    Nevertheless, this is a good starting point.

We have tested EvoLP using [SLURM](https://slurm.schedmd.com/documentation.html).
Assuming you have a julia module available, then the process is very similar to the steps above.
You can submit an bash script similar to this:

```bash
#!/usr/bin/bash
#SBATCH -J julia-mpi-test
#SBATCH -n 64
#SBATCH -c 1

module load foss/2022b
module load Julia/1.9.3-linux-x86_64

srun julia scratch.jl
```

Which can then submitted as:

```sh-session
$ sbatch myjuliajob.sh
```

Assuming you named your bash script as `myjuliajob.sh`. Note that the module `foss/2022b` is one of many modules that include MPI. `intel-compilers` is another module that normally includes MPI as well.
In our script, the `srun` command will run the `scratch.jl` julia script that corresponds to an island.
Then, it will create `-n 64` copies of the script, and run them in  the MPI world.

Again, each HPC system is different, and the modules and tricks available are usually specific to each system. You might have to experiment a bit.

## Further Reading

- [Distributed](https://docs.julialang.org/en/v1/manual/distributed-computing/): Julia's built-in distributed computing module
- The [MPI.jl documentation](https://juliaparallel.org/MPI.jl/stable/).
- Our paper [Evolutionary Computation with Islands: Extending EvoLP.jl for Parallel Computing](https://www.ntnu.no/ojs/index.php/nikt/article/view/5667).
