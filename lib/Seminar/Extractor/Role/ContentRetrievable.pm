package Seminar::Extractor::Role::ContentRetrievable;

use strict;
use warnings;
use Moo::Role;

use Seminar::Config;

requires '_url';

sub _content {
	my ($self) = @_;
	Seminar::Config->instance->mechanize->get( $self->_url );
}

1;
