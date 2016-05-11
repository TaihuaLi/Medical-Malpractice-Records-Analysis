dat <- # read in file
variables <- c("seqno", "rectype", "origyear", "licnstat", "licnfeld",
               "practage", "grad", "algnnatr", "alegatn1", "alegatn2",
               "outcome", "malyear1", "malyear2", "payment", "totalpmt",
               "paynumbr", "numbprsn", "paytype", "ptage", "ptgender",
               "pttype", "aaclass1", "practnum")
selected_dat <- subset(dat, rectype == 'M' | rectype == 'P', select=variables)
