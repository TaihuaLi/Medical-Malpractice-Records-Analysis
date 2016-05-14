dat <- # read in file
variables <- c("licnstat", "licnfeld",
               "practage", "grad", "algnnatr", "alegatn1", "alegatn2",
               "outcome", "totalpmt",
               "paytype", "ptage", "ptgender",
               "pttype")
new_dat <- subset(dat, rectype == 'M' | rectype == 'P', select=variables)
new_dat <- subset(new_dat, licnfeld == 10 | licnfeld == 15 | licnfeld == 20 | licnfeld == 25) # doctors only
new_dat <- na.omit(new_dat) # retrieve complete records
new_dat <- new_dat[new_dat$ptgender != "U" & new_dat$pttype != "U", ] # omit unknown gender & patient type
new_dat <- new_dat[new_dat$alegatn1 != 899 & new_dat$alegatn1 != 999, ] # omit unclassified allegation
new_dat <- new_dat[new_dat$alegatn2 != 899 & new_dat$alegatn2 != 999, ]
new_dat <- new_dat[new_dat$licnstat != " ",] # omit blank category for state
new_dat <- new_dat[new_dat$paytype == "S", ] # only keep payment that is result of settlement
new_dat <- new_dat[new_dat$pttype == "I" | new_dat$pttype == "O", ] # omit both type patients (both in and out)

# practitioner age group
practAge <- new_dat$practage
practAge[practAge==10] <- 10
practAge[practAge==20] <- 25
practAge[practAge==30] <- 35
practAge[practAge==40] <- 45
practAge[practAge==50] <- 55
practAge[practAge==60] <- 65
practAge[practAge==70] <- 75
practAge[practAge==80] <- 85
practAge[practAge==90] <- 95
practAge <- as.numeric(practAge)
new_dat$practage <- practAge

# patient age group
new_dat <- new_dat[new_dat$ptage != -1, ] # no fetus
ptAge <- new_dat$ptage
ptAge[ptAge==0] <- 0
ptAge[ptAge==1] <- 5
ptAge[ptAge==10] <- 15
ptAge[ptAge==20] <- 25
ptAge[ptAge==30] <- 35
ptAge[ptAge==40] <- 45
ptAge[ptAge==50] <- 55
ptAge[ptAge==60] <- 65
ptAge[ptAge==70] <- 75
ptAge[ptAge==80] <- 85
ptAge[ptAge==90] <- 95
ptAge <- as.numeric(ptAge)
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
new_dat <- new_dat[new_dat$algnnatr == 1, ] # only diagnosis_related

alg <- new_dat$algnnatr
alg[alg==1] <- "Diagnosis_Related"
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

new_dat <- new_dat[new_dat$licnstat == "WA" | new_dat$licnstat == "OR" | new_dat$licnstat == "CA" | new_dat$licnstat == "HI" | 
                     new_dat$licnstat == "AK" | new_dat$licnstat == "ME" | new_dat$licnstat == "VT" | new_dat$licnstat == "NH" |
                     new_dat$licnstat == "MA" | new_dat$licnstat == "CT" | new_dat$licnstat == "RI" | new_dat$licnstat == "NY" |
                     new_dat$licnstat == "PA" | new_dat$licnstat == "NJ" | new_dat$licnstat == "DE", ] # only region 1 & 5

state <- as.character(new_dat$licnstat)
for (i in c("WA", "OR", "CA", "HI", "AK")) {
  state[state == i] <- "region.1"
}
for (i in c("ME", "VT", "NH", "MA", "CT", "RI", "NY", "PA", "NJ", "DE")) {
  state[state == i] <- "region.5"
}
state <- as.factor(state)
new_dat$licnstat <- state


# licnfeld: license field
fi <- new_dat$licnfeld
fi[fi == 10] <- "Doctor"
fi[fi == 15] <- "Doctor"
fi[fi == 20] <- "Doctor"
fi[fi == 25] <- "Doctor"
fi <- as.factor(fi)
new_dat$licnfeld <- fi

# convert all into dummies except alegatn1, alegatn2
# install.packages("dummies")
library(dummies)
d <- dummy.data.frame(new_dat)
head(d)

write.table(d, file="to_use.csv", sep=",", row.names = F)

# categorical: alegatn1, alegatn2
