#!/usr/bin/perl -n

use strict;
use warnings;
 
#local $/;

BEGIN {

#while (<>) {
 
    s/^(.)/  $1/sg;

    s/([,\{\}])/$1\n/g;
    s/\\n/\n/g;

    s/^(.*?:)(.*)(\[.*,)(.*)$/$1\t$2\n   $3\n$4/g;
    


    s/^/\t/sg;
    s/^(.*[\{\}]+.*)$/  $1/g;

    print "$_";

}

#    my $line = $_;

#    print "$line";


