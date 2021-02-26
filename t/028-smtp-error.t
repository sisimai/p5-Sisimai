use strict;
use Test::More;
use lib qw(./lib ./blib/lib);
use Sisimai::SMTP::Error;

my $Package = 'Sisimai::SMTP::Error';
my $Methods = { 'class' => ['is_permanent', 'soft_or_hard'], 'object' => [] };

use_ok $Package;
can_ok $Package, @{ $Methods->{'class'} };

MAKETEST: {
    my $softbounces = [
        'blocked', 'contenterror', 'exceedlimit', 'expired', 'filtered',
        'mailboxfull', 'mailererror', 'mesgtoobig', 'networkerror',
        'norelaying', 'rejected', 'securityerror',
        'spamdetected', 'suspend', 'systemerror', 'systemfull', 'toomanyconn',
        'undefined', 'onhold',
    ];
    my $hardbounces = ['userunknown', 'hostunknown', 'hasmoved', 'notaccept'];
    my $isntbounces = ['delivered', 'feedback', 'vacation'];

    my $isnterrors = [
        'smtp; 2.1.5 250 OK',
    ];
    my $temperrors = [
        'smtp; 450 4.0.0 Temporary failure',
    ];
    my $permerrors = [
        'smtp;550 5.2.2 <mikeneko@example.co.jp>... Mailbox Full',
        'smtp; 550 5.1.1 Mailbox does not exist',
        'smtp; 550 5.1.1 Mailbox does not exist',
        'smtp; 552 5.2.2 Mailbox full',
        'smtp; 552 5.3.4 Message too large',
        'smtp; 500 5.6.1 Message content rejected',
        'smtp; 550 5.2.0 Message Filtered',
        '550 5.1.1 <kijitora@example.jp>... User Unknown',
        'SMTP; 552-5.7.0 This message was blocked because its content presents a potential',
        'SMTP; 550 5.1.1 Requested action not taken: mailbox unavailable',
        'SMTP; 550 5.7.1 IP address blacklisted by recipient',
    ];
    my $v = undef;

    is $Package->is_permanent(), undef;
    for my $e ( @$isnterrors ) {
        $v = $Package->is_permanent($e);
        is $v, undef, '->is_permanent('.$e.') = undef';
    }

    for my $e ( @$temperrors ) {
        $v = $Package->is_permanent($e);
        is $v, 0, '->is_permanent('.$e.') = 0';
    }

    for my $e ( @$permerrors ) {
        $v = $Package->is_permanent($e);
        is $v, 1, '->is_permanent('.$e.') = 1';
    }

    is $Package->soft_or_hard(), undef;
    is $Package->soft_or_hard('neko'), '';
    for my $e ( @$softbounces ) {
        $v = $Package->soft_or_hard($e);
        is $v, 'soft', '->soft_or_hard('.$e.') = soft';
    }
    for my $e ( @$hardbounces ) {
        $v = $Package->soft_or_hard($e);
        is $v, 'hard', '->soft_or_hard('.$e.') = hard';

        if( $e eq 'notaccept' ) {
            $v = $Package->soft_or_hard($e, '503 Not accept any email');
            is $v, 'hard', '->soft_or_hard('.$e.') = hard';

            $v = $Package->soft_or_hard($e, '409 Not accept any email');
            is $v, 'soft', '->soft_or_hard('.$e.') = soft';
        }
    }
    for my $e ( @$isntbounces ) {
        $v = $Package->soft_or_hard($e);
        is $v, '', '->soft_or_hard('.$e.') = ""';
    }
}

done_testing;

