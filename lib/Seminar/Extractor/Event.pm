package Seminar::Extractor::Event;

use strict;
use warnings;
use Moo;

use XML::Feed::Entry;
use Data::ICal::Entry::Event;
use Data::ICal::DateTime;


has title => ( is => 'rw' );

has datetime => ( is => 'rw' );

has description => ( is => 'rw' );

has link => ( is => 'rw' );

has location => ( is => 'rw' );

sub as_feed_entry {
	my ($self, $entry) = @_;
	$entry->title( $self->title );
	$entry->issued( $self->datetime );
	$entry->link( $self->link );
	$entry->content( $self->description );
	$entry;
}

sub as_data_ical_event {
	my ($self) = @_;
	my $event = Data::ICal::Entry::Event->new();
	$event->add_property( start => $self->datetime );
	$event->add_property( summary => $self->title );
	$event->add_property( description => $self->description );
	$event->add_property( url => $self->link );
	$event;
}

1;
