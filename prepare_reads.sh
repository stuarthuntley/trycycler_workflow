#!/usr/bin/env bash

# This script reads and input fastq file, performs a quality filter
# on the reads, and splits the file into 12 subread sets.

# It takes one positional argument: read file location
# Check if there is an input argument for the read file
if [ $# -eq 1 ]; then
    # check if the read file actually exists
    if [ ! -f "$1" ]; then
        echo "The input read file '$1' does not exist."
        exit 1
    fi
else
    echo "Usage: $0 [raw read file]"
    exit 1
fi

# assign variable read_file to $1
read_file="${1:?Missing raw read file}"

# Adjust workspace landscape for saving log data of workflow
mkdir -p logs

# Use filtlong to remove very poor quality and short (< 1kb) reads
# from raw read file and save output as reads.fq in working dir.
echo "filtlong --min_length 1000 --keep_percent 95 $read_file > reads.fq" > logs/filtlong.log

script -a logs/filtlong.log -c "filtlong --min_length 1000 --keep_percent 95 '$read_file' > reads.fq"

# Next run the trycycler tool subsample to split the reads.fastq
echo "trycycler subsample --reads reads.fq --out_dir read_subsets" > logs/subsample.log

trycycler subsample --reads reads.fq --out_dir read_subsets >> logs/subsample.log