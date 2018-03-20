module DecimalExpansion

export decimal_expansion, to_rational

# DECIMAL EXPANSION
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

# NUMBER TO RATIONAL
function to_rational(x::T) where T<:Number
  int_type = sizeof(x) <= 8 ? Int : BigInt

  La, Lb = zero(int_type), one(int_type)
  Ua, Ub = one(int_type), zero(int_type)

  Ma, Mb = one(int_type), one(int_type)

  while true

    M = Ma/Mb   
    if M < x
      La, Lb = Ma, Mb
    elseif M > x
      Ua, Ub = Ma, Mb
    else
      break
    end

    Ma, Mb = La+Ua, Lb+Ub
  end

  Ma//Mb
end

end
