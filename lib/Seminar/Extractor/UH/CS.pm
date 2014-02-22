package Seminar::Extractor::UH::CS;

use strict;
use warnings;
use Moo;
use Web::Scraper;
use DateTime::Format::Natural;
use DateTime::TimeZone;
use Data::Rmap qw(rmap rmap_hash);
use HTML::FormatText;

has _tz => (
	is => 'lazy',
	builder => sub {
		DateTime::TimeZone->new( name => 'America/Chicago' );
	},
);

has _dt_parser => (
	is => 'lazy',
	builder => sub {
		my ($self) = @_;
		DateTime::Format::Natural->new(
				lang => 'en',
				format => 'm/d/y',
				time_zone => $self->_tz
			);
	},
);

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
	use DDP;
	rmap_hash {
		my $hash = $_;
		if( defined $_ and exists $_->{time}  ) {
			my $text = HTML::FormatText->format_string( $_->{time} );
			my $substring = $self->_dt_parser->extract_datetime( $text );
			$hash->{datetime_text} = $text;
			$hash->{datetime_text_sub} = $substring;
			my $dt = $self->_dt_parser->parse_datetime( $substring );
			$hash->{datetime} = $dt;
		}
	} $data;
	$data;
}

with 'Seminar::Extractor::Role::WebScraperExtractable';

1;
