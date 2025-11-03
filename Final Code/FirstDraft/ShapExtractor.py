import pandas as pd
import os

# Define the input and output file paths
input_file = '/Users/ethanballou/Documents/GitHub/LifetimeEarningsRisk/shap_summary.csv'
output_dir = '/Users/ethanballou/Documents/GitHub/LifetimeEarningsRisk'
occupation_output = os.path.join(output_dir, 'occupation_shap.csv')
industry_output = os.path.join(output_dir, 'industry_shap.csv')

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
