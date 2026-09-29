use strict;
use warnings;
use v5.38.2;

use FindBin qw($Bin);
use Cwd qw(abs_path getcwd);
use File::Copy qw(copy);
use File::Spec::Functions qw(catdir catfile splitpath);
use File::Basename qw(basename dirname);
use Term::ANSIColor qw(colored);

use lib $Bin;
use DemoMetadata qw(read_mixins);

# print join " -- ", @ARGV;

my $script_dir = $Bin;

my $project_root = catdir($Bin, "..");

my $engine_dir = catdir($project_root, "experimental", "engine");
my $engine_js_path = catfile($engine_dir, "posit-92.js");

my $mixins_dir = catdir($project_root, "experimental", "mixins");

my $demo_or_option = $ARGV[0];

if (!$demo_or_option) {
  say "Usage:";
  say "$0 <demo_or_option> [--all]";

  exit 1
}

unless (-f $engine_js_path) {
  say "posit-92.js not found.  Run `tsc` first in experimental";
  exit
}

sub setup_demo {
  my $demo_name = shift;

  unless ($demo_name) {
    say "Missing $demo_name parameter!";
    return
  }

  my $demo_dir = catdir($project_root, "DEMOS", $demo_name);

  unless (-d $demo_dir) {
    say "Couldn't find ".$demo_dir."!";
    exit 1
  }

  # Copy engine JS

  say "Copying " . basename($engine_js_path) . "...";
  copy($engine_js_path, catfile($demo_dir, basename($engine_js_path)));

  # Handle mixins

  my @mixins = read_mixins $demo_name;

  if (@mixins) {
    say "Copying mixin files...";

    for my $mixin_name (@mixins) {
      my $mixin_filename = "p92-$mixin_name.mixin.js";

      copy(
        catfile($mixins_dir, $mixin_filename),
        catfile($demo_dir, $mixin_filename))
          or warn "Couldn't copy mixin: $mixin_filename"
    }
  }
}

# Handle --all option

if (grep { $_ eq "--all" } @ARGV) {
  say "--all option is used";

  for my $demo_dir (grep { -d } glob catdir($project_root, "DEMOS", "*")) {
    # say "Demo dir: ".$demo_dir;

    my $demo_name = basename($demo_dir);
    say "Handling ".$demo_name."...";

    setup_demo $demo_name
  }

  say colored("Done!", "bright_green");

  exit
}

# Otherwise handle setup for only 1 demo

setup_demo basename($demo_or_option);

say colored("Done!", "bright_green")
