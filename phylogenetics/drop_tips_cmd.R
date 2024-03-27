#!/usr/bin/env Rscript
## Script to drop outliers
## To run: Rscript drop_tips_cmd.R 'in_tree' tips_to_drop out_tree
## https://www.delftstack.com/howto/r/r-command-line-arguments/#google_vignette

# Load required packages
library(ape)
library(readr)
library(treeio)

# Get the arguments as a character vector.
myargs = commandArgs(trailingOnly=TRUE)

# Input true
# ex. newick.tree
in_tree = myargs[1]
message("Input tree is: ", in_tree )

# Path to tips to drop
# Text file with tips to be drop
tipsToDropFile = myargs[2]
message("Tips to drop file is: ", tipsToDropFile)
# Output tree
# newick_pruned.tree or path to tree e.g. "New/ethiopia_nextalign.aligned.nwk"
pruned.tree = myargs[3]
message("Pruned tree name is: ", pruned.tree)

tree <- read.tree(in_tree)  
message("Input tree has ", length(tree$tip.label), " tips.")

# create vector list of seqIDs to drop from the tree
tipsToDrop <- read_csv(tipsToDropFile, col_names = FALSE) #c("Botswana/R04B08_BHP_361996/2021-02-07, Egypt/NRC-6662/2020-09-10")
new_tree <- drop.tip(tree, tipsToDrop$X1, trim.internal = TRUE)
message(length(new_tree$tip.label), " tips survived.")

write.tree(new_tree, pruned.tree)
