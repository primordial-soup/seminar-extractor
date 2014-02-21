package Seminar::Extractor::UH::CS;

use strict;
use warnings;
use Moo;
use Web::Scraper;

has _url => (
	is => 'ro', default => sub { 'http://www.cs.uh.edu/news-events/seminars/' }
);

has _web_scraper => (
	is => 'ro',
	default => sub {
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
	$self->_scrape;
}

with 'Seminar::Extractor::Role::WebScraperExtractable';

1;
