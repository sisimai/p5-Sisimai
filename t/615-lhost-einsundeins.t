use strict;
use warnings;
use Test::More;
use lib qw(./lib ./blib/lib);
require './t/600-lhost-code';

my $enginename = 'EinsUndEins';
my $enginetest = Sisimai::Lhost::Code->maketest;
my $isexpected = [
    { 'n' => '02', 's' => qr/\A5[.]0[.]\d+\z/, 'r' => qr/mesgtoobig/, 'b' => qr/\A1\z/ },
    { 'n' => '03', 's' => qr/\A5[.]2[.]0\z/,   'r' => qr/spamdetected/, 'b' => qr/\A1\z/ },
];

$enginetest->($enginename, $isexpected);
done_testing;

