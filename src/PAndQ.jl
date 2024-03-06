
module PAndQ

using PrecompileTools: @compile_workload, @setup_workload

"""
    union_typeof(xs)
"""
union_typeof(xs) = Union{map(typeof, xs)...}

include("PicoSAT.jl")

include("interface.jl")

import .Interface:
    Associativity, Evaluation,
    arity, converse, dual, evaluate, initial_value,
    is_associative, is_commutative, print_expression, print_proposition, symbol
using .Interface: Eager, Lazy, Left, Operator, Right, name
export Interface

include("operators.jl")

export
    tautology, ⊤,
    contradiction, ⊥,
    identical, 𝒾,
    not, ¬,
    and, ∧,
    or, ∨,
    imply, →,
    exclusive_or, ↮,
    converse_imply, ←,
    not_and, ↑,
    not_or, ↓,
    not_imply, ↛,
    not_exclusive_or, ↔,
    not_converse_imply, ↚,
    conjunction, ⋀,
    disjunction, ⋁,
    fold

include("propositions.jl")

export
    @atomize, @variables, constants,
    value, atoms, operators, install_atomize_mode,
    normalize, tseytin, dimacs

include("semantics.jl")

export
    valuations, interpret, interpretations, solutions,
    is_tautology, is_contradiction,
    is_truth, is_contingency,
    is_satisfiable, is_falsifiable,
    is_equisatisfiable, ==

include("printing.jl")

export
    TruthTable,
    formatter,
    print_proposition,
    print_table,
    print_tree

@compile_workload for (p, q) in (@atomize([$:p, $:q]), @variables p q) redirect_stdout(Pipe()) do
    rs = Tree[⊤, ⊥, 𝒾(p), ¬p, p ∧ q, p ∨ q, p → q, p ↮ q, p ← q, p ↑ q, p ↓ q, p ↛ q, p ↔ q, p ↚ q]

    conjunction(rs)
    disjunction(rs)
    print_table(rs)

    for r in rs
        collect(operators(r))
        normalize(¬, r)
        normalize(∨, r)
        tseytin(r)
        dimacs(r)
        print_tree(r)
        print(r)

        for solution in solutions(r)
            collect(solution)
        end

        for f in (is_tautology, is_contradiction, is_truth, is_contingency, is_satisfiable, is_falsifiable)
            f(r)
        end
    end
end end

end
