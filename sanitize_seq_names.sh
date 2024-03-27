#!/bin/bash

FASTA=$1
OUTPUT=$2

echo "# Input FASTA: "$FASTA
echo "# Output FASTA: "$OUTPUT

# Creating a copy of the data in the results folder
echo ""
echo "Creating a copy of the data, placed in the results folder"
echo "cp $FASTA ${OUTPUT}.bk"
cp $FASTA ${OUTPUT}.bk

# Get fast file name
#FASTA_NAME=$(basename $FASTA)

#echo $FASTA_NAME 
#echo $FASTA

grep ">" $FASTA | cut -c 2-  > "${FASTA}.seq_names.txt"

echo ""
echo "Cleaning our FASTA header information in: "${OUTPUT}.bk
echo "Replacing illegal characters with underscores"
# Backup here will be in the data folder
# inplace modifications
if [[ $(uname -s) == "Linux" ]]; then
   sed -i -e "s/ /_/g" -e "s/:/_/g" -e "s/|/_/g" -e "s/-/_/g" -e "s/\//_/g" ${OUTPUT}.bk
elif [[ $(uname -s) == "Darwin" ]]; then
    sed -i '' -e "s/ /_/g" -e "s/:/_/g" -e "s/|/_/g" -e "s/-/_/g" -e "s/\//_/g" -e "s/.//_/g" ${OUTPUT}.bk
else
    echo "Check that your OS is supported"
fi
# Run GAWK
# This is for GISAID data.
#echo ""
#echo "Running gawk to clean up header information"
#gawk '{ if ($0 ~ "^>") {b=gensub(/>(.+)\|(EPI_ISL_|epi_isl_)([0-9]+)\|(.+)/, ">epi_isl_\\3/\\1","g"); print b;} else print;}' ${OUTPUT}.bk > $OUTPUT

echo ""
echo "Removing backup .bk files"
# Delete backup file
#rm ${OUTPUT}.bk


exit 0
