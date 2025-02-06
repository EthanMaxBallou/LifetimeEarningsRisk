# Risk Pilot

using DataFrames
using GLM
using StatFiles
using CSV




newDF = CSV.read("/Users/ethanballou/Documents/Data/PSID4/1995.csv", DataFrame)

gammas = CSV.read("/Users/ethanballou/Documents/Papers/EarningsRisk/Scott/replication package/208972-V1/Data/REtrends-NoGr/interstagecalculations-reshaped-gam-collapsed.csv", DataFrame)

uyear = 1995
tyear = uyear + 0

cols_to_check = names(gammas)[3:end]
filtered_gammas = filter(row -> any(!ismissing(row[col]) for col in cols_to_check), gammas)


newDF.personid = (newDF.ER30001 .* 1000) + newDF.ER30002
newDF.personidUNI = (newDF.personid .* 10000) .+ uyear


FIN_filtered = dropmissing(filtered_gammas)
FIN_filtered = filter(row -> row.year == tyear, FIN_filtered)

FIN_filtered.personidUNI = (FIN_filtered.personid .* 10000) .+ uyear

ppl_list = unique(FIN_filtered.personid)
ppl_list_check = copy(ppl_list)


newDF = filter(row -> row.personid in ppl_list, newDF)



CSV.write("/Users/ethanballou/Documents/Data/PSID4/df/data1.csv", newDF)
CSV.write("/Users/ethanballou/Documents/Data/PSID4/df/target1.csv", FIN_filtered)



# make categorical variables categorical and remove uneeded
# make 94raw, 94cat, realInteractions datasets















