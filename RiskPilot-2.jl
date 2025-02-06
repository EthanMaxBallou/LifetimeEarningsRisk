# Risk Pilot-2

using DataFrames
using GLM
using CSV
using CategoricalArrays
using Combinatorics
using Statistics



df = CSV.read("/Users/ethanballou/Documents/Data/PSID4/df/data1.csv", DataFrame)
target = CSV.read("/Users/ethanballou/Documents/Data/PSID4/df/target1.csv", DataFrame)


Rankings = CSV.read("/Users/ethanballou/Documents/Papers/EarningsRisk/Average_Ranks.csv", DataFrame)


# Perform the join
jdf = innerjoin(df, target, on=:personid, makeunique=true)
rename!(jdf, :gam_fearn0_A_ => :gamma)

top_50_vars = Rankings[1:50, :Base_Variable]
selected_columns = Symbol.(top_50_vars)

matching_columns = intersect(top_50_vars, names(jdf))
retained_columns = vcat(:gamma, selected_columns)

select!(jdf, retained_columns)


for col in matching_columns
    if length(unique(jdf[:, col])) < 10
        unique_values = unique(jdf[:, col])
        for val in unique_values[1:end-1]  # Exclude the last dummy to avoid redundancy
            dummy_name = Symbol("$(col)_$(val)")
            jdf[:, dummy_name] = jdf[:, col] .== val
        end
        select!(jdf, Not(col))  # Remove the original categorical variable
        
        println("Converted column $(col) to categorical.")
    end
end


independent_vars = setdiff(Symbol.(names(jdf)), [:gamma])


# Add higher-order terms for non-categorical variables
for col in independent_vars
    if length(unique(jdf[:, col])) > 10
        jdf[:, Symbol("$(col)_squared")] = jdf[:, col] .^ 2
        #jdf[:, Symbol("$(col)_cubed")] = jdf[:, col] .^ 3
        println("Added higher-order terms for column $(col).")
    end
end


REALindependent_vars = setdiff(Symbol.(names(jdf)), [:gamma])


# Add interaction terms for all combinations of two variables
for combo in combinations(REALindependent_vars, 2)
    interaction_name = Symbol("$(combo[1])_x_$(combo[2])")
    jdf[:, interaction_name] = jdf[:, combo[1]] .* jdf[:, combo[2]]
    println("Added interaction term for $(combo[1]) and $(combo[2]).")
end





REALindependent_vars = setdiff(Symbol.(names(jdf)), [:gamma])


# Create the regression formula dynamically
formula = Term(:gamma) ~ sum(Term(var) for var in independent_vars)

model = lm(formula, jdf)
println(model)
println("\n")

println(r2(model))





predicted_gamma = predict(model, jdf)
actual_gamma = jdf[:, :gamma]
mae = mean(abs.(actual_gamma .- predicted_gamma))

println("Mean Absolute Error (MAE): ", mae)


jdf.ER5854_2 = jdf.ER5854.^2

jdf.ER32025_11 = ifelse.(jdf.ER32025 .== 11, 1, 0)



jdf.ER32025_11[jdf.ER32025 .== 11] .= 1




jdf.indCAT = categorical(jdf.ER6919)
jdf.regCAT1 = categorical(jdf.ER6997C)
jdf.regCAT2 = categorical(jdf.ER6997)


#ER6919 dummy

reg7B = lm(@formula(gamma ~ ER5854 + ER32024 + ER6919 + ER32025_11 + ER6988 + regCAT1 + indCAT + ER6943 + ER32043), jdf)
println(reg7B)
println("\n")

println(r2(reg7B))




predicted_gamma = predict(reg7B, jdf)
actual_gamma = jdf[:, :gamma]
mae = mean(abs.(actual_gamma .- predicted_gamma))

println("Mean Absolute Error (MAE): ", mae)




# Add interaction terms for all combinations of three variables
for combo in combinations(independent_vars, 3)
    interaction_name = Symbol("$(combo[1])_x_$(combo[2])_x_$(combo[3])")
    jdf[:, interaction_name] = jdf[:, combo[1]] .* jdf[:, combo[2]] .* jdf[:, combo[3]]
    println("Added interaction term for $(combo[1]), $(combo[2]), and $(combo[3]).")
end

