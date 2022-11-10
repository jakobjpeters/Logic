
# show(io::IO, worlds::Vector{World}) = display(worlds)

print(io::IO, p::Primitive, indent::Int) = print(io, repeat("  ", indent), p)
print(io::IO, operator::Operator, indent::Int) = print(io, repeat("  ", indent), operator, ", ")
print(io::IO, ϕ::Tuple{Operator, Vararg}, indent::Int) = map(arg -> print(io, arg, indent), ϕ)
print(io::IO, ϕ::Compound, indent::Int) = show(io, ϕ, indent)
function show(io::IO, ϕ::C, indent::Int = 0) where C <: Compound
    print(io, nameof(C), "(\n")
    print(io, ϕ.ϕ, indent + 1)
    print(io, "\n", repeat("  ", indent), ") ")
end


show(io::IO, p::Primitive{String}) = print(io, "Primitive(\"", p.statement, "\")")
show(io::IO, p::Primitive{Nothing}) = print(io, "Primitive(", p.statement, ")")
show(io::IO, ::Valuation{V}) where V <: Val = print(io, first(V.parameters))
