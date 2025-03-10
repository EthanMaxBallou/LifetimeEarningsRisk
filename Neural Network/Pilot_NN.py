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







data = pd.read_csv('/Users/ethanballou/Documents/Data/PSID4/df/data1.csv')

dropMAIN = ['ER32007', 'ER33281', 'ER32008', 'ER33275', 'ER32021']  # Replace with actual column names

data = data.drop(columns=dropMAIN)





psidCODE = pd.read_csv('/Users/ethanballou/Documents/Data/PSID4/J341928/codebook.csv')


# Create a dictionary to store the number of unique values for each column
unique_values = {column: data[column].nunique() for column in data.columns}

# Convert to a Pandas DataFrame for better readability
unique_values_df = pd.DataFrame(list(unique_values.items()), columns=['Column', 'Unique Values'])

columns_to_dummy = unique_values_df[unique_values_df['Unique Values'] <= 20]['Column'].tolist()

data = pd.get_dummies(data, columns=columns_to_dummy, drop_first=False)


target = pd.read_csv('/Users/ethanballou/Documents/Data/PSID4/df/target1.csv')


target = target[target['personid'].isin(data['personid'])]

target = target.sort_values(by='personid')
data = data.sort_values(by='personid')


code = pd.read_csv('/Users/ethanballou/Documents/Data/PSID4/variable_names_REMOVE.csv')

columns_to_remove = code['Variable'].tolist()

data = data.drop(columns=columns_to_remove, errors='ignore')



X = data.values  # Features
y = target.drop(columns=['personid', 'year']).values[:,0]  # Target variables, dropping personid and year



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


nn1.add(Dense(1000, activation="sigmoid"))
nn1.add(Dropout(0.3))
nn1.add(Dense(1000, activation="sigmoid"))
nn1.add(Dense(1000, activation="sigmoid"))



nn1.add(Dense(1, activation="linear"))



# Print model summary
nn1.summary()

nn1.compile(optimizer="adam", loss="mse", metrics=["mse"])



Network1 = nn1.fit(X_train, y_train, epochs=20, validation_data=(X_val, y_val), verbose=1)

Network2 = nn1.fit(X_train, y_train, epochs=40, validation_data=(X_val, y_val), verbose=1)



Network3 = nn1.fit(X_train, y_train, epochs=20, validation_data=(X_val, y_val), verbose=1)

Network4 = nn1.fit(X_train, y_train, epochs=10, validation_data=(X_val, y_val), verbose=1)


test_loss, test_mse = nn1.evaluate(X_test, y_test, verbose=0)
print(f"Test MSE after retraining: {test_mse}")




nn1.save("/Users/ethanballou/Documents/Papers/EarningsRisk/Risk_NN.keras")





sample_indices = np.random.choice(X_test.shape[0], 5, replace=False)
X_test_sample = X_test[sample_indices]


# Select a small subset of the training data for the background dataset
X_background = X_train[:50]


explainer = shap.DeepExplainer(nn1, X_background)


shap_values = explainer.shap_values(X_test)



# DO WITH ABSOLUTE VALUE AND NOT ASOLUTE VALUE BEFORE AVERAGE TO SEE WHICH CHANGE SIGN

# Reshape to remove the singleton dimension (100, 8086, 1) -> (100, 8086)
shap_values_reshaped = shap_values.squeeze(axis=-1)

# Average SHAP values across the 100 samples for each feature
ABSaverage_shap_values = np.mean(np.abs(shap_values_reshaped), axis=0)

average_shap_values = np.mean(shap_values_reshaped, axis=0)



# Create a DataFrame for better readability
shap_summary_df = pd.DataFrame({
    'Feature': data.columns,  # Feature names from the dataset
    'Average SHAP Value': ABSaverage_shap_values
})

# Sort by the absolute average SHAP value to find the most important features
shap_summary_df['Abs SHAP Value'] = np.abs(shap_summary_df['Average SHAP Value'])
shap_summary_df = shap_summary_df.sort_values(by='Abs SHAP Value', ascending=False)

# Display the sorted SHAP summary
print(shap_summary_df.head(10))






# Extract base variable names from shap_summary_df
shap_summary_df['Base_Variable'] = shap_summary_df['Feature'].str.split('_').str[0]

# Merge with psidCODE to get the labels
shap_summary_df = shap_summary_df.merge(psidCODE, left_on='Base_Variable', right_on='Variable Name', how='left')

# Drop unnecessary columns if needed and rename for clarity
shap_summary_df = shap_summary_df.drop(columns=['Variable Name'])




shap_summary_df.to_csv('/Users/ethanballou/Documents/Papers/EarningsRisk/SHAP_Results.csv', index=False)






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



shap.initjs()

shap.save_html("/Users/ethanballou/Documents/Data/PSID4/df/force_plot.html", shap.force_plot(explainer.expected_value, shap_values, X_test_sample, feature_names=data.columns))










# real



early_stopping = EarlyStopping(monitor='val_loss', patience=10, restore_best_weights=True)
Network1 = nn1.fit(X_train, y_train, epochs=2, validation_data=(X_val, y_val), verbose=1, callbacks=[early_stopping])
    




nn1 = Sequential()
nn1.add(Input((num_variables,)))

nn1.add(Dense(4000, activation="relu"))
nn1.add(Dropout(0.3))
nn1.add(Dense(2000, activation="relu"))
nn1.add(Dense(2000, activation="relu"))
nn1.add(Dense(2000, activation="relu"))

nn1.add(Dense(1, activation="linear"))



# Print model summary
nn1.summary()



lasso = LassoCV(cv=5, alphas=[1e-5, 1e-4, 1e-3, 1e-2, 1e-1], max_iter=10000, random_state=42).fit(X_train, y_train)

# Extract coefficients
coef_df = pd.DataFrame({
    'Feature': data.drop(columns=['personid', 'year'], errors='ignore').columns,
    'Coefficient': lasso.coef_
}).sort_values(by='Coefficient', ascending=False)

# Display results
print(coef_df)
















