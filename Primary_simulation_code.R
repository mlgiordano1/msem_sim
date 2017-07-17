#-------------------------------------------------------------------------------
# Break: packages, wd, initial arguments
#-------------------------------------------------------------------------------
library("MplusAutomation")

setwd("C:/users/mgiordan/git/msem_sim")
# Initial arguments
# Use this section to skip sections you don't need to re-run
genMplusData_andFit <- TRUE


# ------------------------------------------------------------------------------
# Break: Mplus: Generate Data, 
# ------------------------------------------------------------------------------
if (genMplusData_andFit==TRUE) {
  # Generate Data mplus file
genData <- "
! DO NOT EDIT IN TEXT. EDIT IN PRIMARY SIMULATION CODE r FILE. 
TITLE:	M3 Sim

montecarlo:
	names are y1-y12 ;
	nobservations = 1000;
	ncsizes = 1;
	csizes = 100 (10); !format #OfClustesr (SizeOfClusters)
	seed = 120170510;
	nrep = 100;
    repsave = ALL;
	save = C:\\Users\\mgiordan\\git\\msem_sim\\genData\\mpData\\mpData_I12_N1000_norm_*.dat;


ANALYSIS:	
	TYPE IS twolevel;
    !ESTIMATOR=BAYES;
    !estimator = WLS;
	!distribution = skewnormal;


MODEL POPULATION:

	%Within%
	Aw BY y1@1; 
	Aw BY y2@.7; 
	Aw BY y3@.8; 
    Aw BY y4@.8;
    Aw BY y5@.8;
    Aw BY y6@.8;
    Aw BY y7@.8;
    Aw BY y8@.8;
    Aw BY y9@.8;
    Aw BY y10@.8;
    Aw BY y11@.8;
    Aw BY y12@.8;
	y1-y12*1;
	Aw*1;

	%Between%
	Ab BY y1@1;
    Ab BY y2@.9; 
    Ab BY y3@.9; 
    Ab BY y4@.9; 
    Ab BY y5@.9; 
    Ab BY y6@.9; 
    Ab BY y7@.9; 
    Ab BY y8@.9; 
    Ab BY y9@.9; 
    Ab BY y10@.9;
    Ab BY y11@.9; 
    Ab BY y12@.9;  
	Ab*.4;
	y1-y12@1;

MODEL:
	
	%Within%
	Aw BY y1@1; 
	Aw BY y2@.7; 
	Aw BY y3@.8; 
    Aw BY y4@.8;
    Aw BY y5@.8;
    Aw BY y6@.8;
    Aw BY y7@.8;
    Aw BY y8@.8;
    Aw BY y9@.8;
    Aw BY y10@.8;
    Aw BY y11@.8;
    Aw BY y12@.8;
	y1-y12*1;
	Aw*1;

	%Between%
	Ab BY y1@1;
    Ab BY y2@.9; 
    Ab BY y3@.9; 
    Ab BY y4@.9; 
    Ab BY y5@.9; 
    Ab BY y6@.9; 
    Ab BY y7@.9; 
    Ab BY y8@.9; 
    Ab BY y9@.9; 
    Ab BY y10@.9;
    Ab BY y11@.9; 
    Ab BY y12@.9;  
	Ab*.4;
	y1-y12@1;

output:
	tech8 tech9;
"
# Write data generation input file, and run it
writeLines(genData, 
          "C:/Users/mgiordan/git/msem_sim/genData/genData_i012_n1000_norm.inp")
runModels("C:/Users/mgiordan/git/msem_sim/genData", filefilter = "genData_i012_n1000_norm.inp")

# Use Mplus automate to make scripts, which fit each data model
fitData <- '
[[init]]
iterators 	= num;
num 		= 1:100;
filename = "simrun_i12_n1000_norm_[[num]].inp";
outputDirectory = "C:\\Users\\mgiordan\\git\\msem_sim\\fitModels";
[[/init]]

TITLE: "MSEM - Number of indicators(12); Sample Size(1000)"; 
Run #[[num]] ;

DATA: 
	FILE = "C:\\Users\\mgiordan\\git\\msem_sim\\genData\\mpData\\mpData_I12_N1000_norm_[[num]].dat";

VARIABLE: 
    NAMES = A1-A12 group ; 
    MISSING=.;
    USEVARIABLES ARE group A1-A12; 
    CLUSTER IS group; 

ANALYSIS: 
	TYPE IS TWOLEVEL; 
	H1ITERATIONS = 5000;
	!estimator = WLS;

MODEL:
    %WITHIN%
    A_wit BY A1-A12;
    %BETWEEN%
    A_bet BY A1-A12;

OUTPUT:
    TECH1 STDYX;
'
# Write template script, write all models, fit all models
writeLines(fitData, con = "C:/users/mgiordan/git/msem_sim/fitModels/fitmodels_template.txt")
createModels("C:/users/mgiordan/git/msem_sim/fitModels/fitmodels_template.txt")
runModels("C:/users/mgiordan/git/msem_sim/fitModels/")
}

# ------------------------------------------------------------------------------
# Break: Aggregating Mplus Results
# ------------------------------------------------------------------------------


# ------------------------------------------------------------------------------
# Break: Fitting Models MIIV style
# ------------------------------------------------------------------------------
# Wd to the Mplus Data
setwd("./genData/mpData")
# List all files in data folder
allDataSets <- list.files()
# Removing the 'list' files
allDataSets <- allDataSets[!grepl("list", allDataSets)]

# Loop over every dataset
for (i in seq(allDataSets)) {
  
  
  dat <- read.table(allDataSets[i], 
                    col.names = c(paste("y", 1:12, sep = ""), "cluster"))
  # Create the between/within matrices
  
  #need to make long
  
  # Might be fun to try and do this with Dplyr
  
  
}

