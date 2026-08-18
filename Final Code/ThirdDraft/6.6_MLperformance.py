#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
6.6_MLperformance.py

Out-of-sample (test split) mean squared error of the three ML methods
(NN, RF, LASSO) for gamma and alpha, hourly (fhwage) and annual (fearn),
compared against an OLS baseline fit on the same dummy-expanded feature
matrix the models use (the *_data_NN*.csv files written by 6 / 6.1).
Exports one LaTeX table to OtherOutput/ThirdDraft.

NOTE: this file ASSUMES the model files (6, 6.1, 6.4, 6.5) all split the
data with random_state=42 (test_size=0.3, then 0.5 of the remainder).
Splitting a row-index vector of the same length with the same calls
reproduces their exact test rows. If the seeds or split sizes ever change
in the model files, they must be changed here too.
"""

import os
import numpy as np
import pandas as pd
from sklearn.model_selection import train_test_split
from sklearn.linear_model import LinearRegression

# ---------------------------------------------------------------------------
# OUTPUT PATHS
# Nothing is written to the repo root: tables/figures go to OUTDIR, SHAP CSVs
# to SHAPDIR, trained models to MODELDIR. Data intermediates stay in
# Documents/Data/LER_Draft2 (outside the repo) and are unaffected.
# ---------------------------------------------------------------------------
REPODIR  = '/Users/ethanballou/Documents/GitHub/LifetimeEarningsRisk'
OUTDIR   = os.path.join(REPODIR, 'OtherOutput', 'ThirdDraft')
SHAPDIR  = os.path.join(OUTDIR, 'shap')
MODELDIR = os.path.join(OUTDIR, 'models')
os.makedirs(SHAPDIR,  exist_ok=True)
os.makedirs(MODELDIR, exist_ok=True)


# ---------------------------------------------------------------------------
# OLS BASELINE
# Fit a standard OLS on the same feature matrix the ML models use (the
# *_data_NN*.csv written by 6 / 6.1; row order matches the ids/target CSVs),
# training rows only, and return the test-split MSE. The stored matrix keeps
# every dummy level (drop_first=False upstream), which is fine for the
# penalized/flexible methods but makes a raw least-squares solve rank-
# deficient and numerically explosive. So mimic a standard OLS specification:
# drop one reference level per dummy block and any column with no variation
# in the training rows (empty categories), then fit with an intercept.
# Scaling is unnecessary: the models' MinMaxScaler is an affine
# reparameterization that leaves OLS fitted values unchanged.
# ---------------------------------------------------------------------------

DUMMY_PREFIXES = ('race_', 'occ_', 'year_', 'censdiv_', 'cohort_', 'twoind_', 'agebin_')

def ols_test_mse(feat_path, y_all, index_train, index_test):
    feat = pd.read_csv(feat_path)
    drop_cols = []
    for p in DUMMY_PREFIXES:
        block = [c for c in feat.columns if c.startswith(p)]
        if block:
            drop_cols.append(block[0])
    X = feat.drop(columns=drop_cols).values.astype(float)
    X_train = X[index_train]
    varying = X_train.std(axis=0) > 0
    ols = LinearRegression().fit(X_train[:, varying], y_all[index_train])
    pred = ols.predict(X[index_test][:, varying])
    return ((pred - y_all[index_test]) ** 2).mean()




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

gam_hr_ols = ols_test_mse('/Users/ethanballou/Documents/Data/LER_Draft2/GAM_data_NN.csv',
                          data['actual'].values, index_train, index_test)

gam_hr_nn = ((test['pred_nn'] - test['actual']) ** 2).mean()
gam_hr_rf = ((test['pred_rf'] - test['actual']) ** 2).mean()
gam_hr_lasso = ((test['pred_lasso'] - test['actual']) ** 2).mean()
gam_hr_n = len(test)

print("Gamma hourly test MSE:")
print(f"  NN {gam_hr_nn:.5f}  RF {gam_hr_rf:.5f}  LASSO {gam_hr_lasso:.5f}  OLS {gam_hr_ols:.5f}")




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

gam_an_ols = ols_test_mse('/Users/ethanballou/Documents/Data/LER_Draft2/GAM_data_NN_fearn.csv',
                          data['actual'].values, index_train, index_test)

gam_an_nn = ((test['pred_nn'] - test['actual']) ** 2).mean()
gam_an_rf = ((test['pred_rf'] - test['actual']) ** 2).mean()
gam_an_lasso = ((test['pred_lasso'] - test['actual']) ** 2).mean()
gam_an_n = len(test)

print("Gamma annual test MSE:")
print(f"  NN {gam_an_nn:.5f}  RF {gam_an_rf:.5f}  LASSO {gam_an_lasso:.5f}  OLS {gam_an_ols:.5f}")




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

alph_hr_ols = ols_test_mse('/Users/ethanballou/Documents/Data/LER_Draft2/ALP_data_NN.csv',
                           data['actual'].values, index_train, index_test)

alph_hr_nn = ((test['pred_nn'] - test['actual']) ** 2).mean()
alph_hr_rf = ((test['pred_rf'] - test['actual']) ** 2).mean()
alph_hr_lasso = ((test['pred_lasso'] - test['actual']) ** 2).mean()
alph_hr_n = len(test)

print("Alpha hourly test MSE:")
print(f"  NN {alph_hr_nn:.5f}  RF {alph_hr_rf:.5f}  LASSO {alph_hr_lasso:.5f}  OLS {alph_hr_ols:.5f}")




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

alph_an_ols = ols_test_mse('/Users/ethanballou/Documents/Data/LER_Draft2/ALP_data_NN_fearn.csv',
                           data['actual'].values, index_train, index_test)

alph_an_nn = ((test['pred_nn'] - test['actual']) ** 2).mean()
alph_an_rf = ((test['pred_rf'] - test['actual']) ** 2).mean()
alph_an_lasso = ((test['pred_lasso'] - test['actual']) ** 2).mean()
alph_an_n = len(test)

print("Alpha annual test MSE:")
print(f"  NN {alph_an_nn:.5f}  RF {alph_an_rf:.5f}  LASSO {alph_an_lasso:.5f}  OLS {alph_an_ols:.5f}")




# BUILD AND EXPORT THE LATEX TABLE
# Columns: Gamma hourly, Gamma annual | Alpha hourly, Alpha annual
# MSE cells reported x 100 (the paper caption notes the scaling); the
# N (test) row is left unscaled.


table = ""
table += "\\begin{tabular}{lcc|cc}\n"
table += "\\hline\\hline\n"
table += " & \\multicolumn{2}{c|}{Gamma} & \\multicolumn{2}{c}{Alpha} \\\\\n"
table += " & Hourly & Annual & Hourly & Annual \\\\\n"
table += "\\hline\n"
table += f"NN & {100*gam_hr_nn:.3f} & {100*gam_an_nn:.3f} & {100*alph_hr_nn:.3f} & {100*alph_an_nn:.3f} \\\\\n"
table += f"Random Forest & {100*gam_hr_rf:.3f} & {100*gam_an_rf:.3f} & {100*alph_hr_rf:.3f} & {100*alph_an_rf:.3f} \\\\\n"
table += f"LASSO & {100*gam_hr_lasso:.3f} & {100*gam_an_lasso:.3f} & {100*alph_hr_lasso:.3f} & {100*alph_an_lasso:.3f} \\\\\n"
table += f"OLS & {100*gam_hr_ols:.3f} & {100*gam_an_ols:.3f} & {100*alph_hr_ols:.3f} & {100*alph_an_ols:.3f} \\\\\n"
table += "\\hline\n"
table += f"N (test) & {gam_hr_n:,} & {gam_an_n:,} & {alph_hr_n:,} & {alph_an_n:,} \\\\\n"
table += "\\hline\\hline\n"
table += "\\end{tabular}\n"

output_path = os.path.join(OUTDIR, 'ml_test_mse.tex')

with open(output_path, 'w') as f:
    f.write(table)

print(f"Test MSE table written to {output_path}")
