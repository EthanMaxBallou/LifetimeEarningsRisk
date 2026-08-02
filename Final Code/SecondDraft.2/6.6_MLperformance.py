#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
6.6_MLperformance.py

Out-of-sample (test split) mean squared error of the three ML methods
(NN, RF, LASSO) for gamma and alpha, hourly (fhwage) and annual (fearn),
compared against simply predicting the training-sample mean. Exports one
LaTeX table to OtherOutput/SecondDraft2.

NOTE: this file ASSUMES the model files (6, 6.1, 6.4, 6.5) all split the
data with random_state=42 (test_size=0.3, then 0.5 of the remainder).
Splitting a row-index vector of the same length with the same calls
reproduces their exact test rows. If the seeds or split sizes ever change
in the model files, they must be changed here too.
"""

import numpy as np
import pandas as pd
from sklearn.model_selection import train_test_split




# GAMMA - HOURLY EARNINGS (fhwage)


ids = pd.read_csv('/Users/ethanballou/Documents/Data/LER_Draft2/GAM_ids_NN.csv')
target = pd.read_csv('/Users/ethanballou/Documents/Data/LER_Draft2/GAM_target_NN.csv')

# Actuals and predictions share the ids' person-year keys
data = ids.copy()
data['actual'] = target.iloc[:, 0].values

nn = pd.read_csv('/Users/ethanballou/Documents/Data/LER_Draft2/NN_predictions_gamma.csv')
rf = pd.read_csv('/Users/ethanballou/Documents/Data/LER_Draft2/RF_predictions_gamma.csv')
lasso = pd.read_csv('/Users/ethanballou/Documents/Data/LER_Draft2/Lasso_predictions_gamma.csv')

data = data.merge(nn, on=['personid', 'year'], how='left')
data = data.merge(rf, on=['personid', 'year'], how='left')
data = data.merge(lasso, on=['personid', 'year'], how='left')

# Rebuild the model files' train/val/test split (random_state=42 assumed)
index = np.arange(len(data))
index_train, index_temp = train_test_split(index, test_size=0.3, random_state=42)
index_val, index_test = train_test_split(index_temp, test_size=0.5, random_state=42)

test = data.iloc[index_test]
train_mean = data.iloc[index_train]['actual'].mean()

gam_hr_nn = ((test['pred_nn'] - test['actual']) ** 2).mean()
gam_hr_rf = ((test['pred_rf'] - test['actual']) ** 2).mean()
gam_hr_lasso = ((test['pred_lasso'] - test['actual']) ** 2).mean()
gam_hr_base = ((test['actual'] - train_mean) ** 2).mean()
gam_hr_n = len(test)

print("Gamma hourly test MSE:")
print(f"  NN {gam_hr_nn:.5f}  RF {gam_hr_rf:.5f}  LASSO {gam_hr_lasso:.5f}  train mean {gam_hr_base:.5f}")




# GAMMA - ANNUAL EARNINGS (fearn)


ids = pd.read_csv('/Users/ethanballou/Documents/Data/LER_Draft2/GAM_ids_NN_fearn.csv')
target = pd.read_csv('/Users/ethanballou/Documents/Data/LER_Draft2/GAM_target_NN_fearn.csv')

data = ids.copy()
data['actual'] = target.iloc[:, 0].values

nn = pd.read_csv('/Users/ethanballou/Documents/Data/LER_Draft2/NN_predictions_gamma_fearn.csv')
rf = pd.read_csv('/Users/ethanballou/Documents/Data/LER_Draft2/RF_predictions_gamma_fearn.csv')
lasso = pd.read_csv('/Users/ethanballou/Documents/Data/LER_Draft2/Lasso_predictions_gamma_fearn.csv')

data = data.merge(nn, on=['personid', 'year'], how='left')
data = data.merge(rf, on=['personid', 'year'], how='left')
data = data.merge(lasso, on=['personid', 'year'], how='left')

index = np.arange(len(data))
index_train, index_temp = train_test_split(index, test_size=0.3, random_state=42)
index_val, index_test = train_test_split(index_temp, test_size=0.5, random_state=42)

test = data.iloc[index_test]
train_mean = data.iloc[index_train]['actual'].mean()

gam_an_nn = ((test['pred_nn'] - test['actual']) ** 2).mean()
gam_an_rf = ((test['pred_rf'] - test['actual']) ** 2).mean()
gam_an_lasso = ((test['pred_lasso'] - test['actual']) ** 2).mean()
gam_an_base = ((test['actual'] - train_mean) ** 2).mean()
gam_an_n = len(test)

print("Gamma annual test MSE:")
print(f"  NN {gam_an_nn:.5f}  RF {gam_an_rf:.5f}  LASSO {gam_an_lasso:.5f}  train mean {gam_an_base:.5f}")




# ALPHA - HOURLY EARNINGS (fhwage)


ids = pd.read_csv('/Users/ethanballou/Documents/Data/LER_Draft2/ALP_ids_NN.csv')
target = pd.read_csv('/Users/ethanballou/Documents/Data/LER_Draft2/ALP_target_NN.csv')

data = ids.copy()
data['actual'] = target.iloc[:, 0].values

nn = pd.read_csv('/Users/ethanballou/Documents/Data/LER_Draft2/NN_predictions_alpha.csv')
rf = pd.read_csv('/Users/ethanballou/Documents/Data/LER_Draft2/RF_predictions_alpha.csv')
lasso = pd.read_csv('/Users/ethanballou/Documents/Data/LER_Draft2/Lasso_predictions_alpha.csv')

data = data.merge(nn, on=['personid', 'year'], how='left')
data = data.merge(rf, on=['personid', 'year'], how='left')
data = data.merge(lasso, on=['personid', 'year'], how='left')

index = np.arange(len(data))
index_train, index_temp = train_test_split(index, test_size=0.3, random_state=42)
index_val, index_test = train_test_split(index_temp, test_size=0.5, random_state=42)

test = data.iloc[index_test]
train_mean = data.iloc[index_train]['actual'].mean()

alph_hr_nn = ((test['pred_nn'] - test['actual']) ** 2).mean()
alph_hr_rf = ((test['pred_rf'] - test['actual']) ** 2).mean()
alph_hr_lasso = ((test['pred_lasso'] - test['actual']) ** 2).mean()
alph_hr_base = ((test['actual'] - train_mean) ** 2).mean()
alph_hr_n = len(test)

print("Alpha hourly test MSE:")
print(f"  NN {alph_hr_nn:.5f}  RF {alph_hr_rf:.5f}  LASSO {alph_hr_lasso:.5f}  train mean {alph_hr_base:.5f}")




# ALPHA - ANNUAL EARNINGS (fearn)


ids = pd.read_csv('/Users/ethanballou/Documents/Data/LER_Draft2/ALP_ids_NN_fearn.csv')
target = pd.read_csv('/Users/ethanballou/Documents/Data/LER_Draft2/ALP_target_NN_fearn.csv')

data = ids.copy()
data['actual'] = target.iloc[:, 0].values

nn = pd.read_csv('/Users/ethanballou/Documents/Data/LER_Draft2/NN_predictions_alpha_fearn.csv')
rf = pd.read_csv('/Users/ethanballou/Documents/Data/LER_Draft2/RF_predictions_alpha_fearn.csv')
lasso = pd.read_csv('/Users/ethanballou/Documents/Data/LER_Draft2/Lasso_predictions_alpha_fearn.csv')

data = data.merge(nn, on=['personid', 'year'], how='left')
data = data.merge(rf, on=['personid', 'year'], how='left')
data = data.merge(lasso, on=['personid', 'year'], how='left')

index = np.arange(len(data))
index_train, index_temp = train_test_split(index, test_size=0.3, random_state=42)
index_val, index_test = train_test_split(index_temp, test_size=0.5, random_state=42)

test = data.iloc[index_test]
train_mean = data.iloc[index_train]['actual'].mean()

alph_an_nn = ((test['pred_nn'] - test['actual']) ** 2).mean()
alph_an_rf = ((test['pred_rf'] - test['actual']) ** 2).mean()
alph_an_lasso = ((test['pred_lasso'] - test['actual']) ** 2).mean()
alph_an_base = ((test['actual'] - train_mean) ** 2).mean()
alph_an_n = len(test)

print("Alpha annual test MSE:")
print(f"  NN {alph_an_nn:.5f}  RF {alph_an_rf:.5f}  LASSO {alph_an_lasso:.5f}  train mean {alph_an_base:.5f}")




# BUILD AND EXPORT THE LATEX TABLE
# Columns: Gamma hourly, Gamma annual | Alpha hourly, Alpha annual


table = ""
table += "\\begin{tabular}{lcc|cc}\n"
table += "\\hline\\hline\n"
table += " & \\multicolumn{2}{c|}{Gamma} & \\multicolumn{2}{c}{Alpha} \\\\\n"
table += " & Hourly & Annual & Hourly & Annual \\\\\n"
table += "\\hline\n"
table += f"NN & {gam_hr_nn:.5f} & {gam_an_nn:.5f} & {alph_hr_nn:.5f} & {alph_an_nn:.5f} \\\\\n"
table += f"Random Forest & {gam_hr_rf:.5f} & {gam_an_rf:.5f} & {alph_hr_rf:.5f} & {alph_an_rf:.5f} \\\\\n"
table += f"LASSO & {gam_hr_lasso:.5f} & {gam_an_lasso:.5f} & {alph_hr_lasso:.5f} & {alph_an_lasso:.5f} \\\\\n"
table += f"Predict Train Mean & {gam_hr_base:.5f} & {gam_an_base:.5f} & {alph_hr_base:.5f} & {alph_an_base:.5f} \\\\\n"
table += "\\hline\n"
table += f"N (test) & {gam_hr_n:,} & {gam_an_n:,} & {alph_hr_n:,} & {alph_an_n:,} \\\\\n"
table += "\\hline\\hline\n"
table += "\\end{tabular}\n"

output_path = '/Users/ethanballou/Documents/GitHub/LifetimeEarningsRisk/OtherOutput/SecondDraft2/ml_test_mse.tex'

with open(output_path, 'w') as f:
    f.write(table)

print(f"Test MSE table written to {output_path}")
