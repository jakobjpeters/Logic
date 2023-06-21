
<!--
    This file is generated by `.github/workflows/readme.yml` - do not edit directly
-->

<p align="center">
    <img width="200px" src="docs/src/assets/logo.svg"/>
</p>

<div align="center">

[![Documentation dev](https://img.shields.io/badge/Documentation-dev-blue.svg)](https://jakobjpeters.github.io/PAQ.jl/dev/)
[![Codecov](https://codecov.io/gh/jakobjpeters/PAQ.jl/branch/main/graph/badge.svg?token=XFWU66WSD7)](https://codecov.io/gh/jakobjpeters/PAQ.jl)
![License](https://img.shields.io/github/license/jakobjpeters/PAQ.jl)

[![Documentation](https://github.com/jakobjpeters/PAQ.jl/workflows/Documentation/badge.svg)](https://github.com/jakobjpeters/PAQ.jl/actions/documentation.yml)
[![Continuous Integration](https://github.com/jakobjpeters/PAQ.jl/workflows/Continuous%20Integration/badge.svg)](https://github.com/jakobjpeters/PAQ.jl/actions/continuous_integration.yml)

<!-- ![Version](https://img.shields.io/github/v/release/jakobjpeters/PAQ.jl) -->
<!-- [![Downloads](https://shields.io/endpoint?url=https://pkgs.genieframework.com/api/v1/badge/PAQ)](https://pkgs.genieframework.com?packages=PAQ) -->

</div>

## Introduction

If you like propositional logic, then you've come to the right place!

P∧Q has an intuitive interface that enables you to manipulate logical expressions symbolically. Propositions have multiple representations which can be easily converted and extended. Several utilities have been provided for convenience, visualization, and solving propositions.

## Showcase

```julia
julia> import Pkg

julia> Pkg.add(url = "https://github.com/jakobjpeters/PAQ.jl")

julia> using PAQ

julia> ¬⊥
tautology (generic function with 1 method)

julia> @atoms p q
2-element Vector{Atom{Symbol}}:
 p
 q

julia> r = ¬p
Literal:
 ¬p

julia> s = Clause(and, p, ¬q)
Clause:
 p ∧ ¬q

julia> @p t = ((q ∧ r) ↔ a)(a => ⊤)
Normal:
 (q) ∧ (¬p)

julia> u = s ∨ t
Normal:
 (p ∧ ¬q) ∨ (q ∧ ¬p)

julia> TruthTable(p ∧ ¬p, r, p ⊻ q, u)
┌────────┬──────┬──────┬─────────┬────────────────────────────┐
│ p ∧ ¬p │ p    │ q    │ ¬p      │ p ⊻ q, (p ∧ ¬q) ∨ (q ∧ ¬p) │
│ Tree   │ Atom │ Atom │ Literal │ Tree, Normal               │
├────────┼──────┼──────┼─────────┼────────────────────────────┤
│ ⊥      │ ⊤    │ ⊤    │ ⊥       │ ⊥                          │
│ ⊥      │ ⊥    │ ⊤    │ ⊤       │ ⊤                          │
├────────┼──────┼──────┼─────────┼────────────────────────────┤
│ ⊥      │ ⊤    │ ⊥    │ ⊥       │ ⊤                          │
│ ⊥      │ ⊥    │ ⊥    │ ⊤       │ ⊥                          │
└────────┴──────┴──────┴─────────┴────────────────────────────┘
```

## Related Packages

- [Julog.jl](https://github.com/ztangent/Julog.jl)
- [LogicCircuits.jl](https://github.com/Juice-jl/LogicCircuits.jl)
- [Symbolics.jl](https://github.com/JuliaSymbolics/Symbolics.jl)
- [Rewrite.jl](https://github.com/HarrisonGrodin/Rewrite.jl)
- [Simplify.jl](https://github.com/HarrisonGrodin/Simplify.jl)
- [Metatheory.jl](https://github.com/JuliaSymbolics/Metatheory.jl)
- [TruthTables.jl](https://github.com/eliascarv/TruthTables.jl)
- [SoleLogics.jl](https://github.com/aclai-lab/SoleLogics.jl)
