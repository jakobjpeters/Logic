
"""
    Z3

This module provides an interface to z3_jll.jl.
"""
module Z3

"""
    Library
"""
module Library

using CxxWrap: @initcxx, @wrapmodule, ConstCxxRef, CxxRef
using z3_jll: get_libz3jl_path

@wrapmodule get_libz3jl_path

__init__() = @initcxx

end # Library

import Base: IteratorSize, eltype, isdone, iterate
using Base: SizeUnknown
using CxxWrap: dereference_argument
using .Library:
    Library, AstVectorTpl, Context, ExprAllocated, Solver, SolverAllocated,
    add, bool_const, check, get_const_decl, get_const_interp, get_model, is_true, mk_or, not, num_consts, sat

"""
    add_clause(context, solver, clause)
"""
function add_clause(context, solver, clause)
    _clause = dereference_argument(AstVectorTpl{Library.Expr}(context))

    for literal in clause
        push!(_clause, literal)
    end

    add(solver, mk_or(_clause))
end

"""
    Solutions
"""
mutable struct Solutions
    const context::Context
    const solver::SolverAllocated
    const clause::Vector{ExprAllocated}
    is_done::Bool

    function Solutions(clauses, n)
        context = Context()
        solver = Solver(context, "QF_FD")

        for clause in clauses
            add_clause(context, solver, Iterators.map(
                literal -> (signbit(literal) ? not : identity)(bool_const(context, string(abs(literal)))), clause))
        end

        new(context, solver, Vector{ExprAllocated}(undef, n), false)
    end
end

"""
    IteratorSize(::Type{Solutions})

# Examples
```jldoctest
julia> Base.IteratorSize(PAndQ.Z3.Solutions)
Base.SizeUnknown()
```
"""
IteratorSize(::Type{Solutions}) = SizeUnknown()

"""
    eltype(::Type{Solutions})

The type of the elements generated by a [`Solutions`](@ref Z3.Solutions) iterator.

# Examples
```jldoctest
julia> eltype(PAndQ.Z3.Solutions)
Vector{Bool} (alias for Array{Bool, 1})
```
"""
eltype(::Type{Solutions}) = Vector{Bool}

"""
    isdone
"""
isdone(solutions::Solutions, solver = solutions.solver) = solutions.is_done ||
    let is_contradiction = check(solver) != sat
        solutions.is_done = is_contradiction
    end

"""
    iterate
"""
iterate(solutions::Solutions, solver = solutions.solver) = if !isdone(solutions, solver)
    model, clause = get_model(solver), solutions.clause
    n = length(clause)
    valuation = Vector{Bool}(undef, n)

    for i in 0:n - 1
        atom = get_const_decl(model, i)
        _atom = atom()
        __atom = parse(Int, strip(Library.string(_atom), '|'))
        assignment = is_true(get_const_interp(model, atom))
        clause[__atom] = (assignment ? not : identity)(_atom)
        valuation[__atom] = assignment
    end

    add_clause(solutions.context, solver, clause)
    valuation, solver
end

end # Z3
