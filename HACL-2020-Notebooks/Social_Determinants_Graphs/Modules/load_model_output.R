

# Import p values for states
states.all_p <- readRDS("StateSummaries/ALL_P.rds")

# Import c values for states
states.all_c <- readRDS("StateSummaries/ALL_C.rds")

# Import p values for states
states.all_merged <- readRDS("StateSummaries/ALL_merged.rds")

# Import model input data
model_input <- readRDS('data/07-05-2020data.Rds')

# Import national model summary
national <- readRDS('Modules/combined.summary.July8.Rds')

statenames = c("WY", "WV", "WI", "WA", "VT", "VA", "UT", "TX", "TN", "SD", "SC", "PA", "OR", "OK", "OH", "NY", "NV", "NM", "NJ", "NH", 
               "NE", "ND", "NC", "MT", "MS", "MO", "MN", "MI", "ME", "MD", "MA", "LA", "KY", "KS", "IN", "IL", "ID", "IA", "GA", "FL",
               "DE", "CT", "CO", "CA", "AZ", "AR", "AL")

GWAS_ADJ_P <- data.frame(row.names = colnames(model_input))
#colnames(GWAS_ADJ_P) < - statenames
GWAS_MRR <- data.frame(row.names = colnames(model_input))
#colnames(GWAS_MRR) < - statenames
for (state in statenames) {
  fname <- paste("./StateSummaries/",state,".summary.rda",sep="")
  load(fname)
  
  
  #f2 <- eval(as.name(paste(state,".GWAS_MRR", sep = "")))
  fname2 <- paste("./GWAS/state_results/", state, "_GWAS_ADJ_P.rds", sep = "")
  #f2 <- data.frame(row.names = rownmames(readRDS(fname2)))
  if (file.exists(fname2)) {
    temp2 <- readRDS(fname2)
  } else {
    next
  }
  #f3 <- eval(as.name(paste(state,".GWAS_ADJ_P", sep = "")))
  fname3 <- paste("./GWAS/state_results/", state, "_GWAS_MRR.rds", sep = "")
  #f3 <- data.frame(row.names = rownmames(readRDS(fname3)))
  if (file.exists(fname3)) {
    temp3 <- readRDS(fname3)
  } else {
    next
  }
  if (is.na(temp2) == FALSE && is.na(temp3) == FALSE) {
    in_p = c(NA)
    length(in_p) <- length(colnames(model_input))
    in_c = c(NA)
    length(in_c) <- length(colnames(model_input))
    for (dat in 1:length(colnames(model_input))) {
      datum = colnames(model_input)[dat]
      if (datum %in% colnames(temp2) && datum %in% colnames(temp3) ) {
        in_p[dat] <- unname(temp2[[datum]][length(temp2[[datum]])])
        in_c[dat] <- unname(temp3[[datum]][length(temp3[[datum]])])
      }
    }
    GWAS_ADJ_P[[state]]  = in_p 
    GWAS_MRR[[state]]    = in_c 
  }
  
}

# adjusted p vals
states.adjusted_p <- readRDS("AdjustedStateSummaries/ALL_P.rds")

states.adjusted_c <- readRDS("AdjustedStateSummaries/ALL_C.rds")

states.shapes <- readRDS("data/json/us_projection.Rds")

# Convert to dataframe state data
states <- states.shapes
states <- data.frame(states)
states <- states[c("fips_state", "name")]
colnames(states) <- c("FIPS", "NAME")


