package Seminar::Extractor::Source::UH::CS;

use strict;
use warnings;
use Moo;
use Web::Scraper;
use Data::Rmap qw(rmap_hash);

use Seminar::Extractor::Util;
use Seminar::Extractor::Event;
use HTML::FormatText;
use URL::Normalize;

use v5.12;

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

sub _extract_abstract {
	my ($self, $url) = @_;
	my $content = Seminar::Extractor::Config->instance->mechanize->get( $url );
	if( $url =~ /\.pdf$/ ) {
		return { abstract => Seminar::Extractor::Util->pdftotext($content->as_string) };
	} else {
		my $scraper = scraper {
			process ".main" => 'abstract' => 'TEXT';
		};
		$scraper->scrape($content);
	}
}


sub extract {
	my ($self) = @_;
	my $data = $self->_scrape;
	$data = $self->_dt_fmt_natural_extract($data);
	rmap_hash {
		if( defined $_
				and exists $_->{description}
				and exists $_->{description}{link} ) {
			return unless defined $_->{description}{link};

			# need to normalize because of URL with invalid .. segments
			# e.g., http://www.cs.uh.edu/../docs/cosc/seminars/2013/01.25-ordonez.pdf
			my $normalizer = URL::Normalize->new( url => $_->{description}{link} );
			$normalizer->remove_dot_segments;
			$_->{description}{link} = $normalizer->get_url;

			if( Seminar::Extractor::Config->instance->_verbose ) {
				#say $_->{description}{link};
				use DDP; p $_->{description}{link};
			}
			my $abstract = $self->_extract_abstract($_->{description}{link});
			$_->{abstract} = $abstract->{abstract};
		}
	} $data;
	$data;
}

sub events_arrayref {
	my ($self) = @_;
	my $data = $self->extract();
	[ rmap_hash {
		if( defined $_ and exists $_->{description} ) {
			my $description = $_->{abstract};
			my $datetime = $_->{datetime};
			my $title = HTML::FormatText
				->format_string($_->{description}{body});
			my $link = $_->{description}{link};
			return Seminar::Extractor::Event->new(
				title => $title,
				datetime => $datetime,
				description => $description,
				link => $link,
			);
		}
		();
	} $data ];
}


with qw(
	Seminar::Extractor::Role::WebScraperExtractable
	Seminar::Extractor::Role::Location::Houston
	Seminar::Extractor::Role::Extraction::DTFmtNatural
);

1;
