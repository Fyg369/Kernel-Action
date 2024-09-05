#!/usr/bin/env perl -w

use strict;
use Cwd;
use warnings;

my $fileExist = -e "./.git";
my $T = -e "./tests";

if ( $fileExist ) {
    system("git clean -dxf");
    system("git checkout .");
} else {
    if ( $T ) {
        unlink "tests/yarn.lock";
        unlink "tests/shfmt*";
        rmdir "tests/node_modules";
    }
}
