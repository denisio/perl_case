#!/usr/bin/perl
use Test::Unit::TestRunner;

my $test_class = shift @ARGV;

die "Enter test class\n" unless $test_class;

my $testrunner = Test::Unit::TestRunner->new();
$testrunner->start($test_class);
