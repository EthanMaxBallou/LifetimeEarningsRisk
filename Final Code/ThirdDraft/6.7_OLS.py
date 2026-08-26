#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
6.7_OLS.py

Full-sample OLS predictions on the same dummy-expanded feature matrices the
ML models use (the *_data_NN*.csv files written by 6 / 6.1), for gamma and
alpha, hourly (fhwage) and annual (fearn). Unlike the ML methods there is no
train/val/test split: the regression is fit on ALL rows and fitted values are
exported for ALL rows, one CSV per outcome x measure, in the same
personid/year/pred_<m> format as the NN/RF/LASSO prediction files so
7_Tables.do can merge them through the same loop.

The stored matrices keep every dummy level (drop_first=False upstream), which
makes a raw least-squares solve rank-deficient; as in 6.6, one reference level
per dummy block and any zero-variance column are dropped before fitting.
Scaling is unnecessary: MinMax scaling is an affine reparameterization that
leaves OLS fitted values unchanged.
"""

import pandas as pd
from sklearn.linear_model import LinearRegression

DATADIR = '/Users/ethanballou/Documents/Data/LER_Draft2'

DUMMY_PREFIXES = ('race_', 'occ_', 'year_', 'censdiv_', 'cohort_', 'twoind_', 'agebin_')

# (feature prefix, output suffix) for outcome x earnings measure
CASES = [
    ('ALP', 'alpha'),
    ('GAM', 'gamma'),
    ('ALP', 'alpha_fearn'),
    ('GAM', 'gamma_fearn'),
]

for pfx, outname in CASES:
    fsfx = '_fearn' if outname.endswith('_fearn') else ''

    feat   = pd.read_csv(f'{DATADIR}/{pfx}_data_NN{fsfx}.csv')
    target = pd.read_csv(f'{DATADIR}/{pfx}_target_NN{fsfx}.csv')
    ids    = pd.read_csv(f'{DATADIR}/{pfx}_ids_NN{fsfx}.csv')

    # Drop one reference level per dummy block, then any non-varying column
    drop_cols = []
    for p in DUMMY_PREFIXES:
        block = [c for c in feat.columns if c.startswith(p)]
        if block:
            drop_cols.append(block[0])
    X = feat.drop(columns=drop_cols).values.astype(float)
    varying = X.std(axis=0) > 0
    X = X[:, varying]
    y = target.iloc[:, 0].values

    ols = LinearRegression().fit(X, y)

    preds_out = ids.copy()
    preds_out['pred_ols'] = ols.predict(X)
    out_path = f'{DATADIR}/OLS_predictions_{outname}.csv'
    preds_out.to_csv(out_path, index=False)
    print(f'OLS predictions exported to {out_path} '
          f'({len(preds_out)} rows, R2 = {ols.score(X, y):.4f})')
