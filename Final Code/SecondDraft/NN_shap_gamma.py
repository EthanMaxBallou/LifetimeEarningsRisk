

import shap
import os
import pandas as pd
import matplotlib.pyplot as plt
import numpy as np
import pyreadstat
import tensorflow as tf
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




nn1 = tf.keras.models.load_model("/Users/ethanballou/Documents/Github/LifetimeEarningsRisk/Risk_NN_Gamma.keras")



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

shap_summary_df.to_csv('/Users/ethanballou/Documents/GitHub/LifetimeEarningsRisk/shap_summary_gamma.csv', index=False)


top_cont = [
    'currentage', 'rGDPgrow', 
    'PrRecess', 'tenure', 'currentagesq', 
    'currentagecube', 'ma5aep', 
    'fhwage'
]


# Verify the shapes of shap_values and X_test
print(f"SHAP values shape: {shap_values[:,:,0].shape}")
print(f"X_test shape: {X_test.shape}")


# Filter SHAP values and feature names to only include top_cont variables
top_cont_indices = [data.columns.get_loc(feature) for feature in top_cont]
shap_values_top_cont = shap_values_reshaped[:, top_cont_indices]
X_test_top_cont = X_test[:, top_cont_indices]




plt.figure(figsize=(12, 8))
shap.summary_plot(shap_values_top_cont, X_test_top_cont, feature_names=top_cont, max_display=len(top_cont), show=False)
plt.tight_layout()
plt.savefig('/Users/ethanballou/Documents/GitHub/LifetimeEarningsRisk/GAMMA_shap_summary_plot.png', bbox_inches='tight', dpi=300)
plt.close()




# Print all variable names in the dataset
print("Variable names in the dataset:")
print(data.columns.tolist())










# Generate SHAP dependence plot for interaction between two specific variables
feature_x = 'rGDPgrow'  # First variable
feature_y = 'currentage'      # Second variable

# Get indices of the features
feature_x_index = data.columns.get_loc(feature_x)
feature_y_index = data.columns.get_loc(feature_y)

# Create the dependence plot
shap.dependence_plot(feature_x_index, shap_values_reshaped, X_test, feature_names=data.columns, interaction_index=feature_y_index)





# Generate SHAP dependence plot for interaction between two specific variables
feature_x = 'rGDPgrow'  # First variable
feature_y = 'fhwage'      # Second variable

# Get indices of the features
feature_x_index = data.columns.get_loc(feature_x)
feature_y_index = data.columns.get_loc(feature_y)

# Create the dependence plot
shap.dependence_plot(feature_x_index, shap_values_reshaped, X_test, feature_names=data.columns, interaction_index=feature_y_index)







# Shap extractor code



# Define the input and output file paths
input_file = '/Users/ethanballou/Documents/GitHub/LifetimeEarningsRisk/shap_summary_gamma.csv'
output_dir = '/Users/ethanballou/Documents/GitHub/LifetimeEarningsRisk'
occupation_output = os.path.join(output_dir, 'occupation_shap_gamma.csv')
industry_output = os.path.join(output_dir, 'industry_shap_gamma.csv')

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






