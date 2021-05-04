use strict;
use Test::More;
use lib qw(./lib ./blib/lib);
use Sisimai::Message;

my $Package = 'Sisimai::Message';
my $Methods = { 'class'  => ['rise', 'load', 'parse', 'divideup', 'makemap'] };
my $Mailbox = './set-of-emails/mailbox/mbox-0';

use_ok $Package;
can_ok $Package, @{ $Methods->{'class'} };

MAKETEST: {
    use IO::File;
    my $filehandle = IO::File->new($Mailbox, 'r');
    my $mailastext = '';
    my $tobeloaded = $Package->load;
    my $callbackto = sub {
        my $argvs = shift;
        my $catch = { 
            'x-mailer' => '',
            'return-path' => '',
        };
        $catch->{'from'} = $argvs->{'headers'}->{'from'} || '';
        $catch->{'x-mailer'}    = $1 if $argvs->{'message'} =~ m/^X-Mailer:\s*(.*)$/m;
        $catch->{'return-path'} = $1 if $argvs->{'message'} =~ m/^Return-Path:\s*(.+)$/m;
        return $catch;
    };

    while( my $r = <$filehandle> ) {
        $mailastext .= $r;
    }
    $filehandle->close;

    isa_ok $tobeloaded, 'ARRAY';
    ok length $mailastext;

    my $p = Sisimai::Message->rise({ 'data' => $mailastext });

    isa_ok $p, 'HASH';
    isa_ok $p->{'header'}, 'HASH', '->header';
    isa_ok $p->{'ds'}, 'ARRAY', '->ds';
    isa_ok $p->{'rfc822'}, 'HASH', '->rfc822';
    ok length $p->{'from'}, $p->{'from'};

    $p = Sisimai::Message->rise({
            'data' => $mailastext, 
            'hook' => $callbackto,
            'order' => [
                'Sisimai::Lhost::Sendmail', 'Sisimai::Lhost::Postfix', 
                'Sisimai::Lhost::qmail', 'Sisimai::Lhost::Exchange2003', 
                'Sisimai::Lhost::Gmail', 'Sisimai::Lhost::Verizon',
            ]
        });

    for my $e ( @{ $p->{'ds'} } ) {
        is $e->{'spec'}, 'SMTP', '->spec = SMTP';
        like $e->{'recipient'}, qr/[@]/, '->recipient = '.$e->{'recipient'};
        like $e->{'status'}, qr/\d[.]\d[.]\d+/, '->status = '.$e->{'status'};
        ok exists $e->{'command'}, '->command = '.$e->{'command'};
        like $e->{'date'}, qr/\d{4}/, '->date = '.$e->{'date'};
        ok length $e->{'diagnosis'}, '->diagnosis = '.$e->{'diagnosis'};
        ok length $e->{'action'}, '->action = '.$e->{'action'};
        ok length $e->{'rhost'}, '->rhost = '.$e->{'rhost'};
        ok length $e->{'lhost'}, '->lhost = '.$e->{'lhost'};

        for my $q ( 'rhost', 'lhost' ) {
            next unless $e->{ $q };
            like $e->{ $q }, qr/\A.+[.].+\z/, '->'.$q.' = '.$e->{ $q };
        }
        is $e->{'agent'}, 'Sendmail', '->agent = '.$e->{'agent'};
    }

    for my $e ( 'content-type', 'to', 'subject', 'date', 'from', 'message-id' ) {
        my $h = $p->{'header'}->{ $e };
        ok length $h, $h;
    }
    isa_ok $p->{'header'}->{'received'}, 'ARRAY';

    for my $e ( qw|return-path to subject date from message-id| ) {
        my $h = $p->{'rfc822'}->{ $e };
        ok length $h, $e;
    }

    isa_ok $p->{'catch'}, 'HASH';
    ok defined $p->{'catch'}->{'x-mailer'};
    ok defined $p->{'catch'}->{'return-path'};
    ok defined $p->{'catch'}->{'from'};
}

done_testing;

