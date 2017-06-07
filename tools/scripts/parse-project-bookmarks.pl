#!/usr/bin/perl
# THIS SCRIPT TAKES A BOOKMARKS EXPORT FILE FROM GOOGLE CHROME AND EXPORTS ANOTHER FILE: "project_bookmarks.html"
# ONLY BOOKMARKS INSIDE A FOLDER NAMED: "__ PROJECT __" ARE RETAINED
# - BOOKMARKS MAY BE INSIDE SUBFOLDERS UNDER THE PROJECT FOLDER
# - NOTICE: PROCESSING OF BOKMARKS ONLY WORKS WHEN ANY TOP LEVEL BOOKMARKS PARENT DIRECTORY
#     IS COPIED/MOVED TO SOMEWHERE ELSE, IMMEDIATELY BEFORE EXPORTING.
# - AN EXAMPLE IS A FOLDER NAMED: "FOR-EXPORT" IN THE ROOT OF "Bookmarks Bar"
# - THE SCRIPT TAKES TWO ARGUMENTS: ./parse-project-bookmarks.pl [export_dir], [file_to_import]

use strict;
use warnings FATAL => 'all';

my $contents;
my $export_location = $ARGV[0] . '/' . 'project_bookmarks.html';
my $bookmarks    = $ARGV[1];

{
    local $/ = undef;
    open I_FILE, $bookmarks or die "Couldn't open $bookmarks: $!";
    print "Loading bookmarks from file: $bookmarks\n";
    binmode I_FILE; $contents = <I_FILE>; close I_FILE;
}

my ($match_string) = $contents =~ /.*ADD_DATE="([0-9]{9,}).*__ PROJECT __.*/;

my @grep_match = map { local $_ = $_; s/ICON=.*?>/>/g; s/<DT>(<A HREF)/\n\t<li>$1/; $_ }
                 grep { /$match_string/ } split /\n/, $contents;

my @categories = map { local $_ = $_; s| *</*.*?> *||g; $_ }
                 grep { /[^_]{2}<\/H[0-9]{1,2}>/ } @grep_match;


open O_FILE, '>', $export_location or die "Couldn't open $export_location: $!";
while (<DATA>) {
  $_ =~ s/%TITLE%/@categories/;
  $_ =~ s/%BODY%/@grep_match/;
  print O_FILE;
}
close O_FILE;


print "match_string: $match_string, and matched: $#grep_match lines\n";

exit;


__DATA__
<!DOCTYPE html>
<html>
<head>
<title>%TITLE%</title>
    <style type="text/css">
        body {
            color: #606c76;
            font-family: 'Roboto', 'Helvetica Neue', 'Helvetica', 'Arial', sans-serif;
            font-size: 0.9em;
            font-weight: 100;
            letter-spacing: .03em;
            line-height: 1.5;
            padding-left: 2%;
        }
        h3  {
            font-size: 1.4rem;
            font-weight: 100;
            letter-spacing: .04em;
            margin-left: -15px;

        }
        a   {
            padding-left: 1%;
        }

    </style>
</head>
<body>
%BODY%
</body>
</html>