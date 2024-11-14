setwd("/Users/federicapicogna/Desktop/GitHub/jaspAudit/")

library(jaspTools)

# Setup jasptools
remotes::install_github("jasp-stats/jaspTools")
setupJaspTools(pathJaspDesktop = "/Users/federicapicogna/Desktop/GitHub/JASP/jasp-desktop", installJaspModules = FALSE, installJaspCorePkgs = TRUE, quiet = FALSE, force = TRUE)

setPkgOption("module.dirs", "~/GitHub/jaspAudit/")
setPkgOption("module.dirs", "~/GitHub/jaspBain/")
setPkgOption("module.dirs", "~/GitHub/jaspMachineLearning/")
setPkgOption("module.dirs", "~/GitHub/jaspQualityControl/")
setPkgOption("module.dirs", "~/GitHub/jaspIrt/")

# Test analyses
testAll()
manageTestPlots()
testAnalysis("auditBayesianEvaluation")

# auditClassicalWorkflow
# auditBayesianWorkflow
# auditClassicalPlanning
# auditBayesianPlanning
# auditSelection
# auditClassicalEvaluation
# auditBayesianEvaluation
# auditClassicalBenfordsLaw
# auditClassicalNumberBunching
# auditClassicalModelFairness