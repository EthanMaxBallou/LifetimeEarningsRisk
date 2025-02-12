#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Sun Jan 12 22:55:19 2025

@author: ethanballou
"""



import os
import pandas as pd

# Define the folder path
folder_path = '/Users/ethanballou/Documents/Papers/EarningsRisk'

psidCODE = pd.read_csv('/Users/ethanballou/Documents/Data/PSID4/J341928/codebook.csv')



dataframes = []


# Loop through all files in the folder
for file in os.listdir(folder_path):
    # Check if the file starts with 'SHAP_Results' and is a CSV file
    if file.startswith('SHAP_Results') and file.endswith('.csv'):
        # Construct the full file path
        file_path = os.path.join(folder_path, file)
        
        # Read the file into a dataframe
        df = pd.read_csv(file_path)
        
        # Sort the dataframe by the SHAP column in descending order
        df_sorted = df.sort_values(by='Average SHAP Value', ascending=False).reset_index(drop=True)
        
        # Add a ranking column based on the sorted order
        df_sorted['Rank'] = df_sorted.index + 1
        
        dataframes.append(df_sorted[['Base_Variable', 'Rank']])
        
        
        
        
all_data = pd.concat(dataframes)


# Group by Base_Variable and compute the average rank
average_ranks = all_data.groupby('Base_Variable')['Rank'].mean().reset_index()

# Sort the variables by their average rank in ascending order (lower is better)
average_ranks = average_ranks.sort_values(by='Rank')


# Merge with psidCODE to get the labels
average_ranks = average_ranks.merge(psidCODE, left_on='Base_Variable', right_on='Variable Name', how='left')




# Save the result to a CSV file (optional)
average_ranks.to_csv(os.path.join(folder_path, 'Average_Ranks.csv'), index=False)


