use strict;
use Test::More;
use lib qw(./lib ./blib/lib);
use Sisimai;
use Sisimai::Rhost;
use Sisimai::Reason;

my $Package = 'Sisimai::Rhost';
my $Methods = { 'class' => ['match', 'get'], 'object' => [] };

MAKETEST: {
    use_ok $Package;
    can_ok $Package, @{ $Methods->{'class'} };
    is $Package->match, undef;
    is $Package->get, undef;

    for my $e ( glob('./set-of-emails/maildir/bsd/rhost-*.eml') ) {
        my $v = Sisimai->rise($e);
        ok -f $e, $e;
        isa_ok $v, 'ARRAY';

        while( my $f = shift @$v ) {
            isa_ok $f, 'Sisimai::Fact';
            ok length $f->rhost;
            ok length $f->reason;
            my $cx = $f->damn;

            if( $Package->match($cx->{'rhost'}) ) {
                # Get the reason by only the value of "rhost"
                is $Package->get($cx), $f->reason, sprintf("->reason = %s", $f->reason);

            } else {
                # Get the reason by the values of "rhost" and "desctination"
                ok length $cx->{'destination'};
                is $Package->get($cx, $cx->{'destination'}), $f->reason, sprintf("->reason = %s", $f->reason);
            }
        }
    }
}

done_testing;

