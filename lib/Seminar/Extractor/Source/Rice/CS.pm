package Seminar::Extractor::Source::Rice::CS;

use strict;
use warnings;

use Moo;
use Web::Scraper;

has _url => ( is => 'ro', default => sub { 'http://compsci.rice.edu/events.cfm' } );

has _web_scraper => (
	is => 'lazy',
	builder => sub {
		scraper { process 'tr', 'times[]' => scraper {
			process '//td[last()]', 'data' => {
				'body' => 'HTML',
				'link' => scraper {
					process '//a', link => '@href';
					result 'link';
				},
			};
			process '//b', 'time' => 'HTML';
		}
		};
	},
);

sub extract {
	my ($self) = @_;
	my $data = $self->_scrape;
	use DDP; p $data;
	$data;
}

sub events_arrayref {
	my ($self) = @_;
	$self->extract;
	[];
}


with qw(
	Seminar::Extractor::Role::WebScraperExtractable
	Seminar::Extractor::Role::Location::Houston
	Seminar::Extractor::Role::Extraction::DTFmtNatural
);

1;
