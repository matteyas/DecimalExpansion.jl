# DecimalExpansion.jl

Function for performing decimal expansion on `Rational`s.

```julia
decimal_expand(R::Rational) = decimal_expand(R.num, R.den)

function decimal_expand(num::Int, den::Int)
    num == den && return "1"

    syms = Vector{Int}()
    s=""

    integer_part = div(num, den)
    num -= den*integer_part

    num == 0 && return "$integer_part"

    # pad zeros
    z = 0
    num *= 10
    while num < den
        z += 1
        num *= 10
    end

    # first iteration
    push!(syms, num)
    d = div(num, den)
    s *= d |> string

    while true
        num -= d*den
        num *= 10
        d = div(num, den)
        num ∈ syms && break
        push!(syms, num)
        s *= d |> string
    end

    # separate recurring / non-recurring parts
    i = find(x->x==num, syms)[1]
    recurring     = s[i:end] |> string
    non_recurring = s[1:i-1] |> string

    output = integer_part |> string
    output*= "."
    output*= "0"^z
    output *= non_recurring
    if recurring != "0"
        if length(recurring) == 1
            output *= "$recurring"^3 * "..."
        else
            output *= "[$recurring]..."
        end
    end

    output
end
```

## Output format:
### One repeating decimal
`decimal_expansion(1//3)   -> 0.333...`  
`decimal_expansion(37//60) -> 0.61666...`

### Several repeating decimals
Everything in the brackets expand indefinitely:  
`   decimal_expansion(1//7) -> 0.[142857]...  = 0.142857142857142857...`  
`decimal_expansion(105//13) -> 8.0[769230]... = 8.0769230769230769230...`
