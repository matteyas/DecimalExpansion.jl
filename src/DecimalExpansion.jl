module DecimalExpansion

export decimal_expansion

decimal_expansion(R::Rational) = decimal_expansion(R.num, R.den)

function decimal_expansion(numerator::Int, denominator::Int)::String
    denominator == 1 && return "$numerator"

    ordered_steps= Vector{Int}()
    unique_steps = Set{Int}()    # optimization
    
    decimals = Vector{Int}()

    integer_part::Int = div(numerator, denominator)
    numerator -= denominator*integer_part

    # pad zeros / significant digits
    z = 0
    numerator *= 10
    while numerator < denominator
        z += 1
        numerator *= 10
    end

    # first iteration
    push!(unique_steps, numerator)
    push!(ordered_steps, numerator)
    
    digit::Int = div(numerator, denominator)
    push!(decimals, digit)

    while true
        numerator -= digit*denominator
        numerator *= 10
        digit = div(numerator, denominator)
        
        length(unique_steps) == push!(unique_steps, numerator) |> length &&
            break
        
        push!(ordered_steps, numerator)
        push!(decimals, digit)
    end

    # separate recurring / non-recurring parts
    i = find(x->x==numerator, ordered_steps)[1]
    recurring     = decimals[i:end] |> join
    non_recurring = decimals[1:i-1] |> join

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

end
