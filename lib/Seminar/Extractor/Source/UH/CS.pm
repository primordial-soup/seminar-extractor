package Seminar::Extractor::Source::UH::CS;

use strict;
use warnings;
use Moo;
use Web::Scraper;

has _url => (
	is => 'ro', default => sub { 'http://www.cs.uh.edu/news-events/seminars/' },
);

has _web_scraper => (
	is => 'lazy',
	builder => sub {
		scraper { process 'tr', 'events[]' => scraper {
			process '//td', 'time' => 'HTML';
			process '//td[last()]', 'description' => {
				'body' => 'HTML',
				'link' => scraper {
					process '//a', link => '@href';
					result 'link';
				}
			}
		}
		};
	},
);

sub extract {
	my ($self) = @_;
	my $data = $self->_scrape;
	$self->_dt_fmt_natural_extract($data);
}


with qw(
	Seminar::Extractor::Role::WebScraperExtractable
	Seminar::Extractor::Role::Location::Houston
	Seminar::Extractor::Role::Extraction::DTFmtNatural
);

1;
