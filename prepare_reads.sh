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
echo -e "\n\n** threads=4 **\n\n"
threads=4 # this may not be necessary, read splitting option may use multiple threads
echo -e "\n\n** mkdir -p logs **\n\n"
mkdir -p logs

# Use the filtlong script read_info_histograms.sh to investigate the
# state of the raw read file
echo -e"\n\n** read_info_histograms.sh $read_file > logs/raw_read_analysis.log **\n\n"
read_info_histograms.sh "$read_file" > logs/raw_read_analysis.log

# Use filtlong to remove very poor quality and short (< 1kb) reads
# from raw read file and save output as reads.fq in working dir
echo -e "\n\n** filtlong --min_length 1000 --keep_percent 95 $read_file > reads.fq **\n\n"
echo -e "** filtlong --min_length 1000 --keep_percent 95 $read_file > reads.fq **\n\n" > logs/filtlong.log
filtlong --min_length 1000 --keep_percent 95 "$read_file" > reads.fq 2> filtlong.tmp
echo -e "\n\n** perl fix_filtlong_log.pl >> logs/filtlong.log **\n\n"
perl fix_filtlong_log.pl >> logs/filtlong.log

# Use read_info_histograms.sh again on the filtered reads
echo -e "\n\n** read_info_histograms.sh reads.fq > logs/filtered_read_analysis.log **\n\n"
read_info_histograms.sh reads.fq > logs/filtered_read_analysis.log

# Next run the trycycler tool subsample to split the reads.fastq
echo -e "\n\n** trycycler subsample --reads reads.fq --out_dir read_subsets **\n\n"
echo -e "** trycycler subsample --reads reads.fq --out_dir read_subsets **\n\n" > logs/subsample.log
trycycler subsample --reads reads.fq --out_dir read_subsets >> logs/subsample.log 2>&1

# Delete temporary data folders
# (commenting out for now during debugging)
#rm -r read_subsets
#rm filtlong.tmp