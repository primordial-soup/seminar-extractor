use Test::Most tests => 4;

BEGIN { use_ok( 'Seminar::Config' ); }
require_ok( 'Seminar::Config' );


ok(Seminar::Config->instance, 'create config singleton');

isa_ok( Seminar::Config->instance->mechanize, 'WWW::Mechanize' );


done_testing;

