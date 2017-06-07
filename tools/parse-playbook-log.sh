#!/usr/bin/env perl

use strict;
use warnings;
 
#local $/ = undef;
my $line;
my $date;

while (<>) {

    $date = `date '+%F %X'`; 
    chomp $date;


    $line = $_;

    $line =~ s/\\"/"/g;
    $line =~ s/\\n/\n/g;

    $line =~ s/(\])(\s+)/$1\n$2/g;
 
    $line =~ s/\n/\n\t\t\t/g;

#   $line =~ s/^(.*?\w{1})/\t$1/;
#    $line =~ s/^.*([a-z0-9"]{1})/\t\t\t$1/gi;


    $line =~ s/\[/\[\n\t/g;
    $line =~ s/\]/\n\t  \]/g;
    $line =~ s/(\{)/ $1\n\t/g;
    $line =~ s/(\})/\n\t$1 /g;

    $line =~ s/^\s+([\w"])/\t  $1/g;

    $line =~ s/(\]",)/$1\n\t/g;
    $line =~ s/(",)(\s+)(")/$1\n\t$2$3/g;

    $line =~ s/KProgress.*?\n//g; 
    $line =~ s/"\\u001b.*?\n/\n/g;
    $line =~ s/\\r\\u001b\[.*?\n//g;

    $line =~ s/\s+\n\s*/\t\t/g;
#    $line =~ s/\s*\n/\n/g;    

    $line =~ s/(\.)(\s+)/$1\n\t\t$2/g;
    $line =~ s/(\])(\s+)/$1\n\t$2/g; 

    $line =~ s/\*+\n//g;
    $line =~ s/^\s+/ /g;

    $line =~ s/\[.*\n\s*([a-z0-9_-]+[.-]*[a-z0-9_-]+)\s*\n*\s*\]/\[ $1 \]/g; 

    print "$date $line\n";

}


