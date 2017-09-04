# DecimalExpansion.jl

Function for performing decimal expansion on `Rational`s.

## Output format:
`decimal_expansion()` returns `String`s.

### No repeating decimal
Outputs the full terminating decimal expansion:  
`decimal_expansion(41//(2^20)) -> 0.00003910064697265625`

### One repeating decimal
The last (three) digits repeat indefinitely:  
`decimal_expansion(1//3)   -> 0.333...`  
`decimal_expansion(37//60) -> 0.61666...`

### Several repeating decimals
Everything in the brackets repeat indefinitely:  
`   decimal_expansion(1//7) -> 0.[142857]... = 0.142857142857142857...`  
`decimal_expansion(105//13) -> 8.[076923]... = 8.076923076923076923...`

## Source:
```julia
decimal_expansion(R::Rational) = decimal_expansion(R.num, R.den)

function decimal_expansion(numerator::Int, denominator::Int)::String
    denominator == 1 && return "$numerator"

    ordered_steps= Vector{Int}()
    unique_steps = Set{Int}()    # optimization
    
    decimals = Vector{Int}()

    integer_part::Int = div(numerator, denominator)
    numerator -= denominator*integer_part

    # first step
    numerator *= 10
    push!(ordered_steps, numerator)
    push!(unique_steps, numerator)

    # iterative decimal expansion
    while true
        digit = div(numerator, denominator)
        numerator -= digit*denominator        
        numerator *= 10

        push!(ordered_steps, numerator)
        push!(decimals, digit)

        length(unique_steps) == push!(unique_steps, numerator) |> length &&
            break
    end

    # separate recurring / non-recurring parts
    i = find(x->x==numerator, ordered_steps)[1]
    recurring     = decimals[i:end] |> join
    non_recurring = decimals[1:i-1] |> join

    output = integer_part |> string
    output*= "."
    output*= non_recurring
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
