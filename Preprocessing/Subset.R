dat <- # read in file
variables <- c("licnstat", "licnfeld",
               "practage", "grad", "algnnatr", "alegatn1", "alegatn2",
               "outcome", "payment", "totalpmt",
               "paynumbr", "numbprsn", "paytype", "ptage", "ptgender",
               "pttype")
new_dat <- subset(dat, rectype == 'M' | rectype == 'P', select=variables)
new_dat <- subset(new_dat, licnfeld == 10 | licnfeld == 15 | licnfeld == 20 | licnfeld == 25) # doctors only
new_dat <- na.omit(new_dat) # retrieve complete records
new_dat <- new_dat[new_dat$ptgender != "U" & new_dat$pttype != "U", ] # omit unknown gender & patient type
new_dat <- new_dat[new_dat$alegatn1 != 899 & new_dat$alegatn1 != 999, ] # omit unclassified allegation
new_dat <- new_dat[new_dat$alegatn2 != 899 & new_dat$alegatn2 != 999, ]
new_dat <- new_dat[new_dat$licnstat != " ",] # omit blank category for state
new_dat <- new_dat[new_dat$paytype == "S", ] # only keep payment that is result of settlement

# practitioner age group
practAge <- new_dat$practage
practAge[practAge==10] <- "Age_19_under"
practAge[practAge==20] <- "Age_20_29"
practAge[practAge==30] <- "Age_30_39"
practAge[practAge==40] <- "Age_40_49"
practAge[practAge==50] <- "Age_50_59"
practAge[practAge==60] <- "Age_60_69"
practAge[practAge==70] <- "Age_70_79"
practAge[practAge==80] <- "Age_80_89"
practAge[practAge==90] <- "Age_90_99"
practAge <- as.factor(practAge)
new_dat$practage <- practAge

# patient age group
ptAge <- new_dat$ptage
ptAge[ptAge==-1] <- "Fetus"
ptAge[ptAge==0] <- "Age_1_under"
ptAge[ptAge==1] <- "Age_1_9"
ptAge[ptAge==10] <- "Age_10_19"
ptAge[ptAge==20] <- "Age_20_29"
ptAge[ptAge==30] <- "Age_30_39"
ptAge[ptAge==40] <- "Age_40_49"
ptAge[ptAge==50] <- "Age_50_59"
ptAge[ptAge==60] <- "Age_60_69"
ptAge[ptAge==70] <- "Age_70_79"
ptAge[ptAge==80] <- "Age_80_89"
ptAge[ptAge==90] <- "Age_90_99"
ptAge <- as.factor(ptAge)
new_dat$ptage <- ptAge

# outcome (omit 10: cannot be determined injury)
outcome <- new_dat$outcome
outcome[outcome==1] <- "Emotional_Injury_Only"
outcome[outcome==2] <- "Insignificant_Injury"
outcome[outcome==3] <- "Minor_Temporary_Injury"
outcome[outcome==4] <- "Major_Temporary_Injury"
outcome[outcome==5] <- "Minor_Permanent_Injury"
outcome[outcome==6] <- "Significant_Permanent_Injury"
outcome[outcome==7] <- "Major_Permanent_Injury"
outcome[outcome==8] <- "Lifelong_Care"
outcome[outcome==9] <- "Death"
outcome <- as.factor(outcome)
new_dat$outcome <- outcome
new_dat <- new_dat[new_dat$outcome != 10, ]

# algnnatr: Malpractice Allegation Group
alg <- new_dat$algnnatr
alg[alg==1] <- "Diagnosis_Related"
alg[alg==10] <- "Anesthesia_Related"
alg[alg==20] <- "Surgery_Related"
alg[alg==30] <- "Medication_Related"
alg[alg==40] <- "IV_&_Blood_Products_Related"
alg[alg==50] <- "Obstetrics_Related"
alg[alg==60] <- "Treatment_Related"
alg[alg==70] <- "Monitoring_Related"
alg[alg==80] <- "Equipment/Product_Related"
alg[alg==90] <- "Other_Miscellaneous"
alg[alg==100] <- "Behavioral_Health_Related"
alg <- as.factor(alg)
new_dat$algnnatr <- alg

# regions
region.1 <- c("WA", "OR", "CA", "HI", "AK")
region.2 <- c("MT", "ID", "WY", "NV", "UT", "CO", "AZ", "NM")
region.3 <- c("ND", "MN", "SD", "IA", "NE", "KS", "MO", "WI", "MI", "IL", "IN", "OH")
region.4 <- c("TX", "OK", "AR", "LA", "MS", "AL", "TN", "KY")
region.5 <- c("ME", "VT", "NH", "MA", "CT", "RI", "NY", "PA", "NJ", "DE")
region.6 <- c("MD", "WV", "VA", "NC", "SC", "GA", "FL")
all.region <- c(region.1, region.2, region.3, region.4, region.5, region.6)

state <- as.character(new_dat$licnstat)
for (i in c("WA", "OR", "CA", "HI", "AK")) {
  state[state == i] <- "region.1"
}

for (i in c("MT", "ID", "WY", "NV", "UT", "CO", "AZ", "NM")) {
  state[state == i] <- "region.2"
}

for (i in c("ND", "MN", "SD", "IA", "NE", "KS", "MO", "WI", "MI", "IL", "IN", "OH")) {
  state[state == i] <- "region.3"
}

for (i in c("TX", "OK", "AR", "LA", "MS", "AL", "TN", "KY")) {
  state[state == i] <- "region.4"
}

for (i in c("ME", "VT", "NH", "MA", "CT", "RI", "NY", "PA", "NJ", "DE")) {
  state[state == i] <- "region.5"
}

for (i in c("MD", "WV", "VA", "NC", "SC", "GA", "FL")) {
  state[state == i] <- "region.6"
}

state <- as.factor(state)
new_dat$licnstat <- state
new_dat <- new_dat[new_dat$licnstat != "DC" & new_dat$licnstat != "PR", ]

# licnfeld: license field
fi <- new_dat$licnfeld
fi[fi == 10] <- "Allopathic_Physician_(MD)"
fi[fi == 15] <- "Physician_Resident_(MD)"
fi[fi == 20] <- "Osteopathic_Physician_(DO)"
fi[fi == 25] <- "Osteopathic_Physician_Resident_(DO)"
fi <- as.factor(fi)
new_dat$licnfeld <- fi

# convert all into dummies except alegatn1, alegatn2
# install.packages("dummies")
library(dummies)
d <- dummy.data.frame(new_dat)
head(d)

write.table(d, file="to_use.csv", sep=",", row.names = F)

# categorical: alegatn1, alegatn2
