
import Base: nand, nor, xor, ⊻, ⊼, ⊽

# Nullary Operators

"""
    tautology()
    ⊤()

Logical [true](https://en.wikipedia.org/wiki/Tautology_(logic)) operator.

`⊤` can be typed by `\\top[TAB]`.

# Examples
```jldoctest
julia> TruthTable([⊤])
┌───┐
│ ⊤ │
├───┤
│ ⊤ │
└───┘
```
"""
function tautology end
const ⊤ = tautology

"""
    contradiction()
    ⊥()

Logical [false](https://en.wikipedia.org/wiki/Contradiction) operator.

`⊥` can be typed by `\\bot[TAB]`.

# Examples
```jldoctest
julia> TruthTable([⊥])
┌───┐
│ ⊥ │
├───┤
│ ⊥ │
└───┘
```
"""
function contradiction end
const ⊥ = contradiction

# Unary Operators

"""
    identity(p)
    𝒾(p)

Logical [identity](https://en.wikipedia.org/wiki/Law_of_identity) operator.

# Examples
```jldoctest
julia> @atomize TruthTable([𝒾(p)])
┌───┐
│ p │
├───┤
│ ⊤ │
│ ⊥ │
└───┘
```
"""
identity
const 𝒾 = identity

"""
    not(p)
    ¬p

Logical [negation](https://en.wikipedia.org/wiki/Negation) operator.

`¬` can be typed by `\\neg[TAB]`.

# Examples
```jldoctest
julia> @atomize TruthTable([¬p])
┌───┬────┐
│ p │ ¬p │
├───┼────┤
│ ⊤ │ ⊥  │
│ ⊥ │ ⊤  │
└───┴────┘
```
"""
function not end
const ¬ = not

# Binary Operators

"""
    and(p, q)
    p ∧ q

Logical [conjunction](https://en.wikipedia.org/wiki/Logical_conjunction) operator.

`∧` can be typed by `\\wedge[TAB]`.

# Examples
```jldoctest
julia> @atomize TruthTable([p ∧ q])
┌───┬───┬───────┐
│ p │ q │ p ∧ q │
├───┼───┼───────┤
│ ⊤ │ ⊤ │ ⊤     │
│ ⊥ │ ⊤ │ ⊥     │
├───┼───┼───────┤
│ ⊤ │ ⊥ │ ⊥     │
│ ⊥ │ ⊥ │ ⊥     │
└───┴───┴───────┘
```
"""
function and end
const ∧ = and

"""
    nand(p, q)
    p ⊼ q

Logical [non-conjunction](https://en.wikipedia.org/wiki/Sheffer_stroke) operator.

`⊼` can be typed by `\\nand[TAB]`.

# Examples
```jldoctest
julia> @atomize TruthTable([p ⊼ q])
┌───┬───┬───────┐
│ p │ q │ p ⊼ q │
├───┼───┼───────┤
│ ⊤ │ ⊤ │ ⊥     │
│ ⊥ │ ⊤ │ ⊤     │
├───┼───┼───────┤
│ ⊤ │ ⊥ │ ⊤     │
│ ⊥ │ ⊥ │ ⊤     │
└───┴───┴───────┘
```
"""
nand

"""
    nor(p, q)
    p ⊽ q

Logical [non-disjunction](https://en.wikipedia.org/wiki/Logical_NOR) operator.

`⊽` can be typed by `\\nor[TAB]`.

# Examples
```jldoctest
julia> @atomize TruthTable([p ⊽ q])
┌───┬───┬───────┐
│ p │ q │ p ⊽ q │
├───┼───┼───────┤
│ ⊤ │ ⊤ │ ⊥     │
│ ⊥ │ ⊤ │ ⊥     │
├───┼───┼───────┤
│ ⊤ │ ⊥ │ ⊥     │
│ ⊥ │ ⊥ │ ⊤     │
└───┴───┴───────┘
```
"""
nor

"""
    or(p, q)
    p ∨ q

Logical [disjunction](https://en.wikipedia.org/wiki/Logical_disjunction) operator.

`∨` can be typed by `\\vee[TAB]`.

# Examples
```jldoctest
julia> @atomize TruthTable([p ∨ q])
┌───┬───┬───────┐
│ p │ q │ p ∨ q │
├───┼───┼───────┤
│ ⊤ │ ⊤ │ ⊤     │
│ ⊥ │ ⊤ │ ⊤     │
├───┼───┼───────┤
│ ⊤ │ ⊥ │ ⊤     │
│ ⊥ │ ⊥ │ ⊥     │
└───┴───┴───────┘
```
"""
function or end
const ∨ = or

"""
    xor(p, q)
    p ⊻ q

Logical [exclusive disjunction](https://en.wikipedia.org/wiki/Exclusive_or) operator.

`⊻` can be typed by `\\xor[TAB]`.

# Examples
```jldoctest
julia> @atomize TruthTable([p ⊻ q])
┌───┬───┬───────┐
│ p │ q │ p ⊻ q │
├───┼───┼───────┤
│ ⊤ │ ⊤ │ ⊥     │
│ ⊥ │ ⊤ │ ⊤     │
├───┼───┼───────┤
│ ⊤ │ ⊥ │ ⊤     │
│ ⊥ │ ⊥ │ ⊥     │
└───┴───┴───────┘
```
"""
xor

"""
    xnor(p, q)
    p ↔ q

Logical [exclusive non-disjunction]
(https://en.wikipedia.org/wiki/Logical_biconditional) operator.

`↔` can be typed by `\\leftrightarrow[TAB]`.

# Examples
```jldoctest
julia> @atomize TruthTable([p ↔ q])
┌───┬───┬───────┐
│ p │ q │ p ↔ q │
├───┼───┼───────┤
│ ⊤ │ ⊤ │ ⊤     │
│ ⊥ │ ⊤ │ ⊥     │
├───┼───┼───────┤
│ ⊤ │ ⊥ │ ⊥     │
│ ⊥ │ ⊥ │ ⊤     │
└───┴───┴───────┘
```
"""
function xnor end
const ↔ = xnor

"""
    not_imply(p, q)
    p ↛ q

Logical [non-implication](https://en.wikipedia.org/wiki/Material_nonimplication) operator.

`↛` can be typed by `\\nrightarrow[TAB]`.

# Examples
```jldoctest
julia> @atomize TruthTable([p ↛ q])
┌───┬───┬───────┐
│ p │ q │ p ↛ q │
├───┼───┼───────┤
│ ⊤ │ ⊤ │ ⊥     │
│ ⊥ │ ⊤ │ ⊥     │
├───┼───┼───────┤
│ ⊤ │ ⊥ │ ⊤     │
│ ⊥ │ ⊥ │ ⊥     │
└───┴───┴───────┘
```
"""
function not_imply end
const ↛ = not_imply

"""
    imply(p, q)
    p → q

Logical [implication](https://en.wikipedia.org/wiki/Material_conditional) operator.

`→` can be typed by `\\rightarrow[TAB]`.

# Examples
```jldoctest
julia> @atomize TruthTable([p → q])
┌───┬───┬───────┐
│ p │ q │ p → q │
├───┼───┼───────┤
│ ⊤ │ ⊤ │ ⊤     │
│ ⊥ │ ⊤ │ ⊤     │
├───┼───┼───────┤
│ ⊤ │ ⊥ │ ⊥     │
│ ⊥ │ ⊥ │ ⊤     │
└───┴───┴───────┘
```
"""
function imply end
const → = imply

"""
    not_converse_imply(p, q)
    p ↚ q

Logical [converse non-implication](https://en.wikipedia.org/wiki/Converse_nonimplication) operator.

`↚` can be typed by `\\nleftarrow[TAB]`.

# Examples
```jldoctest
julia> @atomize TruthTable([p ↚ q])
┌───┬───┬───────┐
│ p │ q │ p ↚ q │
├───┼───┼───────┤
│ ⊤ │ ⊤ │ ⊥     │
│ ⊥ │ ⊤ │ ⊤     │
├───┼───┼───────┤
│ ⊤ │ ⊥ │ ⊥     │
│ ⊥ │ ⊥ │ ⊥     │
└───┴───┴───────┘
```
"""
function not_converse_imply end
const ↚ = not_converse_imply

"""
    converse_imply(p, q)
    p ← q

Logical [converse implication](https://en.wikipedia.org/wiki/Converse_(logic)#Implicational_converse) operator.

`←` can be typed by `\\leftarrow[TAB]`.

# Examples
```jldoctest
julia> @atomize TruthTable([p ← q])
┌───┬───┬───────┐
│ p │ q │ p ← q │
├───┼───┼───────┤
│ ⊤ │ ⊤ │ ⊤     │
│ ⊥ │ ⊤ │ ⊥     │
├───┼───┼───────┤
│ ⊤ │ ⊥ │ ⊤     │
│ ⊥ │ ⊥ │ ⊤     │
└───┴───┴───────┘
```
"""
function converse_imply end
const ← = converse_imply

# Nary Operators

"""
    conjunction(ps)
    ⋀(ps)

Equivalent to `something(foldl(∧, ps; init = Some(⊤)))`.

`⋀` can be typed by `\\bigwedge[TAB]`.

See also [`and`](@ref) and [`tautology`](@ref).

# Examples
```jldoctest
julia> @atomize ⋀((p, q, r, s))
((p ∧ q) ∧ r) ∧ s
```
"""
conjunction(ps) = something(foldl(∧, ps; init = Some(⊤)))::Proposition
const ⋀ = conjunction

"""
    disjunction(ps)
    ⋁(ps)

Equivalent to `something(foldl(∨, ps; init = Some(⊥)))`.

`⋁` can be typed by `\\bigvee[TAB]`.

See also [`or`](@ref) and [`contradiction`](@ref).

# Examples
```jldoctest
julia> @atomize ⋁((p, q, r, s))
((¬¬p ∨ q) ∨ r) ∨ s
```
"""
disjunction(ps) = something(foldl(∨, ps; init = Some(⊥)))::Proposition
const ⋁ = disjunction

# Internals

"""
    FoldDirection

A trait to indicate which direction to fold an operator.

Supertype of [`Left`](@ref) and [`Right`](@ref).
"""
abstract type FoldDirection end

"""
    Left <: FoldDirection

A trait to indicate that an operator should fold left.

Subtype of [`FoldDirection`](@ref).
"""
struct Left <: FoldDirection end

"""
    Right <: FoldDirection

A trait to indicate that an operator should fold right.

Subtype of [`FoldDirection`](@ref).
"""
struct Right <: FoldDirection end

"""
    fold_direction(operator)

Return the [`FoldDirection`](@ref) of the given `operator`.

If the `operator` has no `FoldDirection`, return `nothing`.

```jldoctest
julia> PAndQ.fold_direction(→)
PAndQ.Left()

julia> PAndQ.fold_direction(←)
PAndQ.Right()

julia> PAndQ.fold_direction(⊼)
```
"""
fold_direction(::union_typeof((∧, ↔, →, ∨, ⊻, ↚))) = Left()
fold_direction(::union_typeof((↛, ←))) = Right()
fold_direction(operator) = nothing

## Union Types

"""
    NullaryOperator

The `Union` of [Nullary Operators](@ref nullary_operators).
"""
const NullaryOperator = union_typeof((⊤, ⊥))

"""
    UnaryOperator

The `Union` of [Unary Operators](@ref unary_operators).
"""
const UnaryOperator = union_typeof((𝒾, ¬))

"""
    BinaryOperator

The `Union` of [Binary Operators](@ref binary_operators).
"""
const BinaryOperator = union_typeof((∧, ⊼, ⊽, ∨, ⊻, ↔, →, ↛, ←, ↚))

"""
    NaryOperator

The `Union` of [Nary Operators](@ref nary_operators).
"""
const NaryOperator = union_typeof((⋀, ⋁))

"""
    Operator

The `Union` of [Operators](@ref operators_operators).
"""
const Operator = Union{NullaryOperator, UnaryOperator, BinaryOperator, NaryOperator}

"""
    AndOr

The `Union` of [`and`](@ref) and [`or`](@ref).
"""
const AndOr = union_typeof((∧, ∨))

# Utilities

"""
    arity(operator)

Return the [arity](https://en.wikipedia.org/wiki/Arity)
of the given [operator](@ref operators_operators).

# Examples
```jldoctest
julia> arity(⊤)
0

julia> arity(¬)
1

julia> arity(∧)
2

julia> arity(⋀)
Inf
```
"""
arity(::NullaryOperator) = 0
arity(::UnaryOperator) = 1
arity(::BinaryOperator) = 2
arity(::NaryOperator) = Inf

___map_reducers(f, operator, xs, ::Left) = mapfoldl(f, operator, xs; init = Some(first(left_neutrals(operator))))
___map_reducers(f, operator, xs, ::Right) = mapfoldr(f, operator, xs; init = Some(first(right_neutrals(operator))))
___map_reducers(f, operator, xs, ::Nothing) = mapfoldl(f, operator, xs)
__map_reducers(f, operator, xs) = g -> (args...) -> ___map_reducers(x -> f(g)(args..., x), operator, xs, fold_direction(operator))
_map_reducers() = 𝒾
_map_reducers((operator, xs)) = __map_reducers(𝒾, operator, xs)
_map_reducers((operator, xs), pairs...) = __map_reducers(_map_reducers(pairs...), operator, xs)

"""
    map_reducers(f, pairs...)

Similar to `mapreduce`, but with an arbitrary number of nested reductions.

The function `f` must accept as many arguments as there are `pairs`.
Each pair must be a two element iterable where the first element is a
binary operator and the second element is an iterable.

The purpose of this function is to simplify the following pattern:

```julia
mapreduce(a, xs) do x
    mapreduce(b, ys) do y
        ...
            f(x, y, zs...)
        ...
    end
end
```

This can be rewritten as:

```julia
map_reducers(a => xs, b => ys, ...) do (x, y, zs...)
    f(x, y, zs...)
end
```

Using `do` notation corresponds to mathematical syntax. For example:

```math
\\bigwedge\\limits_{i = 1}^n \\bigvee\\limits_{j = 1}^m f(i, j)
```

# Examples
```jldoctest
julia> map_reducers(⊤)
tautology (generic function with 1 method)

julia> @atomize map_reducers(i -> \$i, (∧) => 1:2)
\$(1) ∧ \$(2)

julia> @atomize map_reducers((i, j) -> \$(i, j), (∧) => 1:2, (∨) => 1:2)
(¬¬\$((1, 1)) ∨ \$((1, 2))) ∧ (¬¬\$((2, 1)) ∨ \$((2, 2)))
```
"""
map_reducers(f, pairs...) = _map_reducers(pairs...)(f)()
