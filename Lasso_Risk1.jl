# test

using DataFrames
using GLM
using CSV
using CategoricalArrays
using Combinatorics
using Statistics
using StatsModels
using GLMNet
using Plots
using Random




df = CSV.read("/Users/ethanballou/Documents/Data/Risk/old_gam_data.csv", DataFrame)
otherPSID = CSV.read("/Users/ethanballou/Documents/Data/PSID5/J343037.csv", DataFrame)


labels = CSV.read("/Users/ethanballou/Documents/Data/PSID5/VAR_CODES.csv", DataFrame)


otherPSID.personid = (otherPSID.ER30001 .* 1000) + otherPSID.ER30002


dropmissing!(df, [:J])
dropmissing!(df, [:gam_fearn0_A_])
dropmissing!(df, [:aep])


#df.marital = zeros(size(df, 1))
#df.numCHILD = zeros(size(df, 1))
#df.annualHRS = zeros(size(df, 1))
#df.annualHRSwife = zeros(size(df, 1))


res = DataFrame(year = Float64[], personid = Float64[], marital = Float64[], children = Float64[], annualHRS = Float64[], annualHRSwife = Float64[], sex = Float64[], motherYR = Float64[], fatherYR = Float64[])

for year in unique(df.year)

    marriageLABEL = Symbol(labels.marital[1])
    childLABEL = Symbol(labels.numCHILD[1])
    annHRLABEL = Symbol(labels.annualHRS[1])
    annHRwifeLABEL = Symbol(labels.annualHRSwife[1])

    data = select(otherPSID, [:personid, marriageLABEL, childLABEL, annHRLABEL, annHRwifeLABEL, :ER32000, :ER32011, :ER32018])

    rename!(data, Dict(marriageLABEL => :marital, childLABEL => :children, annHRLABEL => :annualHRS, annHRwifeLABEL => :annualHRSwife, :ER32000 => :sex, :ER32011 => :motherYR, :ER32018 => :fatherYR))
    data.year = fill(year, nrow(data))

    dropmissing!(data)
    append!(res, data)
    
    println(year)

end

# Add fearn0_P0 variable from df to res by matching on year and personid
res = leftjoin(res, select(df, [:year, :personid, :aep]), on = [:year, :personid], makeunique = true)

# Add lagged variables for children and fearn0_P0 in the res DataFrame
sort!(res, [:personid, :year])
res.children_GR = Vector{Union{Missing, Float64}}(missing, nrow(res))
res.AEP_GR = Vector{Union{Missing, Float64}}(missing, nrow(res))

for i in 2:nrow(res)
    if res.personid[i] == res.personid[i-1] && res.year[i] == res.year[i-1] + 1
        res.children_GR[i] = res.children[i] - res.children[i-1]
        res.AEP_GR[i] = res.aep[i] - res.aep[i-1]
    end
end

# Drop rows with missing values in the new lagged variable
dropmissing!(res, [:children_GR, :AEP_GR])

df = leftjoin(df, res, on = [:year, :personid], makeunique = true)



dropmissing!(df, [:marital])
dropmissing!(df, [:children])
dropmissing!(df, [:annualHRS])
dropmissing!(df, [:annualHRSwife])
dropmissing!(df, [:sex])

dropmissing!(df, [:children_GR])
dropmissing!(df, [:AEP_GR])



# Combine some of the values in the oneind variable into a single misc value

#low_variation_values = ["Agriculture    1", "Energy         2"]  # Replace with actual values to combine
#df.oneind = categorical(df.oneind)
#for value in low_variation_values
#    replace!(df.oneind, value => "misc")
#end




df.occ = categorical(df.occ)
df.year = categorical(df.year)
df.state = categorical(df.state)

df.group = categorical(df.group)
df.relation = categorical(df.relation)

df.twoind = categorical(df.twoind)

df.race = categorical(df.race)

df.soc2010 = categorical(df.soc2010)

df.marital = categorical(df.marital)



# Interact J with age with tenure with edmaxyrs
# Maybe only do people hwo are employed
# bring in family structure


# JandQ interactions

# DO NOT FORGET THIS
#df = filter(row -> row.unemp == 0, df)


median_age = median(df.currentage)


df.JAGE = df.J.^2 .* df.currentage
df.QAGE = df.Q.^2 .* df.currentage

df.JEDU = df.J.^2 .* df.edmaxyrs
df.QEDU = df.Q.^2 .* df.edmaxyrs


# Add a dummy variable for age greater than median
df.ABV_MED = df.currentage .> median_age

df.J_Late = df.J.^3 .* df.ABV_MED
df.Q_Late = df.Q.^3 .* df.ABV_MED

df.J_Late_lin = df.J .* df.ABV_MED
df.Q_Late_lin = df.Q .* df.ABV_MED

df.children2 = df.children.^2

df.childAGE = df.children .* df.currentage.^2

df.childAGE_J = df.childAGE .* df.J
df.childAGE_Q = df.childAGE .* df.Q

df.J_2 = df.J.^2
df.Q_2 = df.Q.^2




# abs val risk
df.gamABS = log.(abs.(df.gam_fearn0_A_))

# positive or negative gam dummy
df.GAM_POS = df.gam_fearn0_A_ .> 0


# Create a DataFrame listing variable names and the number of unique values for each
unique_values_df = DataFrame(
    variable = names(df),
    unique_values = [length(unique(df[!, col])) for col in names(df)]
)

# Drop rows in df with -Inf as a value for df.gamABS
df = filter(row -> row.gamABS != -Inf, df)

# Drop rows where sex is 9 or motherYR or fatherYR is greater than 9000
subsample = filter(row -> row.motherYR <= 9000 , df)
subsample = filter(row -> row.fatherYR <= 9000, subsample)



regFERT = lm(@formula(children ~ gam_fearn0_A_), df)
print(regFERT)
print("R-Squared: ", r2(regFERT))

regFERT = lm(@formula(children ~ gamABS + marital + currentage), df)
print(regFERT)
print("R-Squared: ", r2(regFERT))



reg1 = lm(@formula(gam_fearn0_A_ ~ JplusQ + currentagefourth + edmaxyrs + JAGE + QAGE), df)
print(reg1)
print("R-Squared: ", r2(reg1))


#reg1 = lm(@formula(gam_fearn0_A_ ~ JplusQ + currentagefourth + edmaxyrs + JAGE + QAGE + annualHRSwife + children), df)
#print(reg1)
print("R-Squared: ", r2(reg1))


#reg1 = lm(@formula(gam_fearn0_A_ ~ JplusQ + currentagefourth + edmaxyrs + JAGE + QAGE + annualHRSwife + childAGE + oneind), df)
#print(reg1)
print("R-Squared: ", r2(reg1))


#reg1 = lm(@formula(gamABS ~ JplusQ + currentagefourth + edmaxyrs + JAGE + QAGE + annualHRSwife + childAGE + oneind), df)
#print(reg1)
print("R-Squared: ", r2(reg1))


#reg1 = lm(@formula(gamABS ~ JplusQ + currentagefourth + edmaxyrs + JAGE + QAGE + annualHRSwife + childAGE + fearn0_P0 + oneind), df)
#print(reg1)
print("R-Squared: ", r2(reg1))


#reg1 = lm(@formula(gamABS ~ JplusQ + currentagefourth + edmaxyrs + JAGE + QAGE + annualHRSwife + childAGE + fearn0_P0 + oneind + tenure + year), df)
#print(reg1)
print("R-Squared: ", r2(reg1))


#reg1 = lm(@formula(gamABS ~ JplusQ + currentagefourth + edmaxyrs + JAGE + QAGE + annualHRSwife + childAGE + fearn0_P0 + oneind + motherYR + fatherYR + tenure + year), subsample)
#print(reg1)
print("R-Squared: ", r2(reg1))


#reg1 = lm(@formula(gamABS ~ JplusQ + currentagefourth + edmaxyrs + JAGE + QAGE + annualHRSwife + childAGE + fearn0_P0 + twoind + motherYR + fatherYR + tenure + year), subsample)
#print(reg1)
print("R-Squared: ", r2(reg1))


#reg1 = lm(@formula(GAM_POS ~ J + Q + currentagefourth + edmaxyrs + annualHRSwife + childAGE + fearn0_P0), df)
#print(reg1)
print("R-Squared: ", r2(reg1))







reg2 = lm(@formula(gamABS ~ occ + year + state), subsample)
print(reg2)
print("R-Squared: ", r2(reg2))

subsample.residuals = residuals(reg2)



reg3 = lm(@formula(gamABS ~ occ + year + state), df)
print(reg3)
print("R-Squared: ", r2(reg3))

df.residuals = residuals(reg3)






variables_SUB = [:J, :Q, :currentage, :edmaxyrs, :annualHRS, :annualHRSwife, :children, :fearn0_P0, :motherYR, :fatherYR, :tenure, :rGDPgrow, :OLF, :race, :marital]

variables_FULL = [:J, :Q, :currentage, :edmaxyrs, :annualHRS, :annualHRSwife, :children, :fearn0_P0, :tenure, :rGDPgrow, :OLF, :race, :marital]



# Filter df and subsample to only have the variables in the vector and the residuals variable
subsample = select(subsample, vcat(variables_SUB, :residuals))
df = select(df, vcat(variables_FULL, :residuals))



function higherORDER!(jdf, independent_vars)
    dummy = [:marital, :race]

    # Add higher-order terms for non-categorical variables
    for col in setdiff(independent_vars, dummy)
        jdf[:, Symbol("$(col)_squared")] = jdf[:, col] .^ 2
    end


    for col in dummy
        unique_values = unique(jdf[:, col])
        for val in unique_values[1:end-1]  # Exclude the last dummy to avoid redundancy
            dummy_name = Symbol("$(col)_$(val)")
            jdf[:, dummy_name] = jdf[:, col] .== val
        end
        select!(jdf, Not(col))  # Remove the original categorical variable
        
        println("Converted column $(col) to categorical.")
    end


    REALindependent_vars = setdiff(Symbol.(names(jdf)), [:residuals])

    # Add interaction terms for all combinations of two variables
    for combo in combinations(REALindependent_vars, 2)
        interaction_name = Symbol("$(combo[1])_x_$(combo[2])")
        jdf[:, interaction_name] = jdf[:, combo[1]] .* jdf[:, combo[2]]
        println("Added interaction term for $(combo[1]) and $(combo[2]).")
    end

end

# Convert categorical variables to dummy variables for subsample
higherORDER!(subsample, variables_SUB)

# Convert categorical variables to dummy variables for full sample (df)
higherORDER!(df, variables_FULL)



dropmissing!(subsample)
dropmissing!(df)



function convert_to_float32!(df::DataFrame)
    # Convert relevant columns to Float32
    for col in names(df)
        if eltype(df[!, col]) == Float64
            df[!, col] = Float32.(df[!, col])
        end
    end
end

# Apply the function to subsample
convert_to_float32!(subsample)
convert_to_float32!(df)

println("Column types in subsample:")
for col in names(subsample)
    println("$col: ", eltype(subsample[!, col]))
end


GC.gc()


target = :residuals

# Prepare the data for GLMNet
X = Matrix(df[:, Not(target)])  # Predictor matrix
y = Vector(df[:, target])       # Target vector


GC.gc()



println("Fitting LASSO model...")

lasso_model = glmnet(X, y, alpha=1.0)

coefficients = lasso_model.betas

# Convert coefficients to a DataFrame
coefficients_df = DataFrame(coefficients, :auto)

# Add a column with the variable names
variable_names_lasso = names(df[:, Not(target)])
coefficients_df.variable = variable_names_lasso

# Reorder columns to make 'variable' the first column
coefficients_df = select(coefficients_df, :variable, Not(:variable))

# Export the DataFrame to a CSV file
CSV.write("/Users/ethanballou/Documents/Papers/EarningsRisk/CodeOutput/REALcoefficientsFIN_REGULAR_FULL.csv", coefficients_df)

# Create a DataFrame with the absolute values of the coefficients, excluding the 'variable' column
coefficients_df_abs1 = copy(coefficients_df)
for col in names(coefficients_df_abs1)[2:end]
    coefficients_df_abs1[!, col] = abs.(coefficients_df_abs1[!, col])
end

# Sort the coefficients_df by ascending order for each column starting from the last column and excluding the variable name column
for col in reverse(names(coefficients_df_abs1)[2:end])
    coefficients_df_abs1 = sort(coefficients_df_abs1, col)
end

CSV.write("/Users/ethanballou/Documents/Papers/EarningsRisk/CodeOutput/REALcoefficientsFIN_ABS_FULL.csv", coefficients_df_abs)







# Prepare the data for GLMNet
X = Matrix(subsample[:, Not(target)])  # Predictor matrix
y = Vector(subsample[:, target])       # Target vector


GC.gc()




println("Fitting LASSO model...")

lasso_model = glmnet(X, y, alpha=1.0)

coefficients = lasso_model.betas

# Convert coefficients to a DataFrame
coefficients_df = DataFrame(coefficients, :auto)

# Add a column with the variable names
variable_names_lasso = names(subsample[:, Not(target)])
coefficients_df.variable = variable_names_lasso

# Reorder columns to make 'variable' the first column
coefficients_df = select(coefficients_df, :variable, Not(:variable))

# Export the DataFrame to a CSV file
CSV.write("/Users/ethanballou/Documents/Papers/EarningsRisk/CodeOutput/REALcoefficientsFIN_REGULAR_SUB.csv", coefficients_df)

# Create a DataFrame with the absolute values of the coefficients, excluding the 'variable' column
coefficients_df_abs = copy(coefficients_df)
for col in names(coefficients_df_abs)[2:end]
    coefficients_df_abs[!, col] = abs.(coefficients_df_abs[!, col])
end

# Sort the coefficients_df by ascending order for each column starting from the last column and excluding the variable name column
for col in reverse(names(coefficients_df_abs)[2:end])
    coefficients_df = sort(coefficients_df, col)
end

CSV.write("/Users/ethanballou/Documents/Papers/EarningsRisk/CodeOutput/REALcoefficientsFIN_ABS_SUB.csv", coefficients_df_abs)








# Sort the coefficients_df_abs by the column x100
coefficients_df_abs1 = sort(coefficients_df_abs1, :x50, rev = true)

# Extract the top 30 values of the variable column in coefficients_df_abs
top_30_variables = coefficients_df_abs1[1:30, :variable]

# Convert the string values to symbols
top_30_symbols = Symbol.(top_30_variables)


# Ensure all columns are present and have the correct data types
required_columns = [:tenure, 
    :fearn0_P0, 
    :edmaxyrs, 
    :children_squared, 
    :children, 
    :children_x_fearn0_P0, 
    :Q, 
    :fatherYR, 
    :residuals,
    :currentage_x_edmaxyrs,
    :fearn0_P0_x_tenure,
    :edmaxyrs_squared,
    :children_x_tenure,
    :Q_x_tenure,
    :motherYR
    ]


# Create a new DataFrame with only the required columns
required_df = select(df, vcat(top_30_symbols, :residuals))



# Convert relevant columns to Float32
for col in names(required_df)
    if eltype(required_df[!, col]) == Float32
        required_df[!, col] = Float64.(required_df[!, col])
    end
end



# Regress all the variables in required_df on residuals
formula = Term(:residuals) ~ sum(Term.(Symbol.(names(required_df, Not(:residuals)))))
reg_all = lm(formula, required_df)
print(reg_all)
println("R-Squared: ", r2(reg_all))






reg4 = lm(@formula(residuals ~ tenure + fearn0_P0 + edmaxyrs + children_squared + children + children_x_fearn0_P0 + Q + fatherYR), required_df)
print(reg4)
print("R-Squared: ", r2(reg4))



reg4 = lm(@formula(residuals ~ tenure + fearn0_P0 + edmaxyrs + children_squared + children + children_x_fearn0_P0 + Q + fatherYR + currentage_x_edmaxyrs + fearn0_P0_x_tenure + edmaxyrs_squared + children_x_tenure), required_df)
print(reg4)
print("R-Squared: ", r2(reg4))





#ridge_model = glmnet(X, y, alpha=0)
















