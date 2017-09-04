# DecimalExpansion.jl

Function for performing decimal expansion on `Rational`s. ([Decimal Expansion](https://github.com/matteyas/DecimalExpansion.jl/blob/master/README.md#Decimal-Expansion))  
Function for `Number -> Rational`. ([Number to Rational](https://github.com/matteyas/DecimalExpansion.jl/blob/master/README.md#number-to-rational))

# Decimal Expansion

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
`decimal_expansion(1//7) -> 0.[142857]... = 0.142857142857142857...`  
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
    remainder::Int = numerator - denominator*integer_part

    # iterative decimal expansion
    while true
        remainder *= 10
        push!(ordered_steps, remainder)
        length(unique_steps) == push!(unique_steps, remainder) |> length &&
            break

        digit = div(remainder, denominator)
        push!(decimals, digit)

        remainder -= digit*denominator
    end

    # separate recurring / non-recurring parts
    i = find(x->x==remainder, ordered_steps)[1]
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

# Number to Rational
## Examples:
`1/7 |> to_rational -> 1//7`  
`decimal_expansion(37//60) -> 0.61666... => 0.616666666666 |> to_rational -> 37//60`  
`15 |> to_rational -> 15//1`

## Source:
function to_rational(n::Number)
    to_int(x::Number) = round(x) |> Int
    
    a = n
    b = n
    R = 2n
    h = 1/100 # conservative

    while R - b |> abs > 0
        while a - round(a) |> abs > h
            a += b
        end
        
        R = to_int(a) // to_int(a/b)
        a += b
    end
    
    R
end
