package Seminar::Extractor::Util;

use IPC::Run3;
use Encode qw(decode_utf8);

use strict;
use warnings;

sub pdftotext {
        my ($self, $data) = @_;
        my ($in, $out);
        $in .= $data;
        my @cmd = ( 'pdftotext', '-', '-' );
        run3 \@cmd, \$in, \$out, \undef or die "pdftotext: $?";
	$out = decode_utf8 $out;
        return $out;
}


1;
