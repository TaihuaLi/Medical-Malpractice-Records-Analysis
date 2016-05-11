dat <- # read in file
variables <- c("seqno", "rectype", "origyear", "licnstat", "licnfeld",
               "practage", "grad", "algnnatr", "alegatn1", "alegatn2",
               "outcome", "malyear1", "malyear2", "payment", "totalpmt",
               "paynumbr", "numbprsn", "paytype", "ptage", "ptgender",
               "pttype", "aaclass1", "practnum")
new_dat <- subset(dat, rectype == 'M' | rectype == 'P', select=variables) # M&P only (malpractice payments)
new_dat <- subset(new_dat, licnfeld == 10 | licnfeld == 15 | licnfeld == 20 | licnfeld == 25) # doctors only
