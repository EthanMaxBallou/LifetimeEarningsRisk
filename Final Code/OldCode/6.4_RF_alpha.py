
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


# Split data into train, validation, and test sets
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




rf1 = RandomForestRegressor(
    n_estimators=500,        # number of trees
    max_features='sqrt',     # features considered at each split (standard for regression)
    max_depth=None,          # let trees grow fully (can tune this)
    min_samples_leaf=5,      # minimum samples per leaf (helps prevent overfitting)
    random_state=42,
    n_jobs=-1                # use all cores
)

rf1.fit(X_train, y_train)


# Evaluate Random Forest on test set
rf1_predictions = rf1.predict(X_test)
rf1_mse = mean_squared_error(y_test, rf1_predictions)
print(f"Random Forest Test MSE: {rf1_mse}")







explainer = shap.TreeExplainer(rf1)

sample_idx = np.random.choice(X_test.shape[0], 500, replace=False)
shap_sample = X_test[sample_idx]
shap_values = explainer.shap_values(shap_sample, check_additivity=False)


# Average SHAP values across the 100 samples for each feature
ABSaverage_shap_values = np.mean(np.abs(shap_values), axis=0)


# Create a DataFrame for better readability
shap_summary_df = pd.DataFrame({
    'Feature': data.columns,  # Feature names from the dataset
    'Average SHAP Value': ABSaverage_shap_values
})

shap_summary_df.to_csv('/Users/ethanballou/Documents/GitHub/LifetimeEarningsRisk/RF_shap_summary_alpha.csv', index=False)




# Shap extractor code



# Define the input and output file paths
input_file = '/Users/ethanballou/Documents/GitHub/LifetimeEarningsRisk/RF_shap_summary_alpha.csv'
output_dir = '/Users/ethanballou/Documents/GitHub/LifetimeEarningsRisk'
occupation_output = os.path.join(output_dir, 'RF_occupation_shap_alpha.csv')
industry_output = os.path.join(output_dir, 'RF_industry_shap_alpha.csv')

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


# Split data into train, validation, and test sets
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




rf2 = RandomForestRegressor(
    n_estimators=500,        # number of trees
    max_features='sqrt',     # features considered at each split (standard for regression)
    max_depth=None,          # let trees grow fully (can tune this)
    min_samples_leaf=5,      # minimum samples per leaf (helps prevent overfitting)
    random_state=42,
    n_jobs=-1                # use all cores
)

rf2.fit(X_train, y_train)


# Evaluate Random Forest on test set
rf2_predictions = rf1.predict(X_test)
rf2_mse = mean_squared_error(y_test, rf2_predictions)
print(f"Random Forest Test MSE: {rf2_mse}")






explainer = shap.TreeExplainer(rf2)

sample_idx = np.random.choice(X_test.shape[0], 500, replace=False)
shap_sample = X_test[sample_idx]
shap_values = explainer.shap_values(shap_sample, check_additivity=False)


# Average SHAP values across the 100 samples for each feature
ABSaverage_shap_values = np.mean(np.abs(shap_values), axis=0)


# Create a DataFrame for better readability
shap_summary_df = pd.DataFrame({
    'Feature': data.columns,  # Feature names from the dataset
    'Average SHAP Value': ABSaverage_shap_values
})

shap_summary_df.to_csv('/Users/ethanballou/Documents/GitHub/LifetimeEarningsRisk/RF_shap_summary_gamma.csv', index=False)




# Shap extractor code



# Define the input and output file paths
input_file = '/Users/ethanballou/Documents/GitHub/LifetimeEarningsRisk/RF_shap_summary_gamma.csv'
output_dir = '/Users/ethanballou/Documents/GitHub/LifetimeEarningsRisk'
occupation_output = os.path.join(output_dir, 'RF_occupation_shap_gamma.csv')
industry_output = os.path.join(output_dir, 'RF_industry_shap_gamma.csv')

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








