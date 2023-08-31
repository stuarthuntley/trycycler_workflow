#!/usr/bin/perl

# This script eliminates the middle of the list of reads in the
# temporary log file and prints the remaining info to the screen
$infile = `cat filtlong.tmp`;
@filtParts = split('\r  ', $infile);
print "$filtParts[0]\n$filtParts[1]\n...\n$filtParts[-1]\n";
exit