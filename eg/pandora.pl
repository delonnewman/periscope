#!/usr/bin/env perl 
use v5.10;
use strict;
use warnings;

use lib qw{ lib };
use Periscope;
use Data::Dump qw(dump);

Periscope->new(
	address => 'http://pandora.com',
	title   => 'Pandora Periscope',
	icon    => "eg/Pandora.png",
	width   => 800,
	height  => 600
)->show;
