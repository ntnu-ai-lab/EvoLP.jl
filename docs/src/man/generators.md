# Population Generators

To initialise the population, a number of random generators are provided.

## Vector-based populations

For EAs and GAs.

### Discrete domains

```@docs
binary_vector_pop
permutation_vector_pop
```

### Continuous domains

```@docs
normal_rand_vector_pop
unif_rand_vector_pop
```

## Particle-based populations

For particle-swarm optimisation.

!!! compat "EvoLP 1.1"
    `Particle` objects in EvoLP pre-v.1.1 had no fitness placeholders.
    If you use a custom `Particle` generator, you might want to update it.
    For built-in generators and algorithms, the update would not be noticeable.

```@docs
Particle
```

```@docs
unif_rand_particle_pop
normal_rand_particle_pop
```
