#!/usr/bin/env bash
# batchwebp.sh - Miscellaneous Scripts - Created on the 12th of May, 2024.
# Copyright 2024, Jordan Silver (silverlyne). All rights reserved.
#
# Runs cwebp on all jpegs in a folder. ONLY JPG/JPEG FILES.
# If we decide to use webp in GPUI/imagecat, this'll be the step in the pipeline immediately after exporting them from icloud.
# This is a bash script, make sure you're in bash when testing shell commands..

# === PARAMETERS ===
# Hardcoded parameters, feel free to change them (:
qualityParam=75 # Default set by cwebp

# === ENVIRONMENT AND ARGUMENT CHECKS ===
# Is cwebp installed and useable? (don't print anything unless there's a problem.)
which cwebp > /dev/null
if [ "$?" -ne 0 ]; then
    echo 'Cant find cwebp. Please make sure libwebp is installed and in $PATH. (1)'
    exit 1
fi
# Was an input folder passed?
inputDir=$1
inputFolder="${inputDir##*/}" # name only, no base path. used in generating names for the output folder
if [[ -z "$inputDir" ]]; then
    echo 'No input folder given. (2)'
    exit 2
fi
# Does that folder actually exist?
if [[ ! -d "$inputDir" ]]; then
    echo 'Input folder does not exist (3)'
    exit 3
fi
cd $inputDir/..

# Can we make an output folder? If not, assume problems
outputDestination="$PWD/${inputFolder}.q${qualityParam}.batchwebp"
mkdir $outputDestination > /dev/null
if [ "$?" -ne 0 ]; then
    echo "Output folder either already exists or cannot be created."
    echo "Please make sure this folder:"
    echo "$outputDestination"
    echo "is not already there and the parent folder doesn't have permission issues. (4)"
    exit 4
fi
echo "Using ${outputDestination} as output package directory. (5)"



# === THE REST OF THE OWL ===
files=(${inputDir}/*.jp*) # Return files with both .jpg and .jpeg in the name, no other extensions

for i in "${files[@]}"; do
    fileName="${i##*/}" # filename only, no path
    cwebp '-q' "$qualityParam" "$i" '-o' "${outputDestination}/${fileName}.webp" '-quiet'
done

echo "${#files[@]} files exported to this folder:"
echo "${outputDestination} (0)"
# echo "DEBUG - Exiting zero. (0)"
exit 0