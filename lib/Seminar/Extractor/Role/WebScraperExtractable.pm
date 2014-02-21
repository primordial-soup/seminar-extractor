package Seminar::Extractor::Role::WebScraperExtractable;

use strict;
use warnings;
use Moo::Role;
with 'Seminar::Extractor::Role::ContentRetrievable';

use Web::Scraper;

requires '_web_scraper';

sub _scrape {
	my ($self) = @_;
	$self->_web_scraper->scrape( $self->_content );
}

1;
