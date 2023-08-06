
import Base: identity, nand, ⊼, nor, ⊽, xor, ⊻

# Nullary Operators

"""
    ⊤()
    tautology()

Logical [true](https://en.wikipedia.org/wiki/Tautology_(logic)) operator.

`⊤` can be typed by `\\top<tab>`.

# Examples
```jldoctest
julia> ⊤()
tautology (generic function with 1 method)

julia> @p TruthTable(⊤)
┌────────┐
│ ⊤      │
│ Clause │
├────────┤
│ ⊤      │
└────────┘
```
"""
function tautology end
const ⊤ = tautology

"""
    ⊥()
    contradiction()

Logical [false](https://en.wikipedia.org/wiki/Contradiction) operator.

`⊥` can be typed by `\\bot<tab>`.

# Examples
```jldoctest
julia> ⊥()
contradiction (generic function with 1 method)

julia> @p TruthTable(⊥)
┌────────┐
│ ⊥      │
│ Clause │
├────────┤
│ ⊥      │
└────────┘
```
"""
function contradiction end
const ⊥ = contradiction

# Unary Operators

"""
    identity(::Proposition)

Logical [identity](https://en.wikipedia.org/wiki/Law_of_identity) operator.

# Examples
```jldoctest
julia> @p TruthTable(p)
┌──────┐
│ p    │
│ Atom │
├──────┤
│ ⊤    │
│ ⊥    │
└──────┘
```
"""
function identity end

"""
    ¬p
    ¬(p)
    not(p)

Logical [negation](https://en.wikipedia.org/wiki/Negation) operator.

`¬` can be typed by `\\neg<tab>`.

# Examples
```jldoctest
julia> @p TruthTable(¬p)
┌──────┬─────────┐
│ p    │ ¬p      │
│ Atom │ Literal │
├──────┼─────────┤
│ ⊤    │ ⊥       │
│ ⊥    │ ⊤       │
└──────┴─────────┘
```
"""
function not end
const ¬ = not

# Binary Operators

"""
    p ∧ q
    ∧(p, q)
    and(p, q)

Logical [conjunction](https://en.wikipedia.org/wiki/Logical_conjunction) operator.

`∧` can be typed by `\\wedge<tab>`.

# Examples
```jldoctest
julia> @p TruthTable(p ∧ q)
┌──────┬──────┬───────┐
│ p    │ q    │ p ∧ q │
│ Atom │ Atom │ Tree  │
├──────┼──────┼───────┤
│ ⊤    │ ⊤    │ ⊤     │
│ ⊥    │ ⊤    │ ⊥     │
├──────┼──────┼───────┤
│ ⊤    │ ⊥    │ ⊥     │
│ ⊥    │ ⊥    │ ⊥     │
└──────┴──────┴───────┘
```
"""
function and end
const ∧ = and

"""
    p ⊼ q
    ⊼(p, q)
    nand(p, q)

Logical [non-conjunction](https://en.wikipedia.org/wiki/Sheffer_stroke) operator.

`⊼` can be typed by `\\nand<tab>`.

# Examples
```jldoctest
julia> @p TruthTable(p ⊼ q)
┌──────┬──────┬───────┐
│ p    │ q    │ p ⊼ q │
│ Atom │ Atom │ Tree  │
├──────┼──────┼───────┤
│ ⊤    │ ⊤    │ ⊥     │
│ ⊥    │ ⊤    │ ⊤     │
├──────┼──────┼───────┤
│ ⊤    │ ⊥    │ ⊤     │
│ ⊥    │ ⊥    │ ⊤     │
└──────┴──────┴───────┘
```
"""
function nand end

"""
    p ⊽ q
    ⊽(p, q)
    nor(p, q)

Logical [non-disjunction](https://en.wikipedia.org/wiki/Logical_NOR) operator.

`⊽` can be typed by `\\nor<tab>`.

# Examples
```jldoctest
julia> @p TruthTable(p ⊽ q)
┌──────┬──────┬───────┐
│ p    │ q    │ p ⊽ q │
│ Atom │ Atom │ Tree  │
├──────┼──────┼───────┤
│ ⊤    │ ⊤    │ ⊥     │
│ ⊥    │ ⊤    │ ⊥     │
├──────┼──────┼───────┤
│ ⊤    │ ⊥    │ ⊥     │
│ ⊥    │ ⊥    │ ⊤     │
└──────┴──────┴───────┘
```
"""
function nor end

"""
    p ∨ q
    ∨(p, q)
    or(p, q)

Logical [disjunction](https://en.wikipedia.org/wiki/Logical_disjunction) operator.

`∨` can be typed by `\\vee<tab>`.

# Examples
```jldoctest
julia> @p TruthTable(p ∨ q)
┌──────┬──────┬───────┐
│ p    │ q    │ p ∨ q │
│ Atom │ Atom │ Tree  │
├──────┼──────┼───────┤
│ ⊤    │ ⊤    │ ⊤     │
│ ⊥    │ ⊤    │ ⊤     │
├──────┼──────┼───────┤
│ ⊤    │ ⊥    │ ⊤     │
│ ⊥    │ ⊥    │ ⊥     │
└──────┴──────┴───────┘
```
"""
function or end
const ∨ = or

"""
    p ⊻ q
    ⊻(p, q)
    xor(p, q)

Logical [exclusive disjunction](https://en.wikipedia.org/wiki/Exclusive_or) operator.

`⊻` can be typed by `\\xor<tab>`.

# Examples
```jldoctest
julia> @p TruthTable(p ⊻ q)
┌──────┬──────┬───────┐
│ p    │ q    │ p ⊻ q │
│ Atom │ Atom │ Tree  │
├──────┼──────┼───────┤
│ ⊤    │ ⊤    │ ⊥     │
│ ⊥    │ ⊤    │ ⊤     │
├──────┼──────┼───────┤
│ ⊤    │ ⊥    │ ⊤     │
│ ⊥    │ ⊥    │ ⊥     │
└──────┴──────┴───────┘
```
"""
function xor end

"""
    p ↔ q
    ↔(p, q)
    xnor(p, q)

Logical [exclusive non-disjunction](https://en.wikipedia.org/wiki/XNOR_gate)
and [biconditional](https://en.wikipedia.org/wiki/Logical_biconditional) operator.

`↔` can be typed by `\\leftrightarrow<tab>`.

# Examples
```jldoctest
julia> @p TruthTable(p ↔ q)
┌──────┬──────┬───────┐
│ p    │ q    │ p ↔ q │
│ Atom │ Atom │ Tree  │
├──────┼──────┼───────┤
│ ⊤    │ ⊤    │ ⊤     │
│ ⊥    │ ⊤    │ ⊥     │
├──────┼──────┼───────┤
│ ⊤    │ ⊥    │ ⊥     │
│ ⊥    │ ⊥    │ ⊤     │
└──────┴──────┴───────┘
```
"""
function xnor end
const ↔ = xnor

"""
    p ↛ q
    ↛(p, q)
    not_imply(p, q)

Logical [non-implication](https://en.wikipedia.org/wiki/Material_nonimplication) operator.

`↛` can be typed by `\\nrightarrow<tab>`.

# Examples
```jldoctest
julia> @p TruthTable(p ↛ q)
┌──────┬──────┬───────┐
│ p    │ q    │ p ↛ q │
│ Atom │ Atom │ Tree  │
├──────┼──────┼───────┤
│ ⊤    │ ⊤    │ ⊥     │
│ ⊥    │ ⊤    │ ⊥     │
├──────┼──────┼───────┤
│ ⊤    │ ⊥    │ ⊤     │
│ ⊥    │ ⊥    │ ⊥     │
└──────┴──────┴───────┘
```
"""
function not_imply end
const ↛ = not_imply

"""
    p → q
    →(p, q)
    imply(p, q)

Logical [implication](https://en.wikipedia.org/wiki/Material_conditional) operator.

`→` can be typed by `\\rightarrow<tab>`.

# Examples
```jldoctest
julia> @p TruthTable(p → q)
┌──────┬──────┬───────┐
│ p    │ q    │ p → q │
│ Atom │ Atom │ Tree  │
├──────┼──────┼───────┤
│ ⊤    │ ⊤    │ ⊤     │
│ ⊥    │ ⊤    │ ⊤     │
├──────┼──────┼───────┤
│ ⊤    │ ⊥    │ ⊥     │
│ ⊥    │ ⊥    │ ⊤     │
└──────┴──────┴───────┘
```
"""
function imply end
const → = imply

"""
    p ↚ q
    ↚(p, q)
    not_converse_imply(p, q)

Logical [converse non-implication](https://en.wikipedia.org/wiki/Converse_nonimplication) operator.

`↚` can be typed by `\\nleftarrow<tab>`.

# Examples
```jldoctest
julia> @p TruthTable(p ↚ q)
┌──────┬──────┬───────┐
│ p    │ q    │ p ↚ q │
│ Atom │ Atom │ Tree  │
├──────┼──────┼───────┤
│ ⊤    │ ⊤    │ ⊥     │
│ ⊥    │ ⊤    │ ⊤     │
├──────┼──────┼───────┤
│ ⊤    │ ⊥    │ ⊥     │
│ ⊥    │ ⊥    │ ⊥     │
└──────┴──────┴───────┘
```
"""
function not_converse_imply end
const ↚ = not_converse_imply

"""
    p ← q
    ←(p, q)
    converse_imply(p, q)

Logical [converse implication](https://en.wikipedia.org/wiki/Converse_(logic)#Implicational_converse) operator.

`←` can be typed by `\\leftarrow<tab>`.

# Examples
```jldoctest
julia> @p TruthTable(p ← q)
┌──────┬──────┬───────┐
│ p    │ q    │ p ← q │
│ Atom │ Atom │ Tree  │
├──────┼──────┼───────┤
│ ⊤    │ ⊤    │ ⊤     │
│ ⊥    │ ⊤    │ ⊥     │
├──────┼──────┼───────┤
│ ⊤    │ ⊥    │ ⊤     │
│ ⊥    │ ⊥    │ ⊤     │
└──────┴──────┴───────┘
```
"""
function converse_imply end
const ← = converse_imply

# Unions of Operators
# TODO: make traits?

union_typeof(xs) = Union{map(typeof, xs)...}

"""
    NullaryOperator

The `Union` of [`LogicalOperator`](@ref)s that take zero arguments.
"""
const NullaryOperator = union_typeof((tautology, contradiction))

"""
    UnaryOperator

The `Union` of [`LogicalOperator`](@ref)s that take one argument.
"""
const UnaryOperator = union_typeof((identity, not))

"""
    BinaryOperator

The `Union` of [`LogicalOperator`](@ref)s that take two arguments.
"""
const BinaryOperator = union_typeof((
    and, nand, nor, or, xor, xnor, imply, not_imply, converse_imply, not_converse_imply
))

"""
    LogicalOperator

The `Union` of [logical operators](@ref operators_operators).
"""
const LogicalOperator = Union{NullaryOperator, UnaryOperator, BinaryOperator}

"""
    CommutativeOperator

The `Union` of [`LogicalOperator`](@ref)s with the [commutative property]
(https://en.wikipedia.org/wiki/Commutative_property).
"""
const CommutativeOperator = union_typeof((and, nand, nor, or, xor, xnor))

"""
    AssociativeOperator

The `Union` of [`LogicalOperator`](@ref)s with the [associative property]
(https://en.wikipedia.org/wiki/Associative_property).
"""
const AssociativeOperator = union_typeof((and, or, xor, xnor))

"""
    LeftIdentityOperator

The `Union` of [`LogicalOperator`](@ref)s that have a [`left_identity`](@ref).
"""
const LeftIdentityOperator = Union{
    AssociativeOperator,
    union_typeof((imply, not_converse_imply))
}

"""
    RightIdentityOperator

The `Union` of [`LogicalOperator`](@ref)s that have a [`right_identity`](@ref).
"""
const RightIdentityOperator = Union{
    AssociativeOperator,
    union_typeof((not_imply, converse_imply))
}

"""
    AndOr

The `Union` of [`and`](@ref) and [`or`](@ref).
"""
const AndOr = union_typeof((and, or))
