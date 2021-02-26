use strict;
use Test::More;
use lib qw(./lib ./blib/lib);
use Sisimai::String;

my $Package = 'Sisimai::String';
my $Methods = {
    'class'  => ['token', 'is_8bit', 'sweep', 'to_plain', 'to_utf8'],
    'object' => [],
};

use_ok $Package;
can_ok $Package, @{ $Methods->{'class'} };

MAKETEST: {
    my $s = 'envelope-sender@example.jp';
    my $r = 'envelope-recipient@example.org';
    my $t = '239aa35547613b2fa94f40c7f35f4394e99fdd88';

    ok(Sisimai::String->token($s, $r, 1), '->token');
    is(Sisimai::String->token($s, $r, 1), $t, '->token = '.$t);
    is(Sisimai::String->token(undef), '', '->token = ""');
    is(Sisimai::String->token($s), '', '->token = ""');
    is(Sisimai::String->token($s, $r), '', '->token = ""');
    ok(Sisimai::String->token($s, $r, 0), '->token');

    is(Sisimai::String->is_8bit(\$s), 0, '->is_8bit = 0');
    is(Sisimai::String->is_8bit(\'日本語'), 1, '->is_8bit = 1');

    is(Sisimai::String->sweep(undef), undef, '->sweep = ""');
    is(Sisimai::String->sweep(' neko cat '), 'neko cat', '->sweep = "neko cat"');
    is(Sisimai::String->sweep(' nyaa   !!'), 'nyaa !!', '->sweep = "nyaa !!"');

    my $h = '
        <html>
        <head>
        </head>
        <body>
            <h1>neko</h1>
            <div>
            <a href = "http://libsisimai.org">Sisimai</a>
            <a href = "mailto:maketest@libsisimai.org">maketest</a>
            </div>
        </body>
        </html>
    ';
    my $p = Sisimai::String->to_plain(\$h);
    ok length $$p;
    ok length $h > length $$p;
    unlike $$p, qr/<html>/, '->to_plain(<html>)';
    unlike $$p, qr/<head>/, '->to_plain(<head>)';
    unlike $$p, qr/<body>/, '->to_plain(<body>)';
    unlike $$p, qr/<div>/, '->to_plain(<div>)';
    like $$p, qr/\bneko\b/, '->to_plain("neko")';
    like $$p, qr/[[]Sisimai[]]/, '->to_plain("[Sisimai]")';
    like $$p, qr/[[]maketest[]]/, '->to_plain("[maketest]")';
    like $$p, qr|[(]http://.+[)]|, '->to_plain("(http://...)")';
    like $$p, qr/[(]mailto:.+[)]/, '->to_plain("(mailto:...)")';

    $p = Sisimai::String->to_plain(\'<body>Nyaan</body>', 1);
    ok length $$p;
    unlike $$p, qr/<body>/, '->to_plain(<body>)';
    like $$p, qr/Nyaan/, '->to_plain("<body>Nyaan</body>")';

    $p = Sisimai::String->to_plain(\'<body>Nyaan</body>', 0);
    ok length $$p;
    like $$p, qr/<body>/, '->to_plain(<body>)';
    like $$p, qr/Nyaan/, '->to_plain("<body>Nyaan</body>")';
}

done_testing;
