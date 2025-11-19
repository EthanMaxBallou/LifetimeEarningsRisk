
library(gglasso)
library(haven)


data <- read_dta("/Users/ethanballou/Documents/Data/Risk/old_gam_data_modified.dta")

# Check the column names of the dataset
print(colnames(data))


categorical_vars = c("state", "censdiv", "occ", "race", "year")

cont_vars = c("OLF", "tenure", "edmaxyrs", "fhwage0_P0")

index_var = c("personid", "year", "J", "Q")

dependent_var = "gammaP_WEIGHTED"




# Drop all columns not in these two vectors
#data <- data[, c(categorical_vars, cont_vars, dependent_var, index_var)]

data <- data[, c(categorical_vars, cont_vars, dependent_var)]



# Remove duplicate rows
# DONT DO IF DOING THE ONE VERSION
data <- data[!duplicated(data), ]


data_selected <- data[, c(categorical_vars, cont_vars)]


# Ensure categorical variables are treated as factors
data_selected$state <- as.factor(data_selected$state)
data_selected$censdiv <- as.factor(data_selected$censdiv)
data_selected$occ <- as.factor(data_selected$occ)
data_selected$race <- as.factor(data_selected$race)
data_selected$year <- as.factor(data_selected$year)

# Create dummy variables for the categorical variables
X_dummy <- model.matrix(~ state + censdiv + occ + race + year - 1, data = data_selected)

# Extract the continuous variables
X_cont <- data_selected[, cont_vars]

# Combine the continuous variables with the dummy variables
X <- cbind(X_cont, X_dummy)

# Define the response variable (assuming it's in the original data)
y <- data$gammaP_WEIGHTED

# Initialize the group vector
group <- rep(1, length(cont_vars))  # Group for continuous variables

# Get the names of the columns in X_dummy
dummy_colnames <- colnames(X_dummy)

# Define a function to assign group numbers based on the prefix of the column names
assign_group <- function(prefix, group_num) {
  group <<- c(group, rep(group_num, sum(startsWith(dummy_colnames, prefix))))
}

# Assign group numbers to the dummy variables
assign_group("state", 2)
assign_group("censdiv", 3)
assign_group("occ", 4)
assign_group("race", 5)
assign_group("year", 6)

# Convert X to a matrix
X <- as.matrix(X)


# Fit the group lasso model
fit <- gglasso(X, y, group = group)

plot(fit)


cv_fit <- cv.gglasso(X, y, group = group)

print(summary(cv_fit))
print(cv_fit)

plot(cv_fit)

coefs <- coef(fit)


# Specify the indices of the variables you want to plot
# Replace 'var1', 'var2', 'var3' with the actual variable names or indices
var_indices <- c(which(colnames(X) == "state0"), 
    which(colnames(X) == "state6"), 
    which(colnames(X) == "state12"),
    which(colnames(X) == "state24"), 
    which(colnames(X) == "state30"), 
    which(colnames(X) == "state38"),
    which(colnames(X) == "state40"),
    which(colnames(X) == "state50"))

# Extract the coefficients for the specified variables
coefs_selected <- coefs[var_indices, ]

# Plot the coefficients across values of lambda
matplot(fit$lambda, t(coefs_selected), type = "l", lty = 1, col = 1:3, xlab = "Lambda", ylab = "Coefficients", main = "Coefficients of Selected Variables Across Lambda")
legend("topright", legend = colnames(X)[var_indices], col = 1:3, lty = 1)





# Specify the indices of the variables you want to plot
# Replace 'var1', 'var2', 'var3' with the actual variable names or indices
var_indices <- c(which(colnames(X) == "censdiv0"), 
    which(colnames(X) == "censdiv1"), 
    which(colnames(X) == "censdiv2"),
    which(colnames(X) == "censdiv3"), 
    which(colnames(X) == "censdiv4"), 
    which(colnames(X) == "censdiv5"),
    which(colnames(X) == "censdiv6"),
    which(colnames(X) == "censdiv7"))

# Extract the coefficients for the specified variables
coefs_selected <- coefs[var_indices, ]

# Plot the coefficients across values of lambda
matplot(fit$lambda, t(coefs_selected), type = "l", lty = 1, col = 1:3, xlab = "Lambda", ylab = "Coefficients", main = "Coefficients of Selected Variables Across Lambda")
legend("topright", legend = colnames(X)[var_indices], col = 1:3, lty = 1)




# Specify the indices of the variables you want to plot
# Replace 'var1', 'var2', 'var3' with the actual variable names or indices
var_indices <- c(which(colnames(X) == "occ1"), 
    which(colnames(X) == "occ10"), 
    which(colnames(X) == "occ20"),
    which(colnames(X) == "occ25"), 
    which(colnames(X) == "occ30"), 
    which(colnames(X) == "occ40"),
    which(colnames(X) == "occ50"),
    which(colnames(X) == "occ60"))

# Extract the coefficients for the specified variables
coefs_selected <- coefs[var_indices, ]

# Plot the coefficients across values of lambda
matplot(fit$lambda, t(coefs_selected), type = "l", lty = 1, col = 1:3, xlab = "Lambda", ylab = "Coefficients", main = "Coefficients of Selected Variables Across Lambda")
legend("topright", legend = colnames(X)[var_indices], col = 1:3, lty = 1)





# Specify the indices of the variables you want to plot
# Replace 'var1', 'var2', 'var3' with the actual variable names or indices
var_indices <- c(which(colnames(X) == "race0"), 
    which(colnames(X) == "race1"), 
    which(colnames(X) == "race2"),
    which(colnames(X) == "race3"), 
    which(colnames(X) == "race4"), 
    which(colnames(X) == "race5"),
    which(colnames(X) == "race6"),
    which(colnames(X) == "race12"))

# Extract the coefficients for the specified variables
coefs_selected <- coefs[var_indices, ]

# Plot the coefficients across values of lambda
matplot(fit$lambda, t(coefs_selected), type = "l", lty = 1, col = 1:3, xlab = "Lambda", ylab = "Coefficients", main = "Coefficients of Selected Variables Across Lambda")
legend("topright", legend = colnames(X)[var_indices], col = 1:3, lty = 1)






best_coefs <- coef(cv_fit, s = "lambda.min")
print(best_coefs)

best_coefs_1se <- coef(cv_fit, s = "lambda.1se")
print(best_coefs_1se)



