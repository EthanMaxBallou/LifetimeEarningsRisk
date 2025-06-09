

import shap
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




nn1 = tf.keras.models.load_model("/Users/ethanballou/Documents/Github/LifetimeEarningsRisk/Risk_NN1.keras")



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

shap_summary_df.to_csv('/Users/ethanballou/Documents/GitHub/LifetimeEarningsRisk/shap_summary.csv', index=False)


top_cont = [
    'currentage', 'rGDPgrow', 
    'PrRecess', 'tenure', 'currentagesq', 
    'currentagecube', 'ma5aep', 
    'fhwage0_P0'
]


# Verify the shapes of shap_values and X_test
print(f"SHAP values shape: {shap_values[:,:,0].shape}")
print(f"X_test shape: {X_test.shape}")


# Filter SHAP values and feature names to only include top_cont variables
top_cont_indices = [data.columns.get_loc(feature) for feature in top_cont]
shap_values_top_cont = shap_values_reshaped[:, top_cont_indices]
X_test_top_cont = X_test[:, top_cont_indices]

# Visualize the SHAP summary plot for the test set with top_cont variables
shap.summary_plot(shap_values_top_cont, X_test_top_cont, feature_names=top_cont, max_display=len(top_cont))

#plt.savefig('/Users/ethanballou/Documents/GitHub/LifetimeEarningsRisk/shap_summary_plot.png')


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
feature_y = 'fhwage0_P0'      # Second variable

# Get indices of the features
feature_x_index = data.columns.get_loc(feature_x)
feature_y_index = data.columns.get_loc(feature_y)

# Create the dependence plot
shap.dependence_plot(feature_x_index, shap_values_reshaped, X_test, feature_names=data.columns, interaction_index=feature_y_index)






# Generate SHAP dependence plots for 'rGDPgrow' against every industry dummy
industry_dummies = [
    'twoind_1', 'twoind_3', 'twoind_4', 'twoind_5', 'twoind_6', 'twoind_7', 
    'twoind_8', 'twoind_9', 'twoind_10', 'twoind_11', 'twoind_12', 'twoind_13', 
    'twoind_14', 'twoind_15', 'twoind_16', 'twoind_18', 'twoind_19', 'twoind_20', 
    'twoind_21', 'twoind_22', 'twoind_23', 'twoind_24', 'twoind_25', 'twoind_27', 
    'twoind_28', 'twoind_29', 'twoind_30', 'twoind_31', 'twoind_33', 'twoind_999'
]

feature_x = 'rGDPgrow'  # First variable
feature_x_index = data.columns.get_loc(feature_x)

for industry in industry_dummies:
    feature_y_index = data.columns.get_loc(industry)
    shap.dependence_plot(feature_x_index, shap_values_reshaped, X_test, feature_names=data.columns, interaction_index=feature_y_index)




# Generate SHAP dependence plots for 'currentage' against every industry dummy
feature_x = 'currentage'  # First variable
feature_x_index = data.columns.get_loc(feature_x)

for industry in industry_dummies:
    feature_y_index = data.columns.get_loc(industry)
    shap.dependence_plot(feature_x_index, shap_values_reshaped, X_test, feature_names=data.columns, interaction_index=feature_y_index)





# Generate SHAP dependence plots for 'currentage' against every race dummy
race_dummies = ['race_1', 'race_2', 'race_3', 'race_4', 'race_5', 'race_7']


# Generate SHAP dependence plots for 'currentage' against every industry dummy
feature_x = 'currentage'  # First variable
feature_x_index = data.columns.get_loc(feature_x)

for industry in race_dummies:
    feature_y_index = data.columns.get_loc(industry)
    shap.dependence_plot(feature_x_index, shap_values_reshaped, X_test, feature_names=data.columns, interaction_index=feature_y_index)




# Generate SHAP dependence plots for 'currentage' against every industry dummy
feature_x = 'rGDPgrow'  # First variable
feature_x_index = data.columns.get_loc(feature_x)

for industry in race_dummies:
    feature_y_index = data.columns.get_loc(industry)
    shap.dependence_plot(feature_x_index, shap_values_reshaped, X_test, feature_names=data.columns, interaction_index=feature_y_index)










