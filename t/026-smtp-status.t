use strict;
use Test::More;
use lib qw(./lib ./blib/lib);
use Sisimai::SMTP::Status;

my $Package = 'Sisimai::SMTP::Status';
my $Methods = {
    'class'  => ['code', 'name', 'find'],
    'object' => [],
};

use_ok $Package;
can_ok $Package, @{ $Methods->{'class'} };

MAKETEST: {
    my $reasonlist = [
        'blocked', 'contenterror', 'exceedlimit', 'expired', 'filtered', 'hasmoved',
        'hostunknown', 'mailboxfull', 'mailererror', 'mesgtoobig', 'networkerror',
        'norelaying', 'notaccept', 'onhold', 'rejected', 'securityerror', 'spamdetected',
        'suspend', 'systemerror', 'systemfull', 'toomanyconn', 'userunknown', 'syntaxerror',
    ];
    my $statuslist = [ qw/
        2.1.5
        4.1.6 4.1.7 4.1.8 4.1.9 4.2.1 4.2.2 4.2.3 4.2.4 4.3.1 4.3.2 4.3.3 4.3.5
        4.4.1 4.4.2 4.4.4 4.4.5 4.4.6 4.4.7 4.5.3 4.5.5 4.6.0 4.6.2 4.6.5
        4.7.1 4.7.2 4.7.5 4.7.6 4.7.7
        5.1.0 5.1.1 5.1.2 5.1.3 5.1.4 5.1.6 5.1.7 5.1.8 5.1.9 5.2.0 5.2.1 5.2.2
        5.2.3 5.2.4 5.3.0 5.3.1 5.3.2 5.3.3 5.3.4 5.3.5 5.4.0 5.4.3 5.5.3 5.5.4
        5.5.5 5.5.6 5.6.0 5.6.1 5.6.2 5.6.3 5.6.5 5.6.6 5.6.7 5.6.8 5.6.9 5.7.0
        5.7.1 5.7.2 5.7.3 5.7.4 5.7.5 5.7.6 5.7.7 5.7.8 5.7.9
    / ];
    my $smtperrors = [
        'smtp; 2.1.5 250 OK',
        'smtp;550 5.2.2 <mikeneko@example.co.jp>... Mailbox Full',
        'smtp; 550 5.1.1 Mailbox does not exist',
        'smtp; 550 5.1.1 Mailbox does not exist',
        'smtp; 450 4.0.0 Temporary failure',
        'smtp; 552 5.2.2 Mailbox full',
        'smtp; 552 5.3.4 Message too large',
        'smtp; 500 5.6.1 Message content rejected',
        'smtp; 550 5.2.0 Message Filtered',
        '550 5.1.1 <kijitora@example.jp>... User Unknown',
        'SMTP; 552-5.7.0 This message was blocked because its content presents a potential',
        'SMTP; 550 5.1.1 Requested action not taken: mailbox unavailable',
        'SMTP; 550 5.7.1 IP address blacklisted by recipient',
    ];
    my $v = '';

    is $Package->code(''), undef, '->code() = undef';
    PSEUDO_STATUS_CODE: for my $e ( @$reasonlist ) {
        $v = $Package->code($e);
        like $v, qr/\A5[.]\d[.]9\d+/, 'pseudo status code('.$e.') = '.$v;

        $v = $Package->code($e, 1);
        like $v, qr/\A[45][.]\d[.]9\d+/, 'pseudo status code('.$e.',1) = '.$v;
    }

    is $Package->name(''), undef, '->name() = undef';
    STANRDARD_STATUS_CODE: for my $e ( @$statuslist ) {
        $v = $Package->name($e);
        if( $v eq 'delivered' ) {
            is $v, 'delivered', '->name('.$e.') returns delivered';

        } else {
            ok grep({ $v eq $_ } @$reasonlist), '->name('.$e.') returns '.$v;
        }
    }

    is $Package->find(''), undef, '->find("") = undef';
    for my $e ( @$smtperrors ) {
        $v = $Package->find($e);
        like $v, qr/\A[245][.]\d[.]\d\z/, '->find() returns '.$v;
    }
}

done_testing;
