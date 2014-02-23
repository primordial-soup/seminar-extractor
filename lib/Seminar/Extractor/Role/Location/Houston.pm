package Seminar::Extractor::Role::Location::Houston;

use strict;
use warnings;

use DateTime::TimeZone;

use Moo::Role;

has _tz => (
	is => 'lazy',
	builder => sub {
		DateTime::TimeZone->new( name => 'America/Chicago' );
	},
);

has _dt_fmt_natural_time_format =>  ( is => 'lazy', builder => sub { 'm/d/y' } );


1;
