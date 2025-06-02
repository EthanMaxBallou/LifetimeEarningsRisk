#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Thu Jan  9 14:36:36 2025

@author: ethanballou
"""


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



# Load the .dta file
dta_file_path = "/Users/ethanballou/Documents/Data/Risk/old_gam_data_modified.dta"
data, meta = pyreadstat.read_dta(dta_file_path)

# Display the first few rows of the dataframe
print(data.head())

# Optionally, inspect metadata
print(meta.column_names)


# Columns to drop from the dataset
columns_to_keep = [
    'year', 'personid', 'state', 'occ', 'twoind', 'race', 
    'currentage', 'veteran', 'rGDPgrow', 
    'PrRecess', 'OLF', 'tenure', 'currentagesq', 
    'currentagecube', 'cohort', 'ma5aep', 
    'fhwage0_P0', 'gammaP_WEIGHTED', 'edmaxyrs'
]


# Drop columns not in columns_to_keep
data = data[columns_to_keep]




# Create a vector with the names of the columns to convert
columns_to_convert = ['race', 'occ', 'year', 'state', 'cohort', 'twoind']

# Create dummy variables for all specified columns in one line
data = pd.get_dummies(data, columns=columns_to_convert, drop_first=False)

# Generate education level indicators
data['EDU1'] = (data['edmaxyrs'] < 12).astype(int)
data['EDU2'] = ((data['edmaxyrs'] >= 12) & (data['edmaxyrs'] < 14)).astype(int)
data['EDU3'] = ((data['edmaxyrs'] >= 14) & (data['edmaxyrs'] < 16)).astype(int)




# Separate the target variable from the data
target = data[['gammaP_WEIGHTED']]  # Extract the target column
data = data.drop(columns=['gammaP_WEIGHTED'])  # Remove the target column from the data


# Drop 'personid' column from the dataset
data = data.drop(columns=['personid', 'edmaxyrs'], errors='ignore')



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


num_variables = X_train.shape[1]


# 1000 or 2000, 2-3 layers?, sigmoid

nn1 = Sequential()
nn1.add(Input((num_variables,)))

nn1.add(Dense(1000, activation="relu"))
nn1.add(Dropout(0.3))
nn1.add(Dense(1000, activation="relu"))
nn1.add(Dense(1000, activation="relu"))

nn1.add(Dense(1, activation="linear"))


# Print model summary
nn1.summary()

nn1.compile(optimizer="adam", loss="mse", metrics=["mse"])




early_stopping = EarlyStopping(monitor='val_loss', patience=3, restore_best_weights=True)
Network1 = nn1.fit(X_train, y_train, epochs=20, validation_data=(X_val, y_val), verbose=1, callbacks=[early_stopping])



test_loss, test_mse = nn1.evaluate(X_test, y_test, verbose=0)
print(f"Test MSE after training: {test_mse}")




nn1.save("/Users/ethanballou/Documents/Github/LifetimeEarningsRisk/Risk_NN1.keras")







X_background = X_train[:50]
explainer = shap.DeepExplainer(nn1, X_background)

shap_values = explainer.shap_values(X_test)


# Reshape to remove the singleton dimension (100, 8086, 1) -> (100, 8086)
shap_values_reshaped = shap_values.squeeze(axis=-1)




sample_indices = np.random.choice(X_test.shape[0], 5, replace=False)
X_test_sample = X_test[sample_indices]



# Average SHAP values across the 100 samples for each feature
ABSaverage_shap_values = np.mean(np.abs(shap_values_reshaped), axis=0)


# Create a DataFrame for better readability
shap_summary_df = pd.DataFrame({
    'Feature': data.columns,  # Feature names from the dataset
    'Average SHAP Value': ABSaverage_shap_values
})

# Sort by the absolute average SHAP value to find the most important features
shap_summary_df = shap_summary_df.sort_values(by='Average SHAP Value', ascending=False)

# Display the sorted SHAP summary
print(shap_summary_df.head(10))

shap_summary_df.to_csv('/Users/ethanballou/Documents/GitHub/LifetimeEarningsRisk/shap_summary.csv', index=False)






# Verify the shapes of shap_values and X_test
print(f"SHAP values shape: {shap_values[:,:,0].shape}")
print(f"X_test shape: {X_test.shape}")


# Visualize the SHAP force plot for the sample
shap.force_plot(explainer.expected_value, shap_values, X_test_sample, feature_names=data.columns)


# Visualize the SHAP summary plot for the test set
shap.summary_plot(shap_values[:,:,0], X_test, feature_names=data.columns, max_display=50)


# Ensure you are using the entire test set for both SHAP values and features

shap.dependence_plot(0, shap_values, X_test)


shap.dependence_plot((0, 1), shap_values[:,:,0], X_test)


# Visualize the SHAP force plot for the sample
shap.force_plot(explainer.expected_value, shap_values, X_test_sample, feature_names=data.columns)


# Visualize the SHAP summary plot for the test set
shap.summary_plot(shap_values[:,:,0], X_test, feature_names=data.columns, max_display=20)



shap.initjs()

shap.save_html("/Users/ethanballou/Documents/Data/PSID4/df/force_plot.html", shap.force_plot(explainer.expected_value, shap_values, X_test_sample, feature_names=data.columns))










# real













