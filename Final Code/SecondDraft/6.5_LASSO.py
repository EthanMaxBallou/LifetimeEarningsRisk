#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Sun Apr 12 18:04:49 2026

@author: ethanballou
"""


import os
import shap
import pandas as pd
import matplotlib.pyplot as plt
import numpy as np
import pyreadstat
from sklearn import datasets
from sklearn.model_selection import train_test_split
from sklearn.preprocessing import MinMaxScaler
from tensorflow.keras.models import Sequential
from tensorflow.keras.layers import Input, Dense, Dropout, Activation
from tensorflow.keras.callbacks import EarlyStopping


from sklearn.model_selection import cross_val_score
from sklearn.linear_model import LinearRegression, Ridge, Lasso
from sklearn.ensemble import RandomForestRegressor
from sklearn.metrics import mean_squared_error
from sklearn.linear_model import LassoCV




# ALPHA

# Load the CSV file
data_path = '/Users/ethanballou/Documents/Data/Risk/ALP_data_NN.csv'
data = pd.read_csv(data_path)


# Load the target variable
target_path = '/Users/ethanballou/Documents/Data/Risk/ALP_target_NN.csv'
target = pd.read_csv(target_path)



X = data.values  # Features
y = target.values  # Target variables, dropping personid and year


# Fit loose Lasso
model = Lasso(alpha=0.00001, max_iter=7500)  # very loose, adjust as needed
model.fit(X, y)

# Calculate SHAP values
explainer = shap.LinearExplainer(model, X)
shap_values = explainer.shap_values(X)



# CS/ML standard
mean_abs_shap = np.mean(np.abs(shap_values), axis=0)

# Your version (net directional)
abs_mean_shap = np.abs(np.mean(shap_values, axis=0))

shap_summary_df = pd.DataFrame({
    'Feature': data.columns,
    'Average SHAP Value': mean_abs_shap,
    'Abs Mean SHAP (Net directional)': abs_mean_shap
})


shap_summary_df.to_csv('/Users/ethanballou/Documents/GitHub/LifetimeEarningsRisk/Lasso_shap_summary_alpha.csv', index=False)




# Shap extractor code



# Define the input and output file paths
input_file = '/Users/ethanballou/Documents/GitHub/LifetimeEarningsRisk/Lasso_shap_summary_alpha.csv'
output_dir = '/Users/ethanballou/Documents/GitHub/LifetimeEarningsRisk'
occupation_output = os.path.join(output_dir, 'Lasso_occupation_shap_alpha.csv')
industry_output = os.path.join(output_dir, 'Lasso_industry_shap_alpha.csv')

# Read the SHAP summary CSV
df = pd.read_csv(input_file)

# Filter and sort occupation variables
occupation_df = df[df['Feature'].str.startswith('occ_')].copy()
occupation_df['Occupation Code'] = occupation_df['Feature'].str.replace('occ_', '')
occupation_df = occupation_df.sort_values(by='Average SHAP Value', ascending=False)
occupation_df = occupation_df[['Feature', 'Occupation Code', 'Average SHAP Value']]

# Filter and sort industry variables
industry_df = df[df['Feature'].str.startswith('twoind_')].copy()
industry_df['Industry Code'] = industry_df['Feature'].str.replace('twoind_', '')
industry_df = industry_df.sort_values(by='Average SHAP Value', ascending=False)
industry_df = industry_df[['Feature', 'Industry Code', 'Average SHAP Value']]

# Write to CSV files
occupation_df.to_csv(occupation_output, index=False)
industry_df.to_csv(industry_output, index=False)

print(f"Occupation SHAP values saved to: {occupation_output}")
print(f"Industry SHAP values saved to: {industry_output}")












# GAMMA

# Load the CSV file
data_path = '/Users/ethanballou/Documents/Data/Risk/GAM_data_NN.csv'
data = pd.read_csv(data_path)


# Load the target variable
target_path = '/Users/ethanballou/Documents/Data/Risk/GAM_target_NN.csv'
target = pd.read_csv(target_path)



X = data.values  # Features
y = target.values  # Target variables, dropping personid and year


# Fit loose Lasso
model = Lasso(alpha=0.00001, max_iter=7500)  # very loose, adjust as needed
model.fit(X, y)

# Calculate SHAP values
explainer = shap.LinearExplainer(model, X)
shap_values = explainer.shap_values(X)



# CS/ML standard
mean_abs_shap = np.mean(np.abs(shap_values), axis=0)

# Your version (net directional)
abs_mean_shap = np.abs(np.mean(shap_values, axis=0))

shap_summary_df = pd.DataFrame({
    'Feature': data.columns,
    'Average SHAP Value': mean_abs_shap,
    'Abs Mean SHAP (Net directional)': abs_mean_shap
})


shap_summary_df.to_csv('/Users/ethanballou/Documents/GitHub/LifetimeEarningsRisk/Lasso_shap_summary_gamma.csv', index=False)




# Shap extractor code



# Define the input and output file paths
input_file = '/Users/ethanballou/Documents/GitHub/LifetimeEarningsRisk/Lasso_shap_summary_gamma.csv'
output_dir = '/Users/ethanballou/Documents/GitHub/LifetimeEarningsRisk'
occupation_output = os.path.join(output_dir, 'Lasso_occupation_shap_gamma.csv')
industry_output = os.path.join(output_dir, 'Lasso_industry_shap_gamma.csv')

# Read the SHAP summary CSV
df = pd.read_csv(input_file)

# Filter and sort occupation variables
occupation_df = df[df['Feature'].str.startswith('occ_')].copy()
occupation_df['Occupation Code'] = occupation_df['Feature'].str.replace('occ_', '')
occupation_df = occupation_df.sort_values(by='Average SHAP Value', ascending=False)
occupation_df = occupation_df[['Feature', 'Occupation Code', 'Average SHAP Value']]

# Filter and sort industry variables
industry_df = df[df['Feature'].str.startswith('twoind_')].copy()
industry_df['Industry Code'] = industry_df['Feature'].str.replace('twoind_', '')
industry_df = industry_df.sort_values(by='Average SHAP Value', ascending=False)
industry_df = industry_df[['Feature', 'Industry Code', 'Average SHAP Value']]

# Write to CSV files
occupation_df.to_csv(occupation_output, index=False)
industry_df.to_csv(industry_output, index=False)

print(f"Occupation SHAP values saved to: {occupation_output}")
print(f"Industry SHAP values saved to: {industry_output}")



