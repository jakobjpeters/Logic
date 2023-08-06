
using Luxor: readsvg, Drawing, placeimage, fontface, fontsize, text, Point, finish

#=
Julia Dots
    Copyright (c) 2012-2019: Stefan Karpinski <stefan@karpinski.org>

License
    https://github.com/JuliaLang/julia-logo-graphics/blob/master/LICENSE.md

Modifications
    `P ∧ Q` overlay
=#
const julia_dots = readsvg(download("https://raw.githubusercontent.com/JuliaLang/julia-logo-graphics/b5551ca7946b4a25746c045c15fbb8806610f8d0/images/julia-dots.svg"))

function make_logo(directory)
    Drawing(julia_dots.width, julia_dots.height, :svg, directory * "logo.svg")
    placeimage(julia_dots)

    fontface("JuliaMono")
    fontsize(128)

    for (character, coordinates) in zip(("p", "∧", "q"), (
        (julia_dots.width / 4, julia_dots.height * 5 / 8),
        (julia_dots.width / 2, julia_dots.height / 8),
        (julia_dots.width * 3 / 4, julia_dots.height * 5 / 8)
    ))
        text(character, Point(coordinates); :halign => :center, :valign => :top)
    end

    finish()
end