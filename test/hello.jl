using MPI
using EvoLP

Base.retry_load_extensions() # you might not need this

MPI.Init()

comm = MPI.COMM_WORLD
ranks = MPI.Comm_size(comm)
myrank = MPI.Comm_rank(comm)

# Ring topology
dest = mod(myrank + 1, ranks)
src = mod(myrank - 1, ranks)

# GA parameters and operators
N = 30
S_P = RankBasedSelector()
X = UniformRecombinator()
Mut = GaussianMutator(0.1)
max_it = 100

# Island parameters and operators
k = 0.1*N  # deme size
S_M = RandomDemeSelector(k)  # migration selection policy
R_M = WorstDemeSelector(k)  # migration replacement policy
μ = 10  # migration rate

P = unif_rand_vector_pop(N, [0, 0], [π, π])  # initial population

islandlog = Logbook()

islandres = islandGA(islandlog, michalewicz, P, max_it, S_P, X, Mut,
    μ, S_M, R_M, src, dest, comm)

print("""Result on run from rank $(myrank) was $(optimum(islandres)) achieved by $(optimizer(islandres))\n""")
