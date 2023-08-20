library(mgcv)
library(gratia)
library(tidyr)
# create detect outlier function
detect_outlier <- function(x) {
  
  # calculate first quantile
  Quantile1 <- quantile(x, probs=.25)
  
  # calculate third quantile
  Quantile3 <- quantile(x, probs=.75)
  
  # calculate inter quartile range
  IQR = Quantile3-Quantile1
  
  # return true or false
  x > Quantile3 + (IQR*1.5) | x < Quantile1 - (IQR*1.5)
}

# create remove outlier function
remove_outlier <- function(dataframe,
                           columns=names(dataframe)) {
  
  # for loop to traverse in columns vector
  for (col in columns) {
    
    # remove observation if it satisfies outlier function
    dataframe <- dataframe[!detect_outlier(dataframe[[col]]), ]
  }
  # return dataframe
  print("Remove outliers")
  print(dataframe)
}

data_file = "/Users/hongrudu/Desktop/COVID_Vaccination_rate/data/processed_data/"
results_file = "/Users/hongrudu/Desktop/COVID_Vaccination_rate/results/"
df <- read.csv(paste(data_file, 'CHR_RP_lag_range.csv', sep = ""))
df <-df[!is.na(df$RCHR),]
df <- df[!df$FIPS %in% c(33, 54),]
df_all <- df[df$Week_Mon>='2021-04-19',]

df_others <- df_all[df_all$Dominant_variant == "Others",]
df_others<-df_others[!is.na(df_others$RCHR),]
df_others <- remove_outlier(df_others, c("RCHR"))

k_value <- 3
bs = 'tp'
################################################
#####Check range
df_ALE_others <- data.frame()
for (x in c('RPI_12_Weeks_lag4', 'RPI_16_Weeks_lag4',
            'RPI_20_Weeks_lag4', 'RPI_24_Weeks_lag4')) {
  mod_others <- gam(RCHR ~ s(RCPSR_lag2, k = k_value, bs=bs) + 
                      s(get(x), k = k_value, bs=bs) + 
                      s(RGV_lag2, k = k_value, bs=bs) +
                      s(RUV_lag2, k = k_value, bs=bs) + 
                      s(ROPV_lag2, k = k_value, bs=bs) +
                      s(RWTR_lag2, k = k_value, bs=bs) + 
                      s(RGP_lag2, k = k_value, bs=bs) + 
                      Adults_at_high_risk + SVI + Black + medicaid_spending, 
                    data = df_others,
                    family = Gamma(link = 'log'), method = "REML", select = TRUE)
  ALE <- ALE(mod_others, 'get(x)', type = "response", oind = 1)$ALE$ALE
  ALE[, 'model' ] = "mod_others"
  ALE[, 'Var' ] = x
  names(ALE)[names(ALE) == "x"] <- 'var'
  names(ALE)[names(ALE) == "y"] <- 'est'
  df_ALE_others <- rbind(df_ALE_others, ALE)
}

write.csv(df_ALE_others, paste(results_file, 'Pre-Delta_PI_range.csv', sep = ""))

################################################
#####Check lag
df_ALE_others <- data.frame()
for (x in c('RPI_12_Weeks_lag4', 'RPI_12_Weeks_lag8',
            'RPI_12_Weeks_lag12', 'RPI_12_Weeks_lag16')) {
  mod_others <- gam(RCHR ~ s(RCPSR_lag2, k = k_value, bs=bs) + 
                      s(get(x), k = k_value, bs=bs) + 
                      s(RGV_lag2, k = k_value, bs=bs) +
                      s(RUV_lag2, k = k_value, bs=bs) + 
                      s(ROPV_lag2, k = k_value, bs=bs) +
                      s(RWTR_lag2, k = k_value, bs=bs) + 
                      s(RGP_lag2, k = k_value, bs=bs) + 
                      Adults_at_high_risk + SVI + Black + medicaid_spending, 
                    data = df_others,
                    family = Gamma(link = 'log'), method = "REML", select = TRUE)
  ALE <- ALE(mod_others, 'get(x)', type = "response", oind = 1)$ALE$ALE
  ALE[, 'model' ] = "mod_others"
  ALE[, 'Var' ] = x
  names(ALE)[names(ALE) == "x"] <- 'var'
  names(ALE)[names(ALE) == "y"] <- 'est'
  df_ALE_others <- rbind(df_ALE_others, ALE)
}

write.csv(df_ALE_others, paste(results_file, 'Pre-Delta_PI_lag.csv', sep = ""))

################################################################################
##### Fit to Delta wave
################################################################################
df_delta <- df_all[df_all$Dominant_variant == "Delta",]
df_delta<-df_delta[!is.na(df_delta$RCHR),]
df_delta <- remove_outlier(df_delta, c("RCHR"))

k_value <- 3
bs='tp'

################################################
#####Check range
df_ALE_delta <- data.frame()
for (x in c('RPI_12_Weeks_lag4', 'RPI_16_Weeks_lag4',
            'RPI_20_Weeks_lag4', 'RPI_24_Weeks_lag4')) {
  mod_delta <- gam(RCHR ~ s(RCPSR_lag2, k = k_value, bs=bs) + 
                     s(get(x), k = k_value, bs=bs) + 
                     s(RGV_lag2, k = k_value, bs=bs) +
                     s(RUV_lag2, k = k_value, bs=bs) + 
                     s(ROPV_lag2, k = k_value, bs=bs) +
                     s(RWTR_lag2, k = k_value, bs=bs) + 
                     s(RGP_lag2, k = k_value, bs=bs) + 
                     Adults_at_high_risk + SVI + Black + medicaid_spending, 
                   data = df_delta,
                   family = Gamma(link = 'log'), method = "REML", select = TRUE)
  ALE <- ALE(mod_delta, 'get(x)', type = "response", oind = 1)$ALE$ALE
  ALE[, 'model' ] = "mod_delta"
  ALE[, 'Var' ] = x
  names(ALE)[names(ALE) == "x"] <- 'var'
  names(ALE)[names(ALE) == "y"] <- 'est'
  df_ALE_delta <- rbind(df_ALE_delta, ALE)
}

write.csv(df_ALE_delta, paste(results_file, 'Delta_PI_range.csv', sep = ""))

################################################
#####Check lag
df_ALE_delta <- data.frame()
for (x in c('RPI_12_Weeks_lag4', 'RPI_12_Weeks_lag8',
            'RPI_12_Weeks_lag12', "RPI_12_Weeks_lag16")) {
  mod_delta <- gam(RCHR ~ s(RCPSR_lag2, k = k_value, bs=bs) + 
                     s(get(x), k = k_value, bs=bs) + 
                     s(RGV_lag2, k = k_value, bs=bs) +
                     s(RUV_lag2, k = k_value, bs=bs) + 
                     s(ROPV_lag2, k = k_value, bs=bs) +
                     s(RWTR_lag2, k = k_value, bs=bs) + 
                     s(RGP_lag2, k = k_value, bs=bs) + 
                     Adults_at_high_risk + SVI + Black + medicaid_spending, 
                   data = df_delta,
                   family = Gamma(link = 'log'), method = "REML", select = TRUE)
  ALE <- ALE(mod_delta, 'get(x)', type = "response", oind = 1)$ALE$ALE
  ALE[, 'model' ] = "mod_delta"
  ALE[, 'Var' ] = x
  names(ALE)[names(ALE) == "x"] <- 'var'
  names(ALE)[names(ALE) == "y"] <- 'est'
  df_ALE_delta <- rbind(df_ALE_delta, ALE)
}

write.csv(df_ALE_delta, paste(results_file, 'Delta_PI_lag.csv', sep = ""))

################################################################################
##### Fit to Omicron wave
################################################################################
df_omicron <- df_all[df_all$Dominant_variant == "Omicron",]
df_omicron <- df_omicron[!df_omicron$FIPS %in% c(33, 37, 54),]
df_omicron<-df_omicron[!is.na(df_omicron$RCHR),]
df_omicron <- remove_outlier(df_omicron, c("RCHR"))

k_value <- 3
bs = 'tp'

df_ALE_omicron <- data.frame()
for (x in c('RPI_12_Weeks_lag4', 'RPI_16_Weeks_lag4',
            'RPI_20_Weeks_lag4', 'RPI_24_Weeks_lag4')) {
  mod_omicron <- gam(RCHR ~ s(RCPSR_lag2, k = k_value, bs=bs) + 
                       s(get(x), k = k_value, bs=bs) + 
                       s(RGV_lag2, k = k_value, bs=bs) +
                       s(RUV_lag2, k = k_value, bs=bs) + 
                       s(ROPV_lag2, k = k_value, bs=bs) +
                       s(RWTR_lag2, k = k_value, bs=bs) + 
                       s(RGP_lag2, k = k_value, bs=bs) + 
                       Adults_at_high_risk + SVI + Black + medicaid_spending, 
                     data = df_omicron,
                     family = Gamma(link = 'log'), method = "REML", select = TRUE)
  ALE <- ALE(mod_omicron, 'get(x)', type = "response", oind = 1)$ALE$ALE
  ALE[, 'model' ] = "mod_omicron"
  ALE[, 'Var' ] = x
  names(ALE)[names(ALE) == "x"] <- 'var'
  names(ALE)[names(ALE) == "y"] <- 'est'
  df_ALE_omicron <- rbind(df_ALE_omicron, ALE)
}

write.csv(df_ALE_omicron, paste(results_file, 'Omicron_PI_range.csv', sep = ""))

################################################
#####Check lag
df_ALE_omicron <- data.frame()
for (x in c('RPI_12_Weeks_lag4', 'RPI_12_Weeks_lag8',
            'RPI_12_Weeks_lag12', 'RPI_12_Weeks_lag16')) {
  mod_omicron <- gam(RCHR ~ s(RCPSR_lag2, k = k_value, bs=bs) + 
                       s(get(x), k = k_value, bs=bs) + 
                       s(RGV_lag2, k = k_value, bs=bs) +
                       s(RUV_lag2, k = k_value, bs=bs) + 
                       s(ROPV_lag2, k = k_value, bs=bs) +
                       s(RWTR_lag2, k = k_value, bs=bs) + 
                       s(RGP_lag2, k = k_value, bs=bs) + 
                       Adults_at_high_risk + SVI + Black + medicaid_spending, 
                     data = df_omicron,
                     family = Gamma(link = 'log'), method = "REML", select = TRUE)
  ALE <- ALE(mod_omicron, 'get(x)', type = "response", oind = 1)$ALE$ALE
  ALE[, 'model' ] = "mod_omicron"
  ALE[, 'Var' ] = x
  names(ALE)[names(ALE) == "x"] <- 'var'
  names(ALE)[names(ALE) == "y"] <- 'est'
  df_ALE_omicron <- rbind(df_ALE_omicron, ALE)
}

write.csv(df_ALE_omicron, paste(results_file, 'Omicron_PI_lag.csv', sep = ""))
