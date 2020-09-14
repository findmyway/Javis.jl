@testset "O(logn)" begin
    function latex_ground(args...)
        translate(-200, -100)
        background("white")
        sethue("black")
        fontsize(50)
    end

    function latex_blend(latex_string, fsize)
        orangeblue = blend(Point(50, 70), Point(50, 120), "orange", "blue")
        setblend(orangeblue)
        fontsize(fsize)
        latex(latex_string, Point(50, 70))
    end

    video = Video(400, 200)
    javis(
        video,
        [
            BackgroundAction(1:1, latex_ground),
            Action((args...) -> latex(L"\mathcal{O}(\log{n})")), # default fontsize 50
            Action(
                (args...) -> latex_blend(L"\mathcal{O}\left(\frac{\log{x}}{2}\right)", 20),
            ),
        ],
        tempdirectory = "images",
        pathname = "",
    )
    @test_reference "refs/ologn.png" load("images/0000000001.png")
    rm("images/0000000001.png")
end

@testset "transposing a matrix" begin
    function latex_ground(args...)
        translate(-200, -100)
        background("white")
        sethue("black")
        fontsize(50)
    end

    function matrix(; do_transpose = false, action = :stroke)
        fontsize(50)
        mat = ["α" "β" "γ"; "x^2" "sqrt(y)" "λ"; 1 2 "y"]
        if do_transpose
            mat = permutedims(mat)
        end
        str = latexstring(latexify(mat))
        action == :path && newpath()
        latex(str, O, action)
        return pathtopoly()
    end

    video = Video(600, 400)
    javis(
        video,
        [
            BackgroundAction(1:62, latex_ground),
            Action(1:30, (args...) -> matrix()),
            Action(
                31:60,
                morph(
                    matrix(; action = :path),
                    matrix(; action = :path, do_transpose = true);
                    action = :fill,
                ),
            ),
            Action(61:62, (args...) -> matrix(; do_transpose = true)),
        ],
        tempdirectory = "images",
        pathname = "",
    )

    @test_reference "refs/matrix_transpose1.png" load("images/0000000001.png")
    @test_reference "refs/matrix_transpose50.png" load("images/0000000050.png")
    @test_reference "refs/matrix_transpose55.png" load("images/0000000055.png")
    @test_reference "refs/matrix_transpose62.png" load("images/0000000062.png")
    for i in 1:62
        rm("images/$(lpad(i, 10, "0")).png")
    end
end

@testset "latex pos in function" begin
    function latex_ground(args...)
        background("white")
        sethue("black")
        fontsize(30)
    end

    function foreground(latex_string)
        latex(latex_string, Point(50, 40))
        circle(O, 20, :fill) # should be in the center and not affected by latex
    end

    video = Video(400, 200)
    javis(
        video,
        [
            BackgroundAction(1:1, latex_ground),
            Action((args...) -> foreground(L"\mathcal{O}(\log{n})")),
        ],
        tempdirectory = "images",
        pathname = "",
    )
    @test_reference "refs/ologn_circ.png" load("images/0000000001.png")
    rm("images/0000000001.png")
end

@testset "latex pos in function DEPRECATED" begin
    function latex_ground(args...)
        background("white")
        sethue("black")
        fontsize(30)
    end

    function foreground(latex_string)
        translate(50, 40)
        fsize = get_fontsize()
        latex(latex_string, fsize) # is automatically changed to fontsize(30); latex(latex_string)
        translate(-50, -40)
        circle(O, 20, :fill) # should be in the center and not affected by latex
    end

    video = Video(400, 200)
    javis(
        video,
        [
            BackgroundAction(1:1, latex_ground),
            Action((args...) -> foreground(L"\mathcal{O}(\log{n})")),
        ],
        tempdirectory = "images",
        pathname = "",
    )
    @test_reference "refs/ologn_circ.png" load("images/0000000001.png")
    rm("images/0000000001.png")
end
