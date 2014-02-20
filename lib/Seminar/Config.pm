package Seminar::Config;

use strict;
use warnings;
use Moo;
with 'MooX::Singleton';

use CHI;
use Path::Class;
use File::HomeDir;
use WWW::Mechanize::Cached;

has _app_name => ( is => 'ro', default => sub { 'seminar-extractor' });

has chi => ( is => 'lazy' );

has mechanize => ( is => 'lazy' );

has _cache_dir => (
	is => 'ro',
	default => sub {
		my ($self) = @_;
		my $dir = dir( File::HomeDir->my_home )
			->subdir('.cache', $self->_app_name);
		$dir->mkpath;
		"$dir";
	}
);

sub _build_chi {
	my ($self) = @_;
	CHI->new( driver => 'File', root_dir => $self->_cache_dir );
}

sub _build_mechanize {
	my ($self) = @_;
	WWW::Mechanize::Cached->new( cache => $self->chi );
}

1;
