## Script to drop outliers

library(ape)
library(readr)

tree <- read.tree("New/ethiopia_nextalign.aligned.nwk")  
# create vector list of seqIDs to drop from the tree
drop_tip <- read_csv("outliers.txt", col_names = FALSE) #c("Botswana/R04B08_BHP_361996/2021-02-07, Egypt/NRC-6662/2020-09-10")
new_tree <- drop.tip(tree, drop_tip$X1, trim.internal = TRUE)
write.tree(new_tree, "new_tree.nwk")
