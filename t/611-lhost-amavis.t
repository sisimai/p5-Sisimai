use strict;
use warnings;
use Test::More;
use lib qw(./lib ./blib/lib);
require './t/600-lhost-code';

my $enginename = 'Amavis';
my $enginetest = Sisimai::Lhost::Code->makeinquiry;
my $isexpected = {
    # INDEX => [['D.S.N.', 'replycode', 'REASON', 'hardbounce'], [...]]
    '01' => [['5.1.1',   '550', 'userunknown',     1]],
    '02' => [['5.1.1',   '550', 'userunknown',     1]],
    '03' => [['5.7.0',   '554', 'spamdetected',    0]],
};

$enginetest->($enginename, $isexpected);
done_testing;

