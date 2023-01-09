
comment = "
<!--
This file is generated by '.github/workflows/readme.yml' - do not edit directly
-->
"

header = read("HEADER.md", String)

index_md = read("docs/src/index.md", String)
i = findfirst("## Introduction", index_md)
snippet = index_md[first(i):end]
body = replace(snippet, "jldoctest" => "julia")

readme_md = comment * header * "\n" * body

isfile("README.md") && rm("README.md")
open("README.md", write = true) do io
    write(io, readme_md)
end