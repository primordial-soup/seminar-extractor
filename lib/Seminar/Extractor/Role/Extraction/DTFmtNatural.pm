package Seminar::Extractor::Role::Extraction::DTFmtNatural;

use strict;
use warnings;

use DateTime::Format::Natural;
use Data::Rmap qw(rmap rmap_hash);
use HTML::FormatText;

use Moo::Role;

requires '_tz';
requires '_dt_fmt_natural_time_format';

has _dt_parser => (
	is => 'lazy',
	builder => sub {
		my ($self) = @_;
		DateTime::Format::Natural->new(
				lang => 'en',
				format => $self->_dt_fmt_natural_time_format,
				time_zone => $self->_tz
			);
	},
);

sub _dt_fmt_natural_extract {
	my ($self, $data) = @_;
	rmap_hash {
		my $hash = $_;
		if( defined $_ and exists $_->{time}  ) {
			my $text = HTML::FormatText->format_string( $_->{time} );
			my $substring = $self->_dt_parser->extract_datetime( $text );

			#$hash->{datetime_text} = $text; #DEBUG
			#$hash->{datetime_text_sub} = $substring; #DEBUG
			my $dt = $self->_dt_parser->parse_datetime( $substring );
			$hash->{datetime} = $dt;
		}
	} $data;
	$data;
}


1;
