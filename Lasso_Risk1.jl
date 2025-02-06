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


df = leftjoin(df, res, on = [:year, :personid], makeunique = true)



dropmissing!(df, [:marital])
dropmissing!(df, [:children])
dropmissing!(df, [:annualHRS])
dropmissing!(df, [:annualHRSwife])
dropmissing!(df, [:sex])


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
df = filter(row -> row.unemp == 0, df)


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
df.gamABS = abs.(df.gam_fearn0_A_)

# positive or negative gam dummy
df.GAM_POS = df.gam_fearn0_A_ .> 0



# Create a DataFrame listing variable names and the number of unique values for each
unique_values_df = DataFrame(
    variable = names(df),
    unique_values = [length(unique(df[!, col])) for col in names(df)]
)



# Drop rows where sex is 9 or motherYR or fatherYR is greater than 9000
subsample = filter(row -> row.motherYR <= 9000 , df)
subsample = filter(row -> row.fatherYR <= 9000, subsample)




reg1 = lm(@formula(gam_fearn0_A_ ~ JplusQ + currentagefourth + edmaxyrs + JAGE + QAGE), df)
print(reg1)
print("R-Squared: ", r2(reg1))


reg1 = lm(@formula(gam_fearn0_A_ ~ JplusQ + currentagefourth + edmaxyrs + JAGE + QAGE + annualHRSwife + children), df)
print(reg1)
print("R-Squared: ", r2(reg1))


reg1 = lm(@formula(gam_fearn0_A_ ~ JplusQ + currentagefourth + edmaxyrs + JAGE + QAGE + annualHRSwife + childAGE + oneind), df)
print(reg1)
print("R-Squared: ", r2(reg1))


reg1 = lm(@formula(gamABS ~ JplusQ + currentagefourth + edmaxyrs + JAGE + QAGE + annualHRSwife + childAGE + oneind), df)
print(reg1)
print("R-Squared: ", r2(reg1))


reg1 = lm(@formula(gamABS ~ JplusQ + currentagefourth + edmaxyrs + JAGE + QAGE + annualHRSwife + childAGE + fearn0_P0 + oneind), df)
print(reg1)
print("R-Squared: ", r2(reg1))


reg1 = lm(@formula(gamABS ~ JplusQ + currentagefourth + edmaxyrs + JAGE + QAGE + annualHRSwife + childAGE + fearn0_P0 + oneind + tenure + year), df)
print(reg1)
print("R-Squared: ", r2(reg1))


reg1 = lm(@formula(gamABS ~ JplusQ + currentagefourth + edmaxyrs + JAGE + QAGE + annualHRSwife + childAGE + fearn0_P0 + oneind + motherYR + fatherYR + tenure + year), subsample)
print(reg1)
print("R-Squared: ", r2(reg1))


reg1 = lm(@formula(gamABS ~ JplusQ + currentagefourth + edmaxyrs + JAGE + QAGE + annualHRSwife + childAGE + fearn0_P0 + twoind + motherYR + fatherYR + tenure + year), subsample)
print(reg1)
print("R-Squared: ", r2(reg1))


reg1 = lm(@formula(GAM_POS ~ J + Q + currentagefourth + edmaxyrs + annualHRSwife + childAGE + fearn0_P0), df)
print(reg1)
print("R-Squared: ", r2(reg1))







reg2 = lm(@formula(gamABS ~ occ + year), subsample)
print(reg2)
print("R-Squared: ", r2(reg2))

subsample.residuals = residuals(reg2)


reg3 = lm(@formula(gamABS ~ occ + year), df)
print(reg3)
print("R-Squared: ", r2(reg3))

df.residuals = residuals(reg3)






variables_SUB = [:J, :Q, :currentage, :edmaxyrs, :annualHRS, :annualHRSwife, :children, :fearn0_P0, :motherYR, :fatherYR, :tenure]

variables_FULL = [:J, :Q, :currentage, :edmaxyrs, :annualHRS, :annualHRSwife, :children, :fearn0_P0, :tenure]



# Filter df and subsample to only have the variables in the vector and the residuals variable
subsample = select(subsample, vcat(variables_SUB, :residuals))
df = select(df, vcat(variables_FULL, :residuals))



function higherORDER!(jdf, independent_vars)
    # Add higher-order terms for non-categorical variables
    for col in independent_vars
        jdf[:, Symbol("$(col)_squared")] = jdf[:, col] .^ 2
        jdf[:, Symbol("$(col)_cubed")] = jdf[:, col] .^ 3
        jdf[:, Symbol("$(col)_four")] = jdf[:, col] .^ 4
        jdf[:, Symbol("$(col)_five")] = jdf[:, col] .^ 5
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






target = :residuals

# Prepare the data for GLMNet
X = Matrix(subsample[:, Not(target)])  # Predictor matrix
y = Vector(subsample[:, target])       # Target vector




# Fit the LASSO model
lasso_model = glmnet(X, y, alpha=1.0)














