use Test::Most tests => 4;

BEGIN { use_ok( 'Seminar::Extractor::Config' ); }
require_ok( 'Seminar::Extractor::Config' );


ok(Seminar::Extractor::Config->instance, 'create config singleton');

isa_ok( Seminar::Extractor::Config->instance->mechanize, 'WWW::Mechanize' );


done_testing;

