

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



# FHWAGE ANALYSIS


# ALPHA

# Load the CSV file
data_path = '/Users/ethanballou/Documents/Data/LER_Draft2/ALP_data_NN.csv'
data = pd.read_csv(data_path)


# Load the target variable
target_path = '/Users/ethanballou/Documents/Data/LER_Draft2/ALP_target_NN.csv'
target = pd.read_csv(target_path)



X = data.values  # Features
y = target.values  # Target variables, dropping personid and year


# Split data into train, validation, and test sets (same split as NN/RF)
X_train, X_temp, y_train, y_temp = train_test_split(X, y, test_size=0.3, random_state=42)
X_val, X_test, y_val, y_test = train_test_split(X_temp, y_temp, test_size=0.5, random_state=42)


scaler = MinMaxScaler()


# Fit the scaler on the training data and transform all sets
X_train = scaler.fit_transform(X_train)
X_val = scaler.transform(X_val)
X_test = scaler.transform(X_test)


# Reshape the target arrays to 2D for MinMaxScaler
y_train = y_train.reshape(-1, 1)
y_val = y_val.reshape(-1, 1)
y_test = y_test.reshape(-1, 1)

# Normalize the target
scaler_y = MinMaxScaler()
y_train = scaler_y.fit_transform(y_train)
y_val = scaler_y.transform(y_val)
y_test = scaler_y.transform(y_test)


# Fit loose Lasso on the training sample only
model = Lasso(alpha=0.00001, max_iter=7500)  # very loose, adjust as needed
model.fit(X_train, y_train)


# Evaluate Lasso on test set
lasso_predictions = model.predict(X_test)
lasso_mse = mean_squared_error(y_test, lasso_predictions)
print(f"Lasso Test MSE: {lasso_mse}")


# Calculate SHAP values (scaled units, matching the RF/NN setup)
X_all = scaler.transform(X)
explainer = shap.LinearExplainer(model, X_all)
shap_values = explainer.shap_values(X_all)



# CS/ML standard
mean_abs_shap = np.mean(np.abs(shap_values), axis=0)

# Your version (net directional)
abs_mean_shap = np.abs(np.mean(shap_values, axis=0))

shap_summary_df = pd.DataFrame({
    'Feature': data.columns,
    'Average SHAP Value': mean_abs_shap,
    'Abs Mean SHAP (Net directional)': abs_mean_shap
})


shap_summary_df.to_csv(os.path.join(SHAPDIR, 'Lasso_shap_summary_alpha.csv'), index=False)


# Fitted values for ALL observations, converted back to natural units
ids = pd.read_csv('/Users/ethanballou/Documents/Data/LER_Draft2/ALP_ids_NN.csv')
preds_out = ids.copy()
preds_out['pred_lasso'] = scaler_y.inverse_transform(model.predict(X_all).reshape(-1, 1)).ravel()
preds_out.to_csv('/Users/ethanballou/Documents/Data/LER_Draft2/Lasso_predictions_alpha.csv', index=False)
print("Lasso predictions exported to /Users/ethanballou/Documents/Data/LER_Draft2/Lasso_predictions_alpha.csv")




# Shap extractor code



# Define the input and output file paths
input_file = os.path.join(SHAPDIR, 'Lasso_shap_summary_alpha.csv')
output_dir = SHAPDIR
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
data_path = '/Users/ethanballou/Documents/Data/LER_Draft2/GAM_data_NN.csv'
data = pd.read_csv(data_path)


# Load the target variable
target_path = '/Users/ethanballou/Documents/Data/LER_Draft2/GAM_target_NN.csv'
target = pd.read_csv(target_path)



X = data.values  # Features
y = target.values  # Target variables, dropping personid and year


# Split data into train, validation, and test sets (same split as NN/RF)
X_train, X_temp, y_train, y_temp = train_test_split(X, y, test_size=0.3, random_state=42)
X_val, X_test, y_val, y_test = train_test_split(X_temp, y_temp, test_size=0.5, random_state=42)


scaler = MinMaxScaler()


# Fit the scaler on the training data and transform all sets
X_train = scaler.fit_transform(X_train)
X_val = scaler.transform(X_val)
X_test = scaler.transform(X_test)


# Reshape the target arrays to 2D for MinMaxScaler
y_train = y_train.reshape(-1, 1)
y_val = y_val.reshape(-1, 1)
y_test = y_test.reshape(-1, 1)

# Normalize the target
scaler_y = MinMaxScaler()
y_train = scaler_y.fit_transform(y_train)
y_val = scaler_y.transform(y_val)
y_test = scaler_y.transform(y_test)


# Fit loose Lasso on the training sample only
model = Lasso(alpha=0.00001, max_iter=7500)  # very loose, adjust as needed
model.fit(X_train, y_train)


# Evaluate Lasso on test set
lasso_predictions = model.predict(X_test)
lasso_mse = mean_squared_error(y_test, lasso_predictions)
print(f"Lasso Test MSE: {lasso_mse}")


# Calculate SHAP values (scaled units, matching the RF/NN setup)
X_all = scaler.transform(X)
explainer = shap.LinearExplainer(model, X_all)
shap_values = explainer.shap_values(X_all)



# CS/ML standard
mean_abs_shap = np.mean(np.abs(shap_values), axis=0)

# Your version (net directional)
abs_mean_shap = np.abs(np.mean(shap_values, axis=0))

shap_summary_df = pd.DataFrame({
    'Feature': data.columns,
    'Average SHAP Value': mean_abs_shap,
    'Abs Mean SHAP (Net directional)': abs_mean_shap
})


shap_summary_df.to_csv(os.path.join(SHAPDIR, 'Lasso_shap_summary_gamma.csv'), index=False)


# Fitted values for ALL observations, converted back to natural units
ids = pd.read_csv('/Users/ethanballou/Documents/Data/LER_Draft2/GAM_ids_NN.csv')
preds_out = ids.copy()
preds_out['pred_lasso'] = scaler_y.inverse_transform(model.predict(X_all).reshape(-1, 1)).ravel()
preds_out.to_csv('/Users/ethanballou/Documents/Data/LER_Draft2/Lasso_predictions_gamma.csv', index=False)
print("Lasso predictions exported to /Users/ethanballou/Documents/Data/LER_Draft2/Lasso_predictions_gamma.csv")




# Shap extractor code



# Define the input and output file paths
input_file = os.path.join(SHAPDIR, 'Lasso_shap_summary_gamma.csv')
output_dir = SHAPDIR
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


















# FEARN ANALYSIS


import tensorflow as tf      # already imported in these files
tf.keras.backend.clear_session()

# ALPHA

# Load the CSV file
data_path = '/Users/ethanballou/Documents/Data/LER_Draft2/ALP_data_NN_fearn.csv'
data = pd.read_csv(data_path)


# Load the target variable
target_path = '/Users/ethanballou/Documents/Data/LER_Draft2/ALP_target_NN_fearn.csv'
target = pd.read_csv(target_path)



X = data.values  # Features
y = target.values  # Target variables, dropping personid and year


# Split data into train, validation, and test sets (same split as NN/RF)
X_train, X_temp, y_train, y_temp = train_test_split(X, y, test_size=0.3, random_state=42)
X_val, X_test, y_val, y_test = train_test_split(X_temp, y_temp, test_size=0.5, random_state=42)


scaler = MinMaxScaler()


# Fit the scaler on the training data and transform all sets
X_train = scaler.fit_transform(X_train)
X_val = scaler.transform(X_val)
X_test = scaler.transform(X_test)


# Reshape the target arrays to 2D for MinMaxScaler
y_train = y_train.reshape(-1, 1)
y_val = y_val.reshape(-1, 1)
y_test = y_test.reshape(-1, 1)

# Normalize the target
scaler_y = MinMaxScaler()
y_train = scaler_y.fit_transform(y_train)
y_val = scaler_y.transform(y_val)
y_test = scaler_y.transform(y_test)


# Fit loose Lasso on the training sample only
model = Lasso(alpha=0.00001, max_iter=7500)  # very loose, adjust as needed
model.fit(X_train, y_train)


# Evaluate Lasso on test set
lasso_predictions = model.predict(X_test)
lasso_mse = mean_squared_error(y_test, lasso_predictions)
print(f"Lasso Test MSE: {lasso_mse}")


# Calculate SHAP values (scaled units, matching the RF/NN setup)
X_all = scaler.transform(X)
explainer = shap.LinearExplainer(model, X_all)
shap_values = explainer.shap_values(X_all)



# CS/ML standard
mean_abs_shap = np.mean(np.abs(shap_values), axis=0)

# Your version (net directional)
abs_mean_shap = np.abs(np.mean(shap_values, axis=0))

shap_summary_df = pd.DataFrame({
    'Feature': data.columns,
    'Average SHAP Value': mean_abs_shap,
    'Abs Mean SHAP (Net directional)': abs_mean_shap
})


shap_summary_df.to_csv(os.path.join(SHAPDIR, 'Lasso_shap_summary_alpha_fearn.csv'), index=False)


# Fitted values for ALL observations, converted back to natural units
ids = pd.read_csv('/Users/ethanballou/Documents/Data/LER_Draft2/ALP_ids_NN_fearn.csv')
preds_out = ids.copy()
preds_out['pred_lasso'] = scaler_y.inverse_transform(model.predict(X_all).reshape(-1, 1)).ravel()
preds_out.to_csv('/Users/ethanballou/Documents/Data/LER_Draft2/Lasso_predictions_alpha_fearn.csv', index=False)
print("Lasso predictions exported to /Users/ethanballou/Documents/Data/LER_Draft2/Lasso_predictions_alpha_fearn.csv")




# Shap extractor code



# Define the input and output file paths
input_file = os.path.join(SHAPDIR, 'Lasso_shap_summary_alpha_fearn.csv')
output_dir = SHAPDIR
occupation_output = os.path.join(output_dir, 'Lasso_occupation_shap_alpha_fearn.csv')
industry_output = os.path.join(output_dir, 'Lasso_industry_shap_alpha_fearn.csv')

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
data_path = '/Users/ethanballou/Documents/Data/LER_Draft2/GAM_data_NN_fearn.csv'
data = pd.read_csv(data_path)


# Load the target variable
target_path = '/Users/ethanballou/Documents/Data/LER_Draft2/GAM_target_NN_fearn.csv'
target = pd.read_csv(target_path)



X = data.values  # Features
y = target.values  # Target variables, dropping personid and year


# Split data into train, validation, and test sets (same split as NN/RF)
X_train, X_temp, y_train, y_temp = train_test_split(X, y, test_size=0.3, random_state=42)
X_val, X_test, y_val, y_test = train_test_split(X_temp, y_temp, test_size=0.5, random_state=42)


scaler = MinMaxScaler()


# Fit the scaler on the training data and transform all sets
X_train = scaler.fit_transform(X_train)
X_val = scaler.transform(X_val)
X_test = scaler.transform(X_test)


# Reshape the target arrays to 2D for MinMaxScaler
y_train = y_train.reshape(-1, 1)
y_val = y_val.reshape(-1, 1)
y_test = y_test.reshape(-1, 1)

# Normalize the target
scaler_y = MinMaxScaler()
y_train = scaler_y.fit_transform(y_train)
y_val = scaler_y.transform(y_val)
y_test = scaler_y.transform(y_test)


# Fit loose Lasso on the training sample only
model = Lasso(alpha=0.00001, max_iter=7500)  # very loose, adjust as needed
model.fit(X_train, y_train)


# Evaluate Lasso on test set
lasso_predictions = model.predict(X_test)
lasso_mse = mean_squared_error(y_test, lasso_predictions)
print(f"Lasso Test MSE: {lasso_mse}")


# Calculate SHAP values (scaled units, matching the RF/NN setup)
X_all = scaler.transform(X)
explainer = shap.LinearExplainer(model, X_all)
shap_values = explainer.shap_values(X_all)



# CS/ML standard
mean_abs_shap = np.mean(np.abs(shap_values), axis=0)

# Your version (net directional)
abs_mean_shap = np.abs(np.mean(shap_values, axis=0))

shap_summary_df = pd.DataFrame({
    'Feature': data.columns,
    'Average SHAP Value': mean_abs_shap,
    'Abs Mean SHAP (Net directional)': abs_mean_shap
})


shap_summary_df.to_csv(os.path.join(SHAPDIR, 'Lasso_shap_summary_gamma_fearn.csv'), index=False)


# Fitted values for ALL observations, converted back to natural units
ids = pd.read_csv('/Users/ethanballou/Documents/Data/LER_Draft2/GAM_ids_NN_fearn.csv')
preds_out = ids.copy()
preds_out['pred_lasso'] = scaler_y.inverse_transform(model.predict(X_all).reshape(-1, 1)).ravel()
preds_out.to_csv('/Users/ethanballou/Documents/Data/LER_Draft2/Lasso_predictions_gamma_fearn.csv', index=False)
print("Lasso predictions exported to /Users/ethanballou/Documents/Data/LER_Draft2/Lasso_predictions_gamma_fearn.csv")




# Shap extractor code



# Define the input and output file paths
input_file = os.path.join(SHAPDIR, 'Lasso_shap_summary_gamma_fearn.csv')
output_dir = SHAPDIR
occupation_output = os.path.join(output_dir, 'Lasso_occupation_shap_gamma_fearn.csv')
industry_output = os.path.join(output_dir, 'Lasso_industry_shap_gamma_fearn.csv')

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


