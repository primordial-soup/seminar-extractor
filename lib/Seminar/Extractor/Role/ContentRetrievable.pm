package Seminar::Extractor::Role::ContentRetrievable;

use strict;
use warnings;
use Moo::Role;

use Seminar::Extractor::Config;

requires '_url';

sub _content {
	my ($self) = @_;
	Seminar::Extractor::Config->instance->mechanize->get( $self->_url );
}

1;
