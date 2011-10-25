#!/usr/bin/env perl 
use v5.10;

use lib qw{ lib };
use Periscope;
use Data::Dump qw(dump);

die "Usage: $0 URL" unless @ARGV;

Periscope->new(address => $ARGV[0])
	->event('download-requested' => sub {
		my $self     = shift;
		my $view     = shift;
		my $download = shift;
		my $url      = $download->get_uri;

		dump($self);

		$self->notify("Buk download requested", "downloading $url...");
		system("wget $url");

		FALSE;
	})
	->event('navigation-policy-decision-requested' => sub {
		my $self  = shift;
		my $view  = shift;
		my $frame = shift;
		my $req   = shift;

		dump($req->get_uri);

		my $dn = $ARGV[0];
		$dn =~ s|http://||;

		return TRUE unless $req->get_uri =~ /$dn/x;
		
		FALSE;
	})
	->show;
