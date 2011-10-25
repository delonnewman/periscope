use v5.10;
use strict;
use warnings;

package Periscope;
# ABSTRACT: Perl Module for viewing sites through a periscope

use Moose;
use Gtk2 -init;
use Gtk2::WebKit;

has 'window' => (
		isa     => 'Gtk2::Window',
		is      => 'ro',
		default => sub { Gtk2::Window->new }
);

has 'width'  => ( isa => 'Int', is => 'rw', default => sub { 500 } );
has 'height' => ( isa => 'Int', is => 'rw', default => sub { 500 } );

has 'webview' => (
		isa     => 'Gtk2::WebKit::WebView',
		is      => 'ro',
		default => sub { Gtk2::WebKit::WebView->new }
);

has 'address' => ( isa => 'Str', is => 'rw' );

sub BUILD {
	my $self = shift;
	my $sw   = Gtk2::ScrolledWindow->new;

	$sw->add($self->webview);
	$self->window->add($sw);

	# destroy event
	$self->window->signal_connect(destroy => sub { Gtk2->main_quit });
}

sub show {
	my $self = shift;

	$self->webview->open($self->address);
	$self->window->resize($self->width, $self->height);

	$self->window->show_all;
	Gtk2->main;
}

1;
