package Sisimai::Reason::VirusDetected;
use feature ':5.10';
use strict;
use warnings;

sub text  { 'virusdetected' }
sub description { 'Email rejected due to a virus scanner on a destination host' }
sub match {
    # Try to match that the given text and regular expressions
    # @param    [String] argv1  String to be matched with regular expressions
    # @return   [Integer]       0: Did not match
    #                           1: Matched
    # @since v4.0.0
    my $class = shift;
    my $argv1 = shift // return undef;
    my $regex = qr/
         the[ ]message[ ]was[ ]rejected[ ]because[ ]it[ ]contains[ ]prohibited[ ]virus[ ]or[ ]spam[ ]content
    /ix;

    return 1 if $argv1 =~ $regex;
    return 0;
}

sub true {
    # The bounce reason is security error or not
    # @param    [Sisimai::Data] argvs   Object to be detected the reason
    # @return   [Integer]               1: is security error
    #                                   0: is not security error
    # @see http://www.ietf.org/rfc/rfc2822.txt
    return undef;
}

1;
__END__

=encoding utf-8

=head1 NAME

Sisimai::Reason::VirusDetected - Bounce reason is C<securityerror> or not.

=head1 SYNOPSIS

    use Sisimai::Reason::VirusDetected;
    print Sisimai::Reason::VirusDetected->match('5.7.1 Email not accept');   # 1

=head1 DESCRIPTION

Sisimai::Reason::VirusDetected checks the bounce reason is C<securityerror> or 
not. This class is called only Sisimai::Reason class.

This is the error that a security violation was detected on a destination mail 
server. Depends on the security policy on the server, there is any virus in the
email, a sender's email address is camouflaged address. Sisimai will set
C<securityerror> to the reason of email bounce if the value of Status: field in
a bounce email is C<5.7.*>.

    Status: 5.7.0
    Remote-MTA: DNS; gmail-smtp-in.l.google.com
    Diagnostic-Code: SMTP; 552-5.7.0 Our system detected an illegal attachment on your message. Please

=head1 CLASS METHODS

=head2 C<B<text()>>

C<text()> returns string: C<securityerror>.

    print Sisimai::Reason::VirusDetected->text;  # securityerror

=head2 C<B<match(I<string>)>>

C<match()> returns 1 if the argument matched with patterns defined in this class.

    print Sisimai::Reason::VirusDetected->match('5.7.1 Email not accept');   # 1

=head2 C<B<true(I<Sisimai::Data>)>>

C<true()> returns 1 if the bounce reason is C<securityerror>. The argument must be
Sisimai::Data object and this method is called only from Sisimai::Reason class.

=head1 AUTHOR

azumakuniyuki

=head1 COPYRIGHT

Copyright (C) 2017 azumakuniyuki, All rights reserved.

=head1 LICENSE

This software is distributed under The BSD 2-Clause License.

=cut