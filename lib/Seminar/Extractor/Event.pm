package Seminar::Extractor::Event;

use strict;
use warnings;
use Moo;


has title => ( is => 'rw' );

has datetime => ( is => 'rw' );

has description => ( is => 'rw' );

1;
