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

sub as_feed_entry {
	my ($self, $entry) = @_;
	$entry->title( $self->title );
	$entry->issued( $self->datetime );
	$entry->link( $self->link );
	$entry->content( $self->description );
	$entry;
}

1;
