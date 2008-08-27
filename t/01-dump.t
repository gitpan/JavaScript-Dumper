use Test::More tests => 8;
use JavaScript::Dumper;

use warnings;
use strict;

my $js = js_dumper({var7 => undef, var6 => \1, var1 => "test", var2 => 1234, var5 => "1234", var3 => \1, var4 => \"function"});

like($js, qr/"var3":true/);
like($js, qr/"var1":"test"/);
like($js, qr/"var4":function/);
like($js, qr/"var2":1234/);
like($js, qr/"var5":1234/);
like($js, qr/"var6":true/);
like($js, qr/"var7":null/);

like($js, qr/^\{.*\}$/);
diag( "Testing for correct Dumping" );



