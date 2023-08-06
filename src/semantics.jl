
import Base: ==, Fix1, convert, Bool, uniontypes

"""
    p == q
    ==(p, q)

Returns a boolean indicating whether `p` and `q` are [logically equivalent]
(https://en.wikipedia.org/wiki/Logical_equivalence).

!!! info
    The `≡` symbol is sometimes used to represent logical equivalence.
    However, Julia uses `≡` as an alias for the builtin function `===`
    which cannot have methods added to it.
    Use `==` and `===` to test for equivalence and identity, respectively.

See also [`Proposition`](@ref).

# Examples
```jldoctest
julia> @p p == ¬p
false

julia> @p ¬(p ⊻ q) == (p → q) ∧ (p ← q)
true

julia> @p ¬(p ⊻ q) === (p → q) ∧ (p ← q)
false
```
"""
==(p::Union{NullaryOperator, Atom}, q::Union{NullaryOperator, Atom}) = p === q
==(p::Union{NullaryOperator, Proposition}, q::Union{NullaryOperator, Proposition}) =
    is_tautology(p ↔ q)

"""
    interpret(p::Union{NullaryOperator, Proposition}, valuation...)

Replaces each [`Atom`](@ref) in `p` with its truth value in `valuation`,
then simplifies.

`valuation` is either a `Dict` or a set that can construct one
that maps from atoms to their respective truth values.

Calling `p` with an incomplete mapping will partially interpret it.

See also [`tautology`](@ref) and [`contradiction`].

# Examples
```jldoctest
julia> @p interpret(¬p, p => ⊤)
contradiction (generic function with 1 method)

julia> @p p = Clause(and, q, r, s)
Clause:
 q ∧ r ∧ s

julia> @p interpret(p, q => ⊤, r => ⊤)
Clause:
 s
```
"""
interpret(p::NullaryOperator, valuation::Dict) = p
interpret(p::Atom, valuation::Dict) = get(valuation, p, p)
interpret(p::Literal{UO}, valuation::Dict) where UO =
    UO.instance(interpret(p.atom, valuation))
function interpret(p::CN, valuation::Dict) where {AO, CN <: Union{Clause{AO}, Normal{AO}}}
    neutral_element = left_identity(AO.instance)
    not_neutral_element = not(neutral_element)
    q = getfield(Main, nameof(CN))(AO.instance)

    for r in first_field(p)
        s = interpret(r, valuation)
        s == not_neutral_element && return not_neutral_element
        q = AO.instance(q, s)
    end

    isempty(first_field(q)) ? neutral_element : q
end
interpret(p::Proposition, valuation::Dict) = interpret(Normal(p), valuation)
interpret(p, valuation) = interpret(p, Dict(valuation))
interpret(p, valuation...) = interpret(p, valuation)

"""
    (p::Proposition)(valuation...)

Equivalent to [`interpret(p, valuation)`](@ref interpret) for all [`Proposition`](@ref)s.

# Examples
```jldoctest
julia> @p (¬p)(p => ⊤)
contradiction (generic function with 1 method)

julia> @p p = Clause(and, q, r, s)
Clause:
 q ∧ r ∧ s

julia> @p p(q => ⊤, r => ⊤)
Clause:
 s
```
"""
(p::Proposition)(valuation::Dict) = interpret(p, valuation)
(p::Proposition)(valuation...) = interpret(p, valuation)

"""
    valuations(atoms)
    valuations(::Proposition)

Return an iterator containing every possible valuation of the [`Atom`](@ref)s.

A valuation is a vector of `Pair`s which map from an atom to a truth value.

# Examples
```jldoctest
julia> @p collect(valuations([p]))
2-element Vector{Vector}:
 Pair{Atom{Symbol}, typeof(tautology)}[p => PAndQ.tautology]
 Pair{Atom{Symbol}, typeof(contradiction)}[p => PAndQ.contradiction]

julia> @p collect(valuations([p, q]))
4-element Vector{Vector}:
 Pair{Atom{Symbol}, typeof(tautology)}[p => PAndQ.tautology, q => PAndQ.tautology]
 Pair{Atom{Symbol}}[p => PAndQ.contradiction, q => PAndQ.tautology]
 Pair{Atom{Symbol}}[p => PAndQ.tautology, q => PAndQ.contradiction]
 Pair{Atom{Symbol}, typeof(contradiction)}[p => PAndQ.contradiction, q => PAndQ.contradiction]
```
"""
function valuations(atoms)
    n = length(atoms)
    Iterators.map(
        i -> map(
            (left, right) -> left => right == 0 ? tautology : contradiction,
            atoms, digits(i, base = 2, pad = n)
        ),
        0:BigInt(2) ^ n - 1
    )
end
valuations(p::Proposition) = valuations(atoms(p))
valuations(no::NullaryOperator) = [no => no]

"""
    interpretations(p, valuations = valuations(p))

Return an iterator of values given by [`interpret`](@ref)ing `p` by each valuation.

See also [`valuations`](@ref).

# Examples
```jldoctest
julia> @p collect(interpretations(p))
2-element Vector{Function}:
 tautology (generic function with 1 method)
 contradiction (generic function with 1 method)

julia> @p collect(interpretations(p → q, [p => ⊤]))
1-element Vector{Normal{typeof(and), Clause{typeof(or), Literal{typeof(identity), Symbol}}}}:
 (q)
```
"""
interpretations(p, valuations = valuations(p)) =
    Iterators.map(valuation -> interpret(p, valuation), valuations)

"""
    solve(p, truth_value = ⊤)

Return a vector containing all [`interpretations`](@ref) such that
`interpret(p, interpretation) == truth_value`.

# Examples
```jldoctest
julia> @p collect(solve(p))
1-element Vector{Vector{Pair{Atom{Symbol}, typeof(tautology)}}}:
 [p => PAndQ.tautology]

julia> @p collect(solve(p ⊻ q, ⊥))
2-element Vector{Vector}:
 Pair{Atom{Symbol}, typeof(tautology)}[p => PAndQ.tautology, q => PAndQ.tautology]
 Pair{Atom{Symbol}, typeof(contradiction)}[p => PAndQ.contradiction, q => PAndQ.contradiction]
```
"""
function solve(p, truth_value = ⊤)
    _valuations = valuations(p)
    _interpretations = interpretations(p, _valuations)
    Iterators.map(first, Iterators.filter(zip(_valuations, _interpretations)) do (valuation, interpretation)
        interpretation == truth_value
    end)
end

"""
    left_identity(::LogicalOperator)

Return the corresponding identity element or `nothing` if it does not exist.
The identity element is either [`tautology`](@ref) or [`contradiction`](@ref).

# Examples
```jldoctest
julia> left_identity(or)
contradiction (generic function with 1 method)

julia> left_identity(imply)
tautology (generic function with 1 method)
```
"""
left_identity(::union_typeof((and, xnor, imply))) = tautology
left_identity(::union_typeof((or, xor, not_converse_imply))) = contradiction
left_identity(::LogicalOperator) = nothing

"""
    right_identity(::LogicalOperator)

Return the corresponding identity element or `nothing` if it does not exist.
The identity element is either [`tautology`](@ref) or [`contradiction`](@ref).

# Examples
```jldoctest
julia> right_identity(or)
contradiction (generic function with 1 method)

julia> right_identity(converse_imply)
tautology (generic function with 1 method)
```
"""
right_identity(::union_typeof((and, xnor, converse_imply))) = tautology
right_identity(::union_typeof((or, xor, not_imply))) = contradiction
right_identity(::LogicalOperator) = nothing

eval_doubles(f, doubles) = for double in doubles
    for (left, right) in (double, reverse(double))
        @eval $f(::typeof($left)) = $right
    end
end

"""
    converse(::LogicalOperator)

Returns the [`LogicalOperator`](@ref) that is the
[converse](https://en.wikipedia.org/wiki/Converse_(logic))
of the given boolean operator.

# Examples
```jldoctest
julia> converse(and)
and (generic function with 23 methods)

julia> @p and(p, q) == converse(and)(q, p)
true

julia> converse(imply)
converse_imply (generic function with 7 methods)

julia> @p imply(p, q) == converse(imply)(q, p)
true
```
"""
converse(co::CommutativeOperator) = co
eval_doubles(:converse, ((imply, converse_imply), (not_imply, not_converse_imply)))

"""
    dual(::LogicalOperator)

Returns the [`LogicalOperator`](@ref) that is the
[dual](https://en.wikipedia.org/wiki/Boolean_algebra#Duality_principle)
of the given boolean operator.

# Examples
```jldoctest
julia> dual(and)
or (generic function with 19 methods)

julia> @p and(p, q) == not(dual(and)(not(p), not(q)))
true

julia> dual(imply)
not_converse_imply (generic function with 6 methods)

julia> @p imply(p, q) == not(dual(imply)(not(p), not(q)))
true
```
"""
dual(bo::union_typeof((tautology, contradiction, xor, xnor))) = not(bo)
eval_doubles(:dual, (
    (and, or),
    (nand, nor),
    (xor, xnor),
    (imply, not_converse_imply),
    (not_imply, converse_imply)
))
# TODO: `dual(::typeof(not))` and `dual(::typeof(identity))` ?

"""
    is_tautology(p)

Returns a boolean on whether `p` is a [`tautology`](@ref).

# Examples
```jldoctest
julia> is_tautology(⊤)
true

julia> @p is_tautology(p)
false

julia> @p is_tautology(¬(p ∧ ¬p))
true
```
"""
is_tautology(p) = all(isequal(⊤), interpretations(p))
is_tautology(::LiteralProposition) = false

"""
    is_contradiction(p)

Returns a boolean on whether `p` is a [`contradiction`](@ref).

# Examples
```jldoctest
julia> is_contradiction(⊥)
true

julia> @p is_contradiction(p)
false

julia> @p is_contradiction(p ∧ ¬p)
true
```
"""
is_contradiction(p) = is_tautology(¬p)

"""
    is_truth(p)

Returns a boolean on whether `p` is a truth value
(either a [`tautology`](@ref) or [`contradiction`](@ref)).

See also [`Proposition`](@ref).

# Examples
```jldoctest
julia> is_truth(⊤)
true

julia> @p is_truth(p ∧ ¬p)
true

julia> @p is_truth(p)
false

julia> @p is_truth(p ∧ q)
false
```
"""
function is_truth(p)
    _first, _interpretations = Iterators.peel(interpretations(p))
    all(isequal(_first), _interpretations)
end
is_truth(::LiteralProposition) = false

"""
    is_contingency(p)

Returns a boolean on whether `p` is a
[contingency](https://en.wikipedia.org/wiki/Contingency_(philosophy))
(neither a [`tautology`](@ref) or [`contradiction`](@ref)).

See also [`Proposition`](@ref).

# Examples
```jldoctest
julia> is_contingency(⊤)
false

julia> @p is_contingency(p ∧ ¬p)
false

julia> @p is_contingency(p)
true

julia> @p is_contingency(p ∧ q)
true
```
"""
is_contingency(p) = !is_truth(p)

"""
    is_satisfiable(p)

Returns a boolean on whether `p` is
[satisfiable](https://en.wikipedia.org/wiki/Satisfiability)
(not a [`contradiction`](@ref)).

See also [`Proposition`](@ref).

# Examples
```jldoctest
julia> is_satisfiable(⊤)
true

julia> @p is_satisfiable(p ∧ ¬p)
false

julia> @p is_satisfiable(p)
true

julia> @p is_satisfiable(p ∧ q)
true
```
"""
is_satisfiable(p) = !is_contradiction(p)
# TODO: improve algorithm

"""
    is_falsifiable(p)

Returns a boolean on whether `p` is
[falsifiable](https://en.wikipedia.org/wiki/Falsifiability)
(not a [`tautology`](@ref)).

See also [`Proposition`](@ref).

# Examples
```jldoctest
julia> is_falsifiable(⊥)
true

julia> @p is_falsifiable(¬(p ∧ ¬p))
false

julia> @p is_falsifiable(p)
true

julia> @p is_falsifiable(p ∧ q)
true
```
"""
is_falsifiable(p) = !is_tautology(p)

# TODO: write all conversions
# TODO: if simplification is about the operator, put it with operators
#    if it's about the types, put it in constructors/convert

# Boolean Operators

# Bool
Bool(::typeof(tautology)) = true
Bool(::typeof(contradiction)) = false
not(p::Bool) = !p
and(p::Bool, q::Bool) = p && q
or(p::Bool, q::Bool) = p || q
converse_imply(p::Bool, q::Bool) = p ^ q

# generic
tautology() = ⊤
contradiction() = ⊥
nand(p, q) = ¬(p ∧ q)
nor(p, q) = ¬p ∧ ¬q
or(p, q) = ¬(p ⊽ q)
xor(p, q) = (p ∨ q) ∧ (p ⊼ q)
xnor(p, q) = (p → q) ∧ (p ← q)
not_imply(p, q) = p ∧ ¬q
imply(p, q) = ¬(p ↛ q)
not_converse_imply(p, q) = ¬p ∧ q
converse_imply(p, q) = ¬(p ↚ q)

# boolean operators
eval_doubles(:not, (
    (tautology, contradiction),
    (identity, not),
    (and, nand),
    (or, nor),
    (xor, xnor),
    (imply, not_imply),
    (converse_imply, not_converse_imply)
))

# propositions
not(p::Atom) = Literal(not, p)
not(p::Literal{UO}) where UO = not(UO.instance)(p.atom)
not(p::Tree{LO}) where LO = not(LO.instance)(p.nodes...)
not(p::CN) where {AO, CN <: Union{Clause{AO}, Normal{AO}}} =
    getfield(Main, nameof(CN))(dual(AO.instance), map(not, first_field(p)))

and(::typeof(tautology), ::typeof(tautology)) = ⊤
and(::typeof(contradiction), q) = ⊥ # domination law
and(::typeof(tautology), q) = q # identity law
and(p::Proposition, q::NullaryOperator) = q ∧ p # commutative property
and(p::Proposition, q::Proposition) = and(Normal(and, p), Normal(and, q))

foreach(uniontypes(BinaryOperator)) do BO
    bo = nameof(BO.instance)
    @eval $bo(p) = Fix1($bo, p)
    @eval $bo(p::Tree, q::Tree) = Tree($bo, p, q)
    @eval $bo(p::Tree, q::Union{Atom, Literal}) = Tree($bo, p, Tree(q))
    @eval $bo(p::Union{Atom, Literal}, q::Tree) = Tree($bo, Tree(p), q)
    @eval $bo(p::Union{Atom, Literal}, q::Union{Atom, Literal}) =
        $bo(Tree(p), Tree(q))
end

for AO in uniontypes(AndOr)
    ao = nameof(AO.instance)
    dao = nameof(dual(AO.instance))
    DAO = typeof(dual(AO.instance))

    @eval $ao(p::Clause{$DAO}, q::Clause{$DAO}) = Normal($ao, p, q)

    @eval $ao(p::Union{LiteralProposition, Clause{$AO}}, q::Clause{$DAO}) =
        $ao(Normal($ao, p), q)
    @eval $ao(p::Clause{$DAO}, q::Union{LiteralProposition, Clause{$AO}}) =
        $ao(p, Normal($ao, q))

    for (left, right) in ((Clause, LiteralProposition), (Normal, Clause{DAO}))
        @eval $ao(p::$left{$AO}, q::$right) = $left($ao, vcat(first_field(p), q))
        @eval $ao(p::$right, q::$left{$AO}) = $left($ao, vcat(p, first_field(q)))
    end

    for CN in (Clause, Normal)
        @eval $ao(p::$CN{$AO}, q::$CN{$AO}) =
            $CN($ao, vcat(first_field(p), first_field(q)))
    end

    @eval $ao(p::Normal, q::Normal) = $ao(Normal($ao, p), Normal($ao, q))
    @eval $ao(p::Clause, q::Normal) = $ao(Normal($ao, p), q)
    @eval $ao(p::Normal, q::Clause) = $ao(p, Normal($ao, q))
end

# Constructors

Clause(ao::AndOr, ps::AbstractArray) =
    isempty(ps) ? Clause(ao) : Clause(ao, map(Literal, ps))
Clause(ao::AndOr, ps...) = Clause(ao, collect(ps))

Normal(ao::AndOr, p::Tree{LO}) where LO = Normal(ao, LO.instance(
    map(node -> Normal(node), p.nodes)...
))
Normal(ao::AO, p::Clause{AO}) where AO <:AndOr =
    Normal(ao, map(literal -> Clause(dual(ao), literal), p.literals))
Normal(ao::AndOr, ps::AbstractArray) = isempty(ps) ?
    Normal(ao) :
    Normal(ao, map(p -> Clause(dual(ao), p), ps))
# TODO: see `https://en.wikipedia.org/wiki/Tseytin_transformation`
Normal(ao::AndOr, p::Normal) = Normal(ao,
    vec(map(Iterators.product(map(p.clauses) do clause
        clause.literals
    end...)) do literals
        Clause(dual(ao), collect(literals))
    end)
)
Normal(::AO, p::Normal{AO}) where AO <: AndOr = p
Normal(ao::AndOr, ps::Proposition...) = Normal(ao, collect(ps))

# Conversions

for P in (:Literal, :Tree, :Clause, :Normal)
    @eval $P(p) = convert($P, p)
end

nullary_operator_to_and_or(::typeof(tautology)) = and
nullary_operator_to_and_or(::typeof(contradiction)) = or

"""
    convert
"""
convert(::Type{Atom}, p::Literal{typeof(identity)}) = p.atom
convert(::Type{Atom}, p::Tree{typeof(identity), <:Tuple{Atom}}) = only(p.nodes)
convert(::Type{Literal}, p::Tree{UO, <:Tuple{Atom}}) where UO =
    p.nodes |> only |> UO.instance |> Literal
convert(::Type{LT}, p::Atom) where LT <: Union{Literal, Tree} = LT(identity, p)
convert(::Type{Tree}, p::Literal{UO}) where UO = Tree(UO.instance, p.atom)
convert(::Type{Tree}, p::Clause{AO}) where AO = Tree(foldl(AO.instance, p.literals))
convert(::Type{Tree}, p::Normal{AO}) where AO = Tree(mapfoldl(Tree, AO.instance, p.clauses))
convert(::Type{Clause}, p::LiteralProposition) = Clause(or, p)
convert(::Type{CN}, no::NullaryOperator) where CN <: Union{Clause, Normal} =
    CN(nullary_operator_to_and_or(no))
convert(::Type{Normal}, p::Clause{typeof(and)}) = Normal(or, p)
convert(::Type{Normal}, p::Proposition) = Normal(and, p)
