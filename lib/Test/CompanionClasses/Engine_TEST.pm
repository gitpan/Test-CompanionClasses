package Test::CompanionClasses::Engine_TEST;
use warnings;
use strict;
use Test::More;
our $VERSION = '0.05';
use base 'Test::CompanionClasses::Base';
use constant PLAN => 1;

sub run {
    my $self = shift;
    $self->SUPER::run(@_);
    my $o = $self->make_real_object;
    can_ok($o, qw(new run_tests));
}
1;
__END__



=head1 NAME

Test::CompanionClasses::Engine_TEST - a test companion class

=head1 SYNOPSIS

    # None; this is part of C<Test::CompanionClasses> tests.

=head1 DESCRIPTION

Test companion class that is used to perform very basic tests on
L<Test::CompanionClasses> itself.

=head1 METHODS

=over 4

=item C<run>

Creates an object of its associated implementation class and checks that that
object C<can()> run C<new()> and C<run_tests()> methods.

=back

=head1 BUGS AND LIMITATIONS

No bugs have been reported.

Please report any bugs or feature requests through the web interface at
L<http://rt.cpan.org>.

=head1 INSTALLATION

See perlmodinstall for information and options on installing Perl modules.

=head1 AVAILABILITY

The latest version of this module is available from the Comprehensive Perl
Archive Network (CPAN). Visit <http://www.perl.com/CPAN/> to find a CPAN
site near you. Or see L<http://search.cpan.org/dist/Test-CompanionClasses/>.

The development version lives at
L<http://github.com/hanekomu/test-companionclasses>. Instead of sending
patches, please fork this project using the standard git and github
infrastructure.

=head1 AUTHOR

Marcel GrE<uuml>nauer, C<< <marcel@cpan.org> >>

=head1 COPYRIGHT AND LICENSE

Copyright 2007-2009 by Marcel GrE<uuml>nauer.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
