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

df.soc2010 = categorical(df.soc2010)



# Interact J with age with tenure with edmaxyrs
# Maybe only do people hwo are employed
# bring in family structure


# JandQ interactions


df = filter(row -> row.unemp == 0, df)

df.JAGE = df.J.^2 .* df.currentage
df.QAGE = df.Q.^2 .* df.currentage


reg1 = lm(@formula(gam_fearn0_A_ ~ JplusQ + currentagefourth + edmaxyrs + JAGE + QAGE), df)
print(reg1)

print("R-Squared: ", r2(reg1))


reg1 = lm(@formula(gam_fearn0_A_ ~ JplusQ + currentagefourth + edmaxyrs + JAGE + QAGE + tenure), df)
print(reg1)

print("R-Squared: ", r2(reg1))



# Calculate the median age
median_age = median(df.currentage)

# Split the data based on the median value of age
df_below_median_age = filter(row -> row.currentage <= median_age, df)
df_above_median_age = filter(row -> row.currentage > median_age, df)


# Sample 10,000 points for below median age
sample_below = df_below_median_age[shuffle(1:end)[1:10000], :]

# Sample 10,000 points for above median age
sample_above = df_above_median_age[shuffle(1:end)[1:10000], :]


sample = df[shuffle(1:end)[1:10000], :]





# Scatter plot for sampled data below median age
scatter(sample_below.JplusQ, sample_below.gam_fearn0_A_, xlabel="J", ylabel="gam_fearn0_A_", title="Scatter plot of gam_fearn0_A_ vs J (Sampled Below Median Age)")

# Scatter plot for sampled data above median age
scatter(sample_above.JplusQ, sample_above.gam_fearn0_A_, xlabel="J", ylabel="gam_fearn0_A_", title="Scatter plot of gam_fearn0_A_ vs J (Sampled Above Median Age)")


scatter(sample.currentage, sample.gam_fearn0_A_, xlabel="J", ylabel="gam_fearn0_A_", title="Scatter plot of gam_fearn0_A_ vs J (Sampled Below Median Age)")





# Create scatter plots for both dataframes split on median age
scatter(df_below_median_age.J, df_below_median_age.gam_fearn0_A_, xlabel="J", ylabel="gam_fearn0_A_", title="Scatter plot of gam_fearn0_A_ vs J (Below Median Age)")


scatter(df_above_median_age.J, df_above_median_age.gam_fearn0_A_, xlabel="J", ylabel="gam_fearn0_A_", title="Scatter plot of gam_fearn0_A_ vs J (Above Median Age)")










