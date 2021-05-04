use strict;
use warnings;
use Test::More;
use lib qw(./lib ./blib/lib);
require './t/600-lhost-code';

my $enginename = 'RFC3834';
my $enginetest = Sisimai::Lhost::Code->makeinquiry;
my $isexpected = {
    # INDEX => [['D.S.N.', 'replycode', 'REASON', 'hardbounce'], [...]]
    '01' => [['', '', 'vacation', 0]],
    '02' => [['', '', 'vacation', 0]],
    '03' => [['', '', 'vacation', 0]],
    '04' => [['', '', 'vacation', 0]],
};

$enginetest->($enginename, $isexpected);
done_testing;

