#!/usr/bin/env perl 
use v5.10;
use Periscope;

die "Usage: $0 URL" unless @ARGV;

Periscope->new(address => $ARGV[0])->show;
