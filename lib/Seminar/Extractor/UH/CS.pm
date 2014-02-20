package Seminar::Extractor::UH::CS;

use strict;
use warnings;
use Seminar::Config;
use Moo;

use Web::Scraper;

has _url => (
	is => 'ro',
	default => sub { 'http://www.cs.uh.edu/news-events/seminars/' }
);

sub _content {
	my ($self) = @_;
	Seminar::Config->instance->mechanize->get( $self->_url );
}

has _extractor => (
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
	$self->_extractor->scrape( $self->_content );
}

1;
