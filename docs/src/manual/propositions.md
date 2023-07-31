
# Propositions

!!! tip
    Propositions can be converted into different, but logically equivalent forms (see also [`==`](@ref)). For example, `⊥ == Tree(⊥) == Clause(⊥) == Normal(⊥)`. However, not all forms are [`Expressive`](@ref)ly complete. Otherwise, the conversion may throw an exception. For example, there is no way to represent `Literal(⊥)`.

```@example
import AbstractTrees: children # hide
using AbstractTrees: print_tree # hide
using InteractiveUtils: subtypes # hide
using PAndQ: Proposition # hide

children(x::Type) = subtypes(x) # hide
print_tree(Proposition) # hide
```

```@docs
Proposition
Compound
Expressive
Atom
Literal
Tree
Clause
Normal
```
