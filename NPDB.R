###################################################################
# CSC 424 - 2015/16 Spring
#
# Project Team:  Taihua (Ray) Li, Trish Lugtu, Mike Marre, Zengyi Zhu
# NPDB Public Use Data File
# Source: http://www.npdb.hrsa.gov/resources/publicData.jsp 
#
###################################################################
setwd("R:/Project/Code")

# LOAD LIBRARIES
library(foreign)
library(stringr)

# LOAD DATA (.POR file)
NPDB.full <- read.spss("NPDB1510.POR", to.data.frame = TRUE)
names(NPDB.full) <- str_to_lower(names(NPDB.full))

# field list:  seqno, rectype, reptype, origyear, workstat, workctry, homestat, homectry, licnstat, licnfeld, practage, grad, algnnatr, alegatn1, alegatn2, outcome, malyear1, malyear2, payment, totalpmt, paynumbr, numbprsn, paytype, pyrrltns, ptage, ptgender, pttype, aayear, aaclass1, aaclass2, aaclass3, aaclass4, aaclass5, basiscd1, basiscd2, basiscd3, basiscd4, basiscd5, aalentyp, aalength, aaefyear, aasigyr, type, practnum, accrrpts, npmalrpt, nplicrpt, npclprpt, nppsmrpt, npdearpt, npexcrpt, npgarpt, npctmrpt, fundpymt

# EXPLORE DATA
head(NPDB.full, n=10)
summary(NPDB.full)
sort(summary(NPDB.full$rectype))

# How many of each rectype?
#  Judgment or Conviction Report, 11/22/1999 and later      = 0                   
#  Adverse Action Report (Legacy Format)                    = 51301 
#  Malpractice Payment Report, 1/31/04 and later            = 167027    (INCLUDE)      
#  Malpractice Payment Report, 9/1/90 to 1/31/04            = 250685    
#  Consolidated Adverse Action Report, 11/22/1999 and later = 729253 

# Explore adverse action reports
NPDB.AAR <- subset(NPDB.full, NPDB.full$RECTYPE %in% c("Adverse Action Report (Legacy Format)","Consolidated Adverse Action Report, 11/22/1999 and later"))
summary(NPDB.AAR)

# Explore all malpractice payment reports 
NPDB.MP <- subset(NPDB.full, NPDB.full$rectype %in% c("Malpractice Payment Report, 9/1/90 to 1/31/04","Malpractice Payment Report, 1/31/04 and later"))
summary(NPDB.MP)

# Explore all malpractice payment reports < 2004 
NPDB.MPold <- subset(NPDB.full, NPDB.full$rectype == "Malpractice Payment Report, 9/1/90 to 1/31/04")
summary(NPDB.MPold)

# Explore all malpractice payment reports > 1/31/2004
NPDB.MPnew <- subset(NPDB.full, NPDB.full$rectype == "Malpractice Payment Report, 1/31/04 and later")
summary(NPDB.MPnew)

# CLEANUP UNUSED DATASETS
remove(NPDB.full)
remove(NPDB.AAR)
remove(NPDB.MPold)

# Physicians only
NPDB.MPnew.MDs <- subset(NPDB.MPnew, NPDB.MPnew$licnfeld %in% c("Allopathic Physician (MD)","Physician Resident (MD)","Osteopathic Physician (DO)","Osteopathic Physician Resident (DO)"))
summary(NPDB.MPnew.MDs)

sort(summary(NPDB.MPnew.MDs$licnfeld))
# Doctors (MD, DO)
#  Allopathic Physician (MD)           = 119,501 
#  Physician Resident (MD)             = 825
#  Osteopathic Physician (DO)          = 9,092
#  Osteopathic Physician Resident (DO) = 135

# Diagnosis Related only

NPDB.Dx <- subset(NPDB.MPnew.MDs, NPDB.MPnew.MDs$algnnatr == "Diagnosis Related")
summary(NPDB.Dx)

### Data transformations ###

# remove unknowns
NPDB.Dx <- NPDB.Dx[!is.na(NPDB.Dx$practage),] 
NPDB.Dx <- NPDB.Dx[!is.na(NPDB.Dx$malyear1),] 
NPDB.Dx <- NPDB.Dx[!is.na(NPDB.Dx$grad),] 
NPDB.Dx <- NPDB.Dx[!is.na(NPDB.Dx$ptage),] 
NPDB.Dx <- NPDB.Dx[NPDB.Dx$ptage != "fetus",] 
NPDB.Dx <- NPDB.Dx[!is.na(NPDB.Dx$ptgender),] 
NPDB.Dx <- NPDB.Dx[NPDB.Dx$ptgender != "U",]
NPDB.Dx <- NPDB.Dx[!is.na(NPDB.Dx$pttype),] 
NPDB.Dx <- NPDB.Dx[NPDB.Dx$pttype != "U",]
NPDB.Dx <- NPDB.Dx[!is.na(NPDB.Dx$outcome),]
NPDB.Dx <- NPDB.Dx[!is.na(NPDB.Dx$totalpmt),]
NPDB.Dx <- NPDB.Dx[as.character(NPDB.Dx$outcome) != "Cannot Be Determined from Available Records",]
summary(NPDB.Dx)

# totalPayment - use totalpmt bin mean as value
unique(NPDB.Dx$totalpmt)
NPDB.Dx$strTotPmt = as.character(NPDB.Dx$totalpmt)

tpstr1 = substr((NPDB.Dx$strTotPmt), 2, str_locate(NPDB.Dx$strTotPmt, " ")[,1]-1)
tpnum1 = as.numeric(str_replace(tpstr1, ",", ""))

tpstr2 = substr((NPDB.Dx$strTotPmt), str_locate(NPDB.Dx$strTotPmt, " ")+10, str_length(NPDB.Dx$strTotPmt))
tpnum2 = as.numeric(str_replace(tpstr2, ",", ""))

NPDB.Dx$totalPayment = round((tpnum1 + tpnum2)/2, digits=0)
NPDB.Dx <- NPDB.Dx[!is.na(NPDB.Dx$totalPayment),]


# MDage (new variable) - use practage bin mean as value 
sort(summary(NPDB.Dx$practage))
NPDB.Dx$MDage = as.numeric(substr(as.character(NPDB.Dx$practage),6,7)) + 5
summary(NPDB.Dx$MDage)

# MDexp (new variable) - malyear1 - (use grad bin min) 
NPDB.Dx$MDexp <- NPDB.Dx$malyear1 - (as.numeric(substr(as.character(NPDB.Dx$grad),1,4)))
summary(NPDB.Dx$MDexp)

# outcome - outcomes are an ordered list representing harm scale, we can use as numerical values
summary(NPDB.Dx$outcome)
NPDB.Dx$outcomeScale <- as.integer(NPDB.Dx$outcome)
head(NPDB.Dx)

# alegatn1 dummy variables
NPDB.Dx$a1failToDx <- ifelse(NPDB.Dx$alegatn1 == "Failure to Diagnose",1,0)
NPDB.Dx$a1delayInDx <- ifelse(NPDB.Dx$alegatn1 == "Delay in Diagnosis",1,0)
NPDB.Dx$a1wrongDx <- ifelse(NPDB.Dx$alegatn1 == "Wrong or Misdiagnosis (e.g. Original Diagnosis is Incorrect)",1,0)
NPDB.Dx$a1failToOrder <- ifelse(NPDB.Dx$alegatn1 == "Failure to Order Appropriate Test",1,0)
NPDB.Dx$a1radError <- ifelse(NPDB.Dx$alegatn1 == "Radiology or Imaging Error",1,0)

# alegatn2 dummy variables (tx is a medical abbreviation for "treatment")
NPDB.Dx$a2failToTx <- ifelse(NPDB.Dx$alegatn2 == "Failure to Treat",1,0)
NPDB.Dx$a2delayInTx <- ifelse(NPDB.Dx$alegatn2 == "Delay in Treatment",1,0)
NPDB.Dx$a2delayInDx <- ifelse(NPDB.Dx$alegatn2 == "Delay in Diagnosis",1,0)
NPDB.Dx$a2failToDx <- ifelse(NPDB.Dx$alegatn2 == "Failure to Diagnose",1,0)
NPDB.Dx$a2failToTest <- ifelse(NPDB.Dx$alegatn2 ==  "Failure to Order Appropriate Test",1,0)

# ptage - ????
NPDB.Dx$ptagestr = as.character.factor(NPDB.Dx$ptage)
if(is.numeric(substr(NPDB.Dx$ptagestr,6,7))) NPDB.Dx$patientAge <- as.numeric(substr(as.character(NPDB.Dx$ptagestr),6,7)) + 5
if(NPDB.Dx$ptagestr == "Age under 1 year") NPDB.Dx$patientAge <- 0
if(NPDB.Dx$ptagestr == "Ages 1 through 9") NPDB.Dx$patientAge <- 5
summary(NPDB.Dx$patientAge)

# ptgender
summary(NPDB.Dx$ptgender)
NPDB.Dx$ptFemale <- ifelse(NPDB.Dx$ptgender == "F",1,0)
NPDB.Dx$ptMale <- ifelse(NPDB.Dx$ptgender == "M",1,0)

# pttype
summary(NPDB.Dx$pttype)
NPDB.Dx$inpatient <- ifelse(NPDB.Dx$pttype %in% c("I","B"),1,0)
NPDB.Dx$outpatient <- ifelse(NPDB.Dx$pttype %in% c("O","B"),1,0)

fields = c("totalPayment", "MDage", "MDexp", "outcomeScale", "patientAge", "ptFemale", "ptMale", "inpatient", "outpatient", "a1failToDx", "a1delayInDx", "a1wrongDx", "a1failToOrder", "a1radError", "a2failToTx", "a2delayInTx", "a2delayInDx", "a2failToDx", "a2failToTest")

summary(NPDB.Dx)

# Get Regions
sort(summary(NPDB.Dx$licnstat))

region1 = c("Hawaii","Alaska","Washington","California","Oregon")
region2 = c("Montana", "Idaho", "Wyoming", "Nevada", "Utah", "Colorado", "Arizona", "New Mexico")
region3 = c("North Dakota", "South Dakota", "Minnesota", "Iowa", "Nebraska", "Kansas", "Missouri")
region4 = c("Texas", "Oklahoma", "Arkansas", "Louisiana", "Kentucky", "Tennessee", "Mississippi", "Alabama")
region5 = c("Maine","Vermont","New Hampshire","Massachusetts","Connecticut","Rhode Island","New York","Pennsylvania","New Jersey")
region6 = c("West Virginia", "Maryland", "Delaware", "Virginia", "North Carolina", "South Carolina", "Georgia", "Florida")
region16 = append(region1,region6)
NPDB.reg1 <- subset(NPDB.Dx, NPDB.Dx$licnstat %in% region1, select = fields)
NPDB.reg2 <- subset(NPDB.Dx, NPDB.Dx$licnstat %in% region2, select = fields)
NPDB.reg3 <- subset(NPDB.Dx, NPDB.Dx$licnstat %in% region3, select = fields)
NPDB.reg4 <- subset(NPDB.Dx, NPDB.Dx$licnstat %in% region4, select = fields)
NPDB.reg5 <- subset(NPDB.Dx, NPDB.Dx$licnstat %in% region5, select = fields)
NPDB.reg6 <- subset(NPDB.Dx, NPDB.Dx$licnstat %in% region6, select = fields)
NPDB.reg16 <- subset(NPDB.Dx, NPDB.Dx$licnstat %in% region16, select = fields)

summary 
# Region Counts
# region 1: 3643 
# region 2: 2082
# region 3: 1726
# region 4: 4336
# region 5: 14506
# region 6: 6372
# region 16: 10015

summary(NPDB.reg16)                    
summary(NPDB.reg5)                    


#----------------------------------------------
# DEPENDENT VARIABLE: totalpmt
#----------------------------------------------

#----------------------------------------------
# INDEPENDENT VARIABLES
#----------------------------------------------
# Physician vars: MDage, MDexp
# Patient vars: patientage, ptFemale, ptMale, inpatient, outpatient
# Malpractice vars: outcomeScale
# Allegation 1 vars: a1failToDx, a1delayInDx, a1wrongDx, a1failToOrder, a1radError
# Allegation 2 vars: a2failToTx, a2delayInTx, a2delayInDx, a2failToDx, a2failToTest

fit.sub16 = lm(totalpmt ~ ., data = NPDB.reg16)
summary(fit.sub16)

fit.sub5 = lm(totalpmt ~ ., data = NPDB.reg5)

