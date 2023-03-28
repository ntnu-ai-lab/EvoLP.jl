# Algorithms

EvoLP provides some basic built-in algorithms to get you started.

## Evolutionary Algorithms (EA)

The basic 1+1 EA starts with a _vector_ individual and slowly finds its way to an optimum by only using mutation.

```@docs
oneplusone
```

## Genetic Algorithms (GA)

In a GA a population of _vector_ solutions is simulated, where individuals get selected, recombined, and mutated.
The built-in implementation in EvoLP is a _generational_ GA taken from [Kochenderfer, M.J. and Wheeler, T.A. 2019](https://algorithmsbook.com/optimization/), in which means the whole population is replaced by its offspring at every iteration.

```@docs
GA
```

## Particle Swarm Optimisation (PSO)

In PSO, individuals are [_particles_](generators.md#Particle-based-populations) with velocity and memory.
At each iteration, a particle changes its velocity considering the neighbouring particles as well as the best position of the whole swarm.

The built-in implementation in EvoLP is taken from [Kochenderfer, M.J. and Wheeler, T.A. 2019](https://algorithmsbook.com/optimization/).

```@docs
PSO
```
