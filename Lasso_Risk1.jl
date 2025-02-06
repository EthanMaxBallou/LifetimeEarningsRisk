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


df.marital = zeros(size(df, 1))
df.numCHILD = zeros(size(df, 1))
df.annualHRS = zeros(size(df, 1))
df.annualHRSwife = zeros(size(df, 1))



# Extract unique years and personids
unique_years = unique(df.year)
unique_personids = unique(df.personid)

# Create a new DataFrame with personid as the first column
result_df = DataFrame(personid = unique_personids)

# Add a column for each unique year in result_df and name them the year
for year in unique(df.year)
    result_df[!, Symbol(string(year))] = Vector{Union{Missing, Bool}}(missing, nrow(result_df))
end


for year in unique(df.year)

    marriageLABEL = labels.marital[1]
    childLABEL = labels.numCHILD[1]
    annHRLABEL = labels.annualHRS[1]
    annHRwifeLABEL = labels.annualHRSwife[1]

    


end




for year in unique(df.year)
    year_mask = df.year .== year
    year_labels = labels[labels.year .== year, :]
    
    marriageLABEL = year_labels.marital[1]
    childLABEL = year_labels.numCHILD[1]
    annHRLABEL = year_labels.annualHRS[1]
    annHRwifeLABEL = year_labels.annualHRSwife[1]

    for ID in unique(df.personid)
        id_mask = df.personid .== ID

        marital_values = otherPSID[!, marriageLABEL][(otherPSID.personid .== ID)]
        if !isempty(marital_values)
            df.marital[id_mask .& year_mask] .= coalesce.(marital_values, 0.0)
        end

        child_values = otherPSID[!, childLABEL][(otherPSID.personid .== ID)]
        if !isempty(child_values)
            df.numCHILD[id_mask .& year_mask] .= coalesce.(child_values, 0.0)
        end

        annHR_values = otherPSID[!, annHRLABEL][(otherPSID.personid .== ID)]
        if !isempty(annHR_values)
            df.annualHRS[id_mask .& year_mask] .= coalesce.(annHR_values, 0.0)
        end

        annHRwife_values = otherPSID[!, annHRwifeLABEL][(otherPSID.personid .== ID)]
        if !isempty(annHRwife_values)
            df.annualHRSwife[id_mask .& year_mask] .= coalesce.(annHRwife_values, 0.0)
        end
    end

    println(year)
end






df.occ = categorical(df.occ)
df.year = categorical(df.year)
df.state = categorical(df.state)

df.group = categorical(df.group)
df.relation = categorical(df.relation)

df.twoind = categorical(df.twoind)

df.race = categorical(df.race)

df.soc2010 = categorical(df.soc2010)



# Interact J with age with tenure with edmaxyrs
# Maybe only do people hwo are employed
# bring in family structure


# JandQ interactions


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







reg1 = lm(@formula(gam_fearn0_A_ ~ JplusQ + currentagefourth + edmaxyrs + JAGE + QAGE), df)
print(reg1)
print("R-Squared: ", r2(reg1))


reg1 = lm(@formula(gam_fearn0_A_ ~ JplusQ + currentagefourth + edmaxyrs + JAGE + QAGE + tenure), df)
print(reg1)
print("R-Squared: ", r2(reg1))


reg1 = lm(@formula(gam_fearn0_A_ ~ JplusQ + currentagefourth + edmaxyrs + JAGE + QAGE + JEDU + QEDU), df)
print(reg1)
print("R-Squared: ", r2(reg1))


reg1 = lm(@formula(gam_fearn0_A_ ~ JplusQ + edmaxyrs + J_Late + Q_Late), df)
print(reg1)
print("R-Squared: ", r2(reg1))


reg1 = lm(@formula(gam_fearn0_A_ ~ JplusQ + edmaxyrs + J_Late + Q_Late + J_Late_lin + Q_Late_lin + currentagefourth), df)
print(reg1)
print("R-Squared: ", r2(reg1))
















