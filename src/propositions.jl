
import Base: map
import AbstractTrees: children, nodevalue, printnode, NodeType, nodetype, HasNodeType
using Base: Iterators.Stateful
using Base.Meta: isexpr, parse
using AbstractTrees: childtype, Leaves, nodevalues, PreOrderDFS

# Internals

## Types

### Abstract

"""
    Proposition

A [proposition](https://en.wikipedia.org/wiki/Proposition).

Supertype of [`Atom`](@ref) and [`Compound`](@ref).
"""
abstract type Proposition end

"""
    Atom <: Proposition

A proposition with [no deeper propositional structure](https://en.wikipedia.org/wiki/Atomic_formula).

Subtype of [`Proposition`](@ref).
Supertype of [`Constant`](@ref) and [`Variable`](@ref).
"""
abstract type Atom <: Proposition end

"""
    Compound{O} <: Proposition

A proposition composed from connecting [`Atom`](@ref)s
with one or more [`Operator`](@ref)s.

Subtype of [`Proposition`](@ref).
Supertype of [`Literal`](@ref), [`Clause`](@ref), and [`Expressive`](@ref).
"""
abstract type Compound{O} <: Proposition end

"""
    Expressive{O} <: Compound{O}

A proposition that is [expressively complete](https://en.wikipedia.org/wiki/Completeness_(logic)).

Subtype of [`Compound`](@ref).
Supertype of [`Tree`](@ref) and [`Normal`](@ref).
"""
abstract type Expressive{O} <: Compound{O} end

# Atoms

"""
    Constant{T} <: Atom
    Constant(::T)

An [atomic sentence](https://en.wikipedia.org/wiki/Atomic_sentence).

Subtype of [`Atom`](@ref).

# Examples
```jldoctest
julia> PAndQ.Constant(1)
\$(1)

julia> PAndQ.Constant("Logic is fun")
\$("Logic is fun")
```
"""
struct Constant{T} <: Atom
    value::T
end

"""
    Variable <: Atom

An [atomic formula](https://en.wikipedia.org/wiki/Atomic_formula).

Subtype of [`Atom`](@ref).

# Examples
```jldoctest
julia> PAndQ.Variable(:p)
p

julia> PAndQ.Variable(:q)
q
```
"""
struct Variable <: Atom
    symbol::Symbol

    function Variable(symbol)
        s = string(symbol)
        isempty(s) && error("The symbol must be non-empty")
        all(c -> isprint(c) && !isspace(c), s) ||
            error("The symbol must contain only printable non-space characters")
        new(symbol)
    end
end

# Internal

## Types

### Concrete

"""
    Literal{UO <: UnaryOperator, A <: Atom} <: Compound{UO}
    Literal(::UO, ::A)
    Literal(::Union{Atom, Literal})

A proposition represented by [an atomic formula or its negation]
(https://en.wikipedia.org/wiki/Literal_(mathematical_logic)).

Subtype of [`Compound`](@ref).
See also [`UnaryOperator`](@ref) and [`Atom`](@ref).

# Examples
```jldoctest
julia> @atomize PAndQ.Literal(𝒾, p)
p

julia> @atomize PAndQ.Literal(¬, p)
¬p
```
"""
struct Literal{UO <: UnaryOperator, A <: Atom} <: Compound{UO}
    atom::A

    Literal(::UO, atom::A) where {UO <: UnaryOperator, A <: Atom} = new{UO, A}(atom)
end

"""
    Tree{O <: Operator, AT <: Union{Atom, Tree}, N} <: Expressive{O}
    Tree(::NullaryOperator, ::Atom)
    Tree(::Operator, ::Tree...)
    Tree(::Proposition)

A [`Proposition`](@ref) represented by an [abstract syntax tree]
(https://en.wikipedia.org/wiki/Abstract_syntax_tree).

Subtype of [`Expressive`](@ref).
See also [`Atom`](@ref), [`NullaryOperator`](@ref), and [`Operator`](@ref).

# Examples
```jldoctest
julia> PAndQ.Tree(⊤)
⊤

julia> @atomize PAndQ.Tree(¬, p)
¬p

julia> @atomize PAndQ.Tree(and, PAndQ.Tree(p), PAndQ.Tree(q))
p ∧ q
```
"""
struct Tree{O <: Operator, P <: Proposition, N} <: Expressive{O}
    nodes::NTuple{N, P}

    Tree(::UO, node::A) where {UO <: UnaryOperator, A <: Atom} = new{UO, A, 1}((node,))
    function Tree(o::O, nodes...) where O <: Operator
        _arity, _length = arity(o), length(nodes)
        _arity != _length &&
            error("`arity($o) == $_arity`, but `$_length` argument$(_length == 1 ? " was" : "s were") given")
        new{O, eltype(nodes), _arity}(nodes)
    end
end

"""
    Clause{AO <: AndOr, L <: Literal} <: Compound{AO}
    Clause(::AO, ps = Literal[])
    Clause(::AO, p::Proposition)
    Clause(::Union{NullaryOperator, Atom, Literal})

A proposition represented as either a [conjunction or disjunction of literals]
(https://en.wikipedia.org/wiki/Clause_(logic)).

!!! info
    An empty `Clause` is [logically equivalent](@ref ==) to the
    neutral element of it's binary operator.

Subtype of [`Compound`](@ref).
See also [`Atom`](@ref), [`Literal`](@ref), [`AndOr`](@ref), and [`NullaryOperator`](@ref).

# Examples
```jldoctest
julia> PAndQ.Clause(∧)
⊤

julia> @atomize PAndQ.Clause(p)
p

julia> @atomize PAndQ.Clause(∨, [¬p, q])
¬p ∨ q
```
"""
struct Clause{AO <: AndOr, L <: Literal} <: Compound{AO}
    literals::Vector{L}

    Clause(::AO, literals::Vector{L} = Literal[]) where {AO <: AndOr, L <: Literal} =
        new{AO, L}(union(literals))
end

"""
    Normal{AO <: AndOr, C <: Clause} <: Expressive{AO}
    Normal(::typeof(and), ps = Clause{typeof(or)}[])
    Normal(::typeof(or), ps = Clause{typeof(and)}[])
    Normal(::AO, ::Proposition)
    Normal(::Union{NullaryOperator, Proposition})

A [`Proposition`](@ref) represented in [conjunctive]
(https://en.wikipedia.org/wiki/Conjunctive_normal_form) or [disjunctive]
(https://en.wikipedia.org/wiki/Disjunctive_normal_form) normal form.

!!! info
    An empty `Normal` is [logically equivalent](@ref ==) to the
    neutral element of it's binary operator.

Subtype of [`Expressive`](@ref).
See also [`Clause`](@ref), [`AndOr`](@ref), and [`NullaryOperator`](@ref).

# Examples
```jldoctest
julia> PAndQ.Normal(⊤)
⊤

julia> @atomize PAndQ.Normal(∧, p ⊻ q)
(p ∨ q) ∧ (¬p ∨ ¬q)
```
"""
struct Normal{AO <: AndOr, C <: Clause} <: Expressive{AO}
    clauses::Vector{C}

    Normal(::A, clauses::Vector{C} = Clause{typeof(or)}[]) where {A <: typeof(and), C <: Clause{typeof(or)}} =
        new{A, C}(union(clauses))
    Normal(::O, clauses::Vector{C} = Clause{typeof(and)}[]) where {O <: typeof(or), C <: Clause{typeof(and)}} =
        new{O, C}(union(clauses))
end

## AbstractTrees.jl

"""
    children(::Proposition)

Return an iterator over the child nodes of the given [`Proposition`](@ref).

# Examples
```jldoctest
julia> @atomize PAndQ.children(p)
()

julia> @atomize PAndQ.children(¬p)
(PAndQ.Variable(:p),)

julia> @atomize PAndQ.children(p ∧ q)
(PAndQ.Tree(identity, PAndQ.Variable(:p)), PAndQ.Tree(identity, PAndQ.Variable(:q)))
```
"""
children(p::Literal) = (p.atom,)
children(p::Tree) = p.nodes
children(p::Clause) = p.literals
children(p::Normal) = p.clauses

"""
    nodevalue(::Compound{O})

Return `O.instance`.

See also [`Compound`](@ref).

# Examples
```jldoctest
julia> @atomize PAndQ.nodevalue(¬p)
not (generic function with 19 methods)

julia> @atomize PAndQ.nodevalue(p ∧ q)
and (generic function with 17 methods)
```
"""
nodevalue(::Compound{O}) where O = O.instance

"""
    printnode(::IO, ::Union{NullaryOperator, Proposition}; kwargs...)

See also [`Proposition`](@ref).

# Examples
```jldoctest
julia> @atomize PAndQ.printnode(stdout, p)
p
julia> @atomize PAndQ.printnode(stdout, ¬p)
¬
julia> @atomize PAndQ.printnode(stdout, p ∧ q)
∧
```
"""
printnode(io::IO, no::NullaryOperator; kwargs...) = print(io, symbol_of(no))
printnode(io::IO, p::Atom; kwargs...) = show(io, MIME"text/plain"(), p)
printnode(io::IO, p::Union{Literal, Tree}; kwargs...) = print(io, symbol_of(nodevalue(p)))
printnode(io::IO, p::Union{Clause, Normal}; kwargs...) =
    print(io, symbol_of((isempty(children(p)) ? only ∘ left_neutrals : 𝒾)(nodevalue(p))))

"""
    NodeType(::Type{<:Atom})

See also [`Atom`](@ref).
"""
NodeType(::Type{<:Atom}) = HasNodeType()

"""
    nodetype(::Type{<:Atom})

See also [`Atom`](@ref).
"""
nodetype(::Type{A}) where A <: Atom = A


## Utilities

"""
    child(x)

Equivalent to `only ∘ children`

See also [`children`](@ref)
"""
const child = only ∘ children

"""
    atomize(x)

If `x` is a symbol, return an expression that instantiates it as a
[`Variable`](@ref) if it is undefined in the caller's scope.
If `isexpr(x, :\$)`, return an expression that instantiates it as a [`Constant`](@ref).
If `x` is another expression, traverse it with recursive calls to `atomize`
Otherise, return x.
"""
atomize(x::Symbol) = :((@isdefined $x) ? $x : $(Variable(x)))
function atomize(x::Expr)
    if length(x.args) == 0 x
    elseif isexpr(x, :$)
        value = only(x.args)
        :(
            if @isdefined PAndQ; PAndQ.Constant($value)
            elseif @isdefined Constant; Constant($value)
            else error("either `PAndQ` or `PAndQ.Constant` must be loaded")
            end
        )
    elseif isexpr(x, (:kw, :<:)) Expr(x.head, x.args[1], atomize(x.args[2]))
    elseif isexpr(x, (:struct, :where)) x # TODO
    else Expr(x.head, # TODO
        (isexpr(x, (:(=), :->, :function)) ? 𝒾 : atomize)(x.args[1]),
        map(atomize, x.args[2:end])...
    )
    end
end
atomize(x) = x

# Macros

"""
    @atomize(expression)

Instantiate undefined symbols as [`Variable`](@ref)s
and interpolated values as [`Constant`](@ref)s inline.

!!! warning
    This macro attempts to ignore symbols that are being assigned a value.
    For example, `@atomize f(; x = p) = x ∧ q` should be equivalent to
    `f(; x = @atomize p)) = x ∧ @atomize q`.
    However, this feature is in-progress and only works in some cases.
    The implementation is cautious to skip the parts
    of the expression that it cannot yet handle.

# Examples
```jldoctest
julia> @atomize x = p ∧ q
p ∧ q

julia> @atomize x → r
(p ∧ q) → r

julia> @atomize \$1 ∧ \$(1 + 1)
\$(1) ∧ \$(2)
```
"""
macro atomize(expression)
    esc(:($(atomize(expression))))
end

"""
    @variables(ps...)

Define [`Variable`](@ref)s and return a vector containing them.

Each symbol `p` is defined as [`p = @atomize p`](@ref @atomize).

Examples
```jldoctest
julia> @variables p q
2-element Vector{PAndQ.Variable}:
 p
 q

julia> p
p

julia> q
q
```
"""
macro variables(ps...) esc(quote
    $(map(p -> :($p = @atomize $p), ps)...)
    [$(ps...)]
end) end

# Utility

"""
    atoms(p)

Return an iterator of each [`Atom`](@ref) contained in `p`.

# Examples
```jldoctest
julia> @atomize collect(atoms(p ∧ q))
2-element Vector{PAndQ.Variable}:
 p
 q
```
"""
atoms(p) = Iterators.filter(leaf -> leaf isa Atom, Leaves(p))

"""
    operators(p)

Return an iterator of each [operator]
(@ref operators_operators) contained in `p`.

# Examples
```jldoctest
julia> @atomize collect(operators(¬p))
1-element Vector{typeof(not)}:
 not (generic function with 19 methods)

julia> @atomize collect(operators(¬p ∧ q))
3-element Vector{Function}:
 and (generic function with 17 methods)
 not (generic function with 19 methods)
 identity (generic function with 1 method)
```
"""
operators(p) = Iterators.filter(node -> !isa(node, Atom), nodevalues(PreOrderDFS(p)))

_map(g, f, p) = g(nodevalue(p))(map(child -> map(f, child), children(p)))

"""
    map(f, ::Union{NullaryOperator, Proposition})

Apply `f` to each [`Atom`](@ref) in the given argument.

See also [Nullary Operators](@ref nullary_operators) and [`Proposition`](@ref).

# Examples
```jldoctest
julia> @atomize map(p -> \$(p.value + 1), \$1 ∧ \$2)
\$(2) ∧ \$(3)

julia> @atomize map(p ∧ q) do atom
           println(atom)
           atom
       end
PAndQ.Variable(:p)
PAndQ.Variable(:q)
p ∧ q
```
"""
map(f, p::Atom) = f(p)
map(f, p::Union{NullaryOperator, Literal, Tree}) = _map(splat, f, p)
map(f, p::Union{Clause, Normal}) = _map(𝒾, f, p)

"""
    value(::Proposition)

Unwrap the value of a [`Constant`](@ref).

The [`Proposition`](@ref) must be logically equivalent to a [`Constant`](@ref).

# Examples
```jldoctest
julia> @atomize value(\$1)
1
```
"""
function value(p)
    _atoms = Stateful(atoms(p))
    atom = first(_atoms)
    !isempty(_atoms) && error("the `Proposition` must contain only one `Atom`")
    p != atom && error("The `Proposition` must be logically equivalent to its `Atom`")
    !isa(atom, Constant) && error("the `Atom` must be a `Constant`")
    atom.value
end
