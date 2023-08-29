#!/usr/bin/env bash

# This script reads and input fastq file, performs a quality filter
# on the reads, and splits the file into 12 subread sets.

# It takes one positional argument: read file location
# Use filtlong to remove very poor and short (< 1kb) reads from
# raw read file and save output as reads.fq in working dir.
filtlong -min_length 1000 --keep_percent 95 input_reads.fastq.gz > reads.fastq

