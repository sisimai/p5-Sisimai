use strict;
use warnings;
use Test::More;
use lib qw(./lib ./blib/lib);
require './t/600-lhost-code';

my $enginename = 'Verizon';
my $enginetest = Sisimai::Lhost::Code->makeinquiry;
my $isexpected = {
    # INDEX => [['D.S.N.', 'replycode', 'REASON', 'hardbounce'], [...]]
    '01' => [['5.0.911', '',    'userunknown',     1]],
    '02' => [['5.0.911', '550', 'userunknown',     1]],
};

$enginetest->($enginename, $isexpected);
done_testing;

