# Risk1

using DataFrames
using GLM
using CSV
using CategoricalArrays
using Combinatorics
using Statistics
using StatsModels
using GLMNet



df = CSV.read("/Users/ethanballou/Documents/Data/Risk/old_gam_data.csv", DataFrame)


dropmissing!(df, [:J])
dropmissing!(df, [:gam_fearn0_A_])
dropmissing!(df, [:aep])

df.occ = categorical(df.occ)
df.year = categorical(df.year)
df.state = categorical(df.state)

df.group = categorical(df.group)
df.relation = categorical(df.relation)

df.twoind = categorical(df.twoind)

df.race = categorical(df.race)




# First Run: state, occ, year
# Second Run: relation, group
# Third Run: twoind, aep
# Fourth Run: tenure, age^4, race, edmaxyrs


# occ variable interactions?
# inc varaible interactions?
# take the variation of a variable out by residuals then regress tha variable again to check if a squared version is viable?
# interactions with jplusQ? interact j or q with things like age, tenure, etc.?



reg1 = lm(@formula(gam_fearn0_A_ ~ JplusQ + occ + state + year + relation + group + twoind + aep + tenure + currentagefourth + race + edmaxyrs), df)
#print(reg1)

print("R-Squared: ", r2(reg1))


println("\n")
println(var(df.gam_fearn0_A_))
println("\n")


df.residuals = residuals(reg1)







selected_predictors = [:JplusQ, :personid, :J, :Q, :gam_fearn0_A_, :gam_fwwage0_A_, :gam_fhwage0_A_, :over, :risktol, :cohort, :agegrp, :birthgrp, :state, :year, :occ, :relation, :group, :aep, :twoind, :noearn5, :race, :tenure, :currentagefourth]  # Replace with your chosen variables

inc_predictors = [:fearn0_P0, :fwwage0_P0, :fhwage0_P0, :fearn1_P0, :fearn1_P1, :fwwage1_P0, :fwwage1_P1, :fhwage1_P0, :fhwage1_P1]  # Replace with your chosen variables


newDF1 = DataFrames.select(df, Not(selected_predictors))
newDF1 = DataFrames.select(newDF1, Not(inc_predictors))

target = :residuals
VARS = names(newDF1)

# Convert column names to symbols
rename!(newDF1, Symbol.(names(newDF1)))

# List of columns to convert to categorical
categore = [:student, :self, :both, :postgrad, :union, :hourly, :veteran, :limited, :unemp, 
            :OLF, :nojobinfo, :tenmiss, :tenmiss26, :lowtenure, :white, :educwrths, 
            :censdiv, :oneind, :soc2010, :oneind]




df_cols = Symbol.(names(newDF1))  # Convert column names to Symbols

# Find missing columns
missing_cols = setdiff(categore, df_cols)

if !isempty(missing_cols)
    println("Warning: These columns are not found in df: ", missing_cols)
end

# Convert specified columns to categorical and create dummy variables
for col in intersect(categore, df_cols)
    println("Processing column: $col")
    newDF1[!, col] = categorical(newDF1[!, col])
    dummies = DataFrame(StatsModels.modelmatrix(Term(col), newDF1), :auto)
    # Rename dummy columns to include the original variable name
    rename!(dummies, Dict(old_name => Symbol("$(col)_", old_name) for old_name in names(dummies)))
    newDF1 = hcat(newDF1, dummies)
    #println("Dummy variables for $col:")
end



# Drop the original categorical columns
newDF1 = DataFrames.select(newDF1, Not(categore))


#dropmissing!(newDF1, [:aep])

# Check for missing values and print columns with missing values
missing_cols = [names(newDF1)[i] for i in 1:ncol(newDF1) if any(ismissing, newDF1[:, i])]
if !isempty(missing_cols)
    println("Warning: Missing values detected in columns: ", missing_cols)
end

# Prepare the data for GLMNet
X = Matrix(newDF1[:, Not(target)])  # Predictor matrix
y = Vector(newDF1[:, target])       # Target vector




# Fit the LASSO model
lasso_model = glmnet(X, y, alpha=1.0)

println(lasso_model)


coefficients = lasso_model.betas

# Take the absolute value of all the coefficient values
coefficients = abs.(coefficients)


# Convert coefficients to a DataFrame
coefficients_df = DataFrame(coefficients, :auto)

# Add a column with the variable names
variable_names = names(newDF1[:, Not(target)])
coefficients_df.variable = variable_names

# Reorder columns to make 'variable' the first column
coefficients_df = select(coefficients_df, :variable, Not(:variable))


# Sort the coefficients_df by ascending order for each column starting from the last column and excluding the variable name column
for col in reverse(names(coefficients_df)[2:end])
    coefficients_df = sort(coefficients_df, col)
end


# Export the DataFrame to a CSV file
CSV.write("/Users/ethanballou/Documents/Papers/EarningsRisk/CodeOutput/coefficients5.csv", coefficients_df)
















