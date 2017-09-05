# DecimalExpansion.jl

Function for performing decimal expansion on `Rational`s. ([Decimal Expansion](https://github.com/matteyas/DecimalExpansion.jl#decimal-expansion))  
Function for `Number -> Rational`. ([Number to Rational](https://github.com/matteyas/DecimalExpansion.jl#number-to-rational))

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
This is an implementation of a [Stern-Brocot tree](https://en.wikipedia.org/wiki/Stern%E2%80%93Brocot_tree) binary search.

```julia
function to_rational(x::Number)
    La, Lb = 0, 1
    Ua, Ub = 1, 0

    Ma, Mb = 1, 1
    M = Ma/Mb
    while true
        if M < x
            La, Lb = Ma, Mb
        elseif M > x
            Ua, Ub = Ma, Mb
        else
            break
        end
        Ma, Mb = La+Ua, Lb+Ub
        M = Ma/Mb
    end
    
    Ma//Mb
end
```
