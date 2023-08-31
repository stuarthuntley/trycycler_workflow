#!/usr/bin/perl

$infile = `cat filtlong.log`;
#print "start\n";
@filtParts = split('\r  ', $infile);
print "$filtParts[0]\n$filtParts[1]\n...\n$filtParts[-1]\n";
exit