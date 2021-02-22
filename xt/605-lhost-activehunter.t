use strict;
use warnings;
use Test::More;
use lib qw(./lib ./blib/lib);
require './t/600-lhost-code';

my $enginename = 'Activehunter';
my $samplepath = sprintf("./set-of-emails/private/lhost-%s", lc $enginename);
my $enginetest = Sisimai::Lhost::Code->maketest;
my $isexpected = [
    { 'n' => '01001', 'r' => qr/filtered/    },
    { 'n' => '01002', 'r' => qr/userunknown/ },
    { 'n' => '01003', 'r' => qr/filtered/    },
    { 'n' => '01004', 'r' => qr/filtered/    },
    { 'n' => '01005', 'r' => qr/userunknown/ },
    { 'n' => '01006', 'r' => qr/userunknown/ },
    { 'n' => '01007', 'r' => qr/filtered/    },
    { 'n' => '01008', 'r' => qr/filtered/    },
    { 'n' => '01009', 'r' => qr/userunknown/ },
    { 'n' => '01010', 'r' => qr/filtered/    },
    { 'n' => '01011', 'r' => qr/filtered/    },
    { 'n' => '01012', 'r' => qr/userunknown/ },
];

plan 'skip_all', sprintf("%s not found", $samplepath) unless -d $samplepath;
$enginetest->($enginename, $isexpected, 1, 0);
done_testing;
