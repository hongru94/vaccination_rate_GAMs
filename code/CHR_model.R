library(mgcv)
library(gratia)
library(tidyr)
library(ggpubr)
library(dplyr)
library(mgcViz)


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
df <- read.csv(paste(data_file, 'CHR_input.csv', sep = ""))
df <-df[!is.na(df$RCHR),]
df <- df[!df$FIPS %in% c(33, 54),]
df_all <- df[df$Week_Mon>='2021-04-19',]



################################################################################
##### Fit to others wave
################################################################################
df_others <- df_all[df_all$Dominant_variant == "Others",]
df_others<-df_others[!is.na(df_others$RCHR),]
df_others <- remove_outlier(df_others, c("RCHR"))

k_value <- 3
bs = 'tp'
mod_others <- gam(RCHR ~ s(RCPSR_lag2, k = k_value, bs=bs) + 
                    s(RPI_12_Weeks_lag4, k = k_value, bs=bs) + 
                    #s(RFSRV_lag2, k = k_value, bs=bs) +
                    #s(RGSV_lag2, k = k_value, bs=bs) +
                    #s(RROV_lag2, k = k_value, bs=bs) + 
                    s(RGV_lag2, k = k_value, bs=bs) +
                    s(RUV_lag2, k = k_value, bs=bs) + 
                    s(ROPV_lag2, k =k_value, bs=bs) +
                    s(RWTR_lag2, k = k_value, bs=bs) + 
                    s(RGP_lag2, k = k_value, bs=bs) + 
                    Adults_at_high_risk + SVI + Black + medicaid_spending, 
                  data = df_others,
                  family = Gamma(link = 'log'), method = "REML", select = TRUE)

summary(mod_others)
concurvity(mod_others)
plot(mod_others, page = 1, scheme = 2)
par(mfrow=c(2,2))
gam.check(mod_others,rep = 100, page = 1)
cor.test(df_others$RCHR, exp(predict.gam(mod_others)))

####Accumulated local effects
df_ALE_others <- data.frame()
for (x in c('RCPSR_lag2', 'RPI_12_Weeks_lag4', 'RGV_lag2',
            'RUV_lag2', 'ROPV_lag2', 'RWTR_lag2', 'RGP_lag2')) {
  ALE <- ALE(mod_others, x, type = "response", oind = 1)$ALE$ALE
  ALE[, 'model' ] = "mod_others"
  ALE[, 'Var' ] = x
  names(ALE)[names(ALE) == "x"] <- 'var'
  names(ALE)[names(ALE) == "y"] <- 'est'
  df_ALE_others <- rbind(df_ALE_others, ALE)
}
write.csv(df_ALE_others, paste(results_file, 'Pre-Delta_ALE_CHR.csv', sep = ""))


################################################################################
##### Fit to Delta wave
################################################################################
df_delta <- df_all[df_all$Dominant_variant == "Delta",]
df_delta<-df_delta[!is.na(df_delta$RCHR),]
df_delta <- remove_outlier(df_delta, c("RCHR"))

k_value <- 3
bs='tp'
mod_delta <- gam(RCHR ~ s(RCPSR_lag2, k = k_value, bs=bs) + 
                   s(RPI_12_Weeks_lag4, k = k_value, bs=bs) + 
                   #s(RFSRV_lag2, k = k_value, bs=bs) +
                   #s(RGSV_lag2, k = k_value, bs=bs) +
                   #s(RROV_lag2, k = k_value, bs=bs) + 
                   s(RGV_lag2, k = k_value, bs=bs) +
                   s(RUV_lag2, k = k_value, bs=bs) + 
                   s(ROPV_lag2, k = k_value, bs=bs) +
                   s(RWTR_lag2, k = k_value, bs=bs) + 
                   s(RGP_lag2, k = k_value, bs=bs) + 
                   Adults_at_high_risk + SVI + Black + medicaid_spending,
                 data = df_delta,
                 family = Gamma(link = 'log'), method = "REML", select = 'TRUE')
summary(mod_delta)
plot(mod_delta, page = 1)
concurvity(mod_delta)
par(mfrow=c(2,2))
gam.check(mod_delta,rep = 100, page = 1)
cor.test(df_delta$RCHR, exp(predict.gam(mod_delta)))
####Accumulated local effects
df_ALE_delta <- data.frame()
for (x in c('RCPSR_lag2', 'RPI_12_Weeks_lag4', 'RGV_lag2',
            'RUV_lag2', 'ROPV_lag2', 'RWTR_lag2', 'RGP_lag2')) {
  ALE <- ALE(mod_delta, x, type = "response", oind = 1)$ALE$ALE
  ALE[, 'model' ] = "mod_delta"
  ALE[, 'Var' ] = x
  names(ALE)[names(ALE) == "x"] <- 'var'
  names(ALE)[names(ALE) == "y"] <- 'est'
  df_ALE_delta <- rbind(df_ALE_delta, ALE)
}
write.csv(df_ALE_delta, paste(results_file, 'Delta_ALE_CHR.csv', sep = ""))

################################################################################
##### Fit to Omicron wave
################################################################################
df_omicron <- df_all[df_all$Dominant_variant == "Omicron",]
df_omicron <- df_omicron[!df_omicron$FIPS %in% c(33, 37, 54),]
df_omicron<-df_omicron[!is.na(df_omicron$RCHR),]
df_omicron <- remove_outlier(df_omicron, c("RCHR"))

k_value <- 3
bs = 'tp'
mod_omicron <- gam(RCHR ~ s(RCPSR_lag2, k = k_value, bs=bs) + 
                     s(RPI_12_Weeks_lag4, k = k_value, bs=bs) + 
                     #s(RFSRV_lag2, k = k_value, bs=bs) +
                     #s(RGSV_lag2, k = k_value, bs=bs) +
                     #s(RROV_lag2, k = k_value, bs=bs) + 
                     s(RGV_lag2, k = k_value, bs=bs) +
                     s(RUV_lag2, k = k_value, bs=bs) + 
                     s(ROPV_lag2, k = k_value, bs=bs) +
                     s(RWTR_lag2, k = k_value, bs=bs) + 
                     s(RGP_lag2, k = k_value, bs=bs) + 
                     Adults_at_high_risk + SVI + Black + medicaid_spending,
                   data = df_omicron,
                   family = Gamma(link = 'log'), method = "REML", select = 'TRUE')

summary(mod_omicron)
plot(mod_omicron, page = 1, scheme = 2)
concurvity(mod_omicron)
gam.check(mod_omicron,rep = 100, page = 1)
cor.test(df_omicron$RCHR, exp(predict.gam(mod_omicron)))

####Accumulated local effects
df_ALE_omicron <- data.frame()
for (x in c('RCPSR_lag2', 'RPI_12_Weeks_lag4', 'RGV_lag2',
            'RUV_lag2', 'ROPV_lag2', 'RWTR_lag2', 'RGP_lag2')) {
  ALE <- ALE(mod_omicron, x, type = "response", oind = 1)$ALE$ALE
  ALE[, 'model' ] = "mod_omicron"
  ALE[, 'Var' ] = x
  names(ALE)[names(ALE) == "x"] <- 'var'
  names(ALE)[names(ALE) == "y"] <- 'est'
  df_ALE_omicron <- rbind(df_ALE_omicron, ALE)
}
write.csv(df_ALE_omicron, paste(results_file, 'Omicron_ALE_CHR.csv', sep = ""))

################################################################################
##### Fit to Omicron wave with interaction
################################################################################
k_value <- 3
bs = 'tp'
mod_omicron_2 <- gam(RCHR ~ s(RCPSR_lag2, RBVR_lag2, k = 4) + 
                       s(RPI_12_Weeks_lag4, k = k_value, bs=bs) + 
                       #s(RFSRV_lag2, k = k_value, bs=bs) +
                       #s(RGSV_lag2, k = k_value, bs=bs) +
                       #s(RROV_lag2, k = k_value, bs=bs) + 
                       s(RGV_lag2, k = k_value, bs=bs) +
                       s(RUV_lag2, k = k_value, bs=bs) + 
                       s(ROPV_lag2, k = k_value, bs=bs) +
                       s(RWTR_lag2, k = k_value, bs=bs) + 
                       s(RGP_lag2, k = k_value, bs=bs) + 
                       Adults_at_high_risk + SVI + Black+ medicaid_spending, 
                     data = df_omicron,
                     family = Gamma(link = 'log'), method = "REML", select = 'TRUE')

summary(mod_omicron_2)
cor.test(df_omicron$RCHR, exp(predict.gam(mod_omicron_2)))
####Accumulated local effects
df_ALE_omicron_2 <- data.frame()
for (x in c('RCPSR_lag2', 'RPI_12_Weeks_lag4', 'RGV_lag2',
            'RUV_lag2', 'ROPV_lag2', 'RWTR_lag2', 'RGP_lag2')) {
  ALE <- ALE(mod_omicron_2, x, type = "response", oind = 1)$ALE$ALE
  ALE[, 'model' ] = "mod_omicron"
  ALE[, 'Var' ] = x
  names(ALE)[names(ALE) == "x"] <- 'var'
  names(ALE)[names(ALE) == "y"] <- 'est'
  df_ALE_omicron_2 <- rbind(df_ALE_omicron_2, ALE)
}
write.csv(df_ALE_omicron_2, paste(results_file, 'Omicron_interacrion_ALE_CHR.csv', sep = ""))

### Save partial dependent plots
plot_data <- plot(mod_omicron_2, page = 1, scheme = 2)
concurvity(mod_omicron_2)
gam.check(mod_omicron_2,rep = 100, page = 1)

x1 <- plot_data[[1]]$x
x2 <- plot_data[[1]]$y
fit <- plot_data[[1]]$fit
se <- plot_data[[1]]$se

write.table(x1, file=paste(results_file, 'interaction_x1_CHR.tsv', sep = ""), quote=FALSE, sep=',', col.names = NA)
write.table(x2, file=paste(results_file, 'interaction_x2_CHR.tsv', sep = ""), quote=FALSE, sep=',', col.names = NA)
write.table(fit, file=paste(results_file, 'interaction_fit_CHR.tsv', sep = ""), quote=FALSE, sep=',', col.names = NA)

comp <- compare_smooths(mod_omicron_2, mod_omicron_2)
rest <- unnest(comp,data)
write.csv(rest, paste(results_file, 'Omicron_interaction_PE_CHR.csv', sep = ""))

