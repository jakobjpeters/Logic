
using Base: uniontypes
import Base: mapfoldl, mapfoldr, mapreduce

"""
    arity(::LogicalOperator)

Returns the [arity](https://en.wikipedia.org/wiki/Arity)
of the given [`LogicalOperator`](@ref).

# Examples
```jldoctest
julia> arity(tautology)
0

julia> arity(not)
1

julia> arity(and)
2
```
"""
arity(::NullaryOperator) = 0
arity(::UnaryOperator) = 1
arity(::BinaryOperator) = 2

define_atom(p::Symbol) = :(const $p = $(p |> Atom))

"""
    @atoms(ps...)

Instantiate and define [`Atom`](@ref)s with symbols and return a vector containing them.

!!! info
    Atoms are defined in the global scope as constants.

Examples
```jldoctest
julia> @atoms p q
2-element Vector{Atom{Symbol}}:
 p
 q

julia> p
Atom:
 p

julia> q
Atom:
 q
```
"""
macro atoms(ps...)
    quote
        $(map(define_atom, ps)...)
        Atom{Symbol}[$(ps...)]
    end |> esc
end
#=
Source:
Symbolics.jl
https://github.com/JuliaSymbolics/Symbolics.jl
=#

atomize(p::Symbol) = :((@isdefined $p) ? $p : $(p |> Atom))
atomize(x::Expr) = Meta.isexpr(x, [:(=), :kw]) ?
    Expr(x.head, x.args[1], map(atomize, x.args[2:end])...) :
    Expr(x.head, map(atomize, x.args)...)
atomize(x) = x

"""
    @p(expression)

Instantiates all strings and undefined variables as [`Atom`](@ref)s,
and then returns the expression.

# Examples
```jldoctest
julia> @p x = p
Atom:
 p

julia> @p x ∧ q → r
Tree:
 (p ∧ q) → r
```
"""
macro p(expression)
    :($(expression |> atomize)) |> esc
end

"""
    @p_str(x)

# Examples
```jldoctest
julia> p = @p_str("x")
Atom:
 x

julia> p"p ∧ q, Clause(and)"
(x ∧ q, ⊤)
```
"""
macro p_str(p)
    :(@p $(p |> Meta.parse)) |> esc
end

_atoms(p::Atom) = [p]
_atoms(p::Literal) = p.atom |> atoms
_atoms(p::Union{Tree, Clause, Normal}) = mapreduce(atoms, vcat, p |> first_field; init = Atom[])

"""
    atoms(::Proposition)

Returns a vector of unique [`Atom`](@ref)s
contained in the given [`Proposition`](@ref).

!!! warning
    Some atoms may optimized out of an expression, such as in `p ∧ ⊥ == ⊥`.

# Examples
```jldoctest
julia> @p atoms(p ∧ q)
2-element Vector{Atom}:
 p
 q
```
"""
atoms(p::Proposition) = p |> _atoms |> unique!
atoms(p::NullaryOperator) = Atom[]

# Reductions

"""
    ⋀(ps)
    conjunction(ps)

Equivalent to `foldl(and, ps; init = ⊤)`.

`⋀` can be typed by `\\bigwedge<tab>`.

# Examples
```jldoctest
julia> @p ⋀([p, q, r, s])
Tree:
 ((p ∧ q) ∧ r) ∧ s
```
"""
conjunction(ps) = foldl(and, ps)
const ⋀ = conjunction

"""
    ⋁(ps)
    disjunction(ps)

Equivalent to `foldl(or, ps; init = ⊥)`.

`⋁` can be typed by `\\bigvee<tab>`.

# Examples
```jldoctest
julia> @p ⋁([p, q, r, s])
Tree:
 ((p ∨ q) ∨ r) ∨ s
```
"""
disjunction(ps) = foldl(or, ps)
const ⋁ = disjunction

"""
    mapfoldl
"""
mapfoldl(f, lio::LeftIdentityOperator, ps) =
    mapfoldl(f, lio, ps, init = lio |> left_neutrals |> only)

"""
    mapfoldr
"""
mapfoldr(f, rio::RightIdentityOperator, ps) =
    mapfoldr(f, rio, ps, init = rio |> right_neutrals |> only)
    
# import Base: rand
# rand(::Type{Atom})
# rand(::Type{Literal}) = rand([Base.uniontypes(UnaryOperator)]).instance(rand(Atom))
# rand(::Type{Tree})
# rand(::Type{Clause})
# rand(::Type{Normal})
# rand(::Type{Proposition}) = Proposition |> get_concrete_types |> rand |> rand
