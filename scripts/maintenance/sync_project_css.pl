# Syncs posit-92.css from DEMOS\hello_demoscene
# to all demo & test projects
#
# Part of Posit-92 game engine
#
# This script should be called at the root project

use strict;
use warnings;
use v5.38.2;

use File::Copy;

my $dh;

# Handle DEMOS

opendir($dh, "DEMOS") or die "Not in the root project";

for (grep {($_ !~ /\./) && (-d "DEMOS/$_") } readdir $dh) {
  next if "DEMOS/hello_demoscene" eq "DEMOS/$_";

  copy(
    "DEMOS/hello_demoscene/posit-92.css",
    "DEMOS/$_/posit-92.css")
}

closedir $dh;

# Handle TESTS

opendir $dh, "TESTS";

for (grep {($_ !~ /\./) && (-d "TESTS/$_")} readdir $dh) {
  copy(
    "DEMOS/hello_demoscene/posit-92.css",
    "TESTS/$_/posit-92.css")
}

closedir $dh;