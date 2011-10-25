use v5.10;
use strict;
use warnings;

package Periscope;
# ABSTRACT: Module for viewing sites through a periscope

use Moose;
use Glib qw(TRUE FALSE);
use Gtk2 -init;
use Gtk2::WebKit;
use Gtk2::Notify -init, 'Periscope';

use Data::Dump qw(dump);
use Exporter 'import';
our @EXPORT = qw(TRUE FALSE);

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
has 'title'   => ( isa => 'Str', is => 'rw', default => sub { shift->address });

sub BUILD {
	my $self = shift;
	my $sw   = Gtk2::ScrolledWindow->new;

	$sw->add($self->webview);
	$self->window->add($sw);

	$self->window->set_title($self->title);

	# destroy event
	$self->window->signal_connect(destroy => sub { Gtk2->main_quit });

	# navigation-policy-decision-requested
	$self->webview->signal_connect('navigation-policy-decision-requested' => sub {
		# use this for hook for progress bar widget
		my ($webview) = @_;
		say $webview->get_progress;

		dump(@_);

		return FALSE;
	});

	$self->{events} = {};

	dump($self->webview->get_progress);
}

sub event($$&) {
	my $self  = shift;
	my $event = shift;
	my $code  = shift;

	dump($event);
	dump($code);

	$self->{events}->{$event} = sub { my $p = $self; $code->($p, @_) };

	dump($self->{events});

	$self->webview->signal_connect($event => $self->{events}->{$event});

	$self;
}

after 'title' => sub {
	my $self = shift;
	my $val  = shift;

	$self->window->set_title($val);
};

sub notify {
	my $self = shift;

	Gtk2::Notify->new(@_)->show;

	$self;
}

sub show {
	my $self = shift;

	$self->webview->open($self->address);
	$self->window->resize($self->width, $self->height);

	$self->window->show_all;
	Gtk2->main;

	$self;
}

1;
