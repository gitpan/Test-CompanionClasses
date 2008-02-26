package Test::CompanionClasses;

use warnings;
use strict;
use Test::CompanionClasses::Engine;
use Getopt::Long;


use base 'Exporter';


our $VERSION = '0.04';


our @EXPORT = ('run_tests');


sub run_tests {
    my $exact;
    GetOptions(exact => \$exact) or
        die "usage: $0 [ --exact ] filter...\n";

    Test::CompanionClasses::Engine->new->run_tests(
        exact     => $exact,
        filter    => [ @main::ARGV ],
        # inherited => [ $inherited_spec ],
    );
}



__END__



=head1 NAME

Test::CompanionClasses - basic invocation of Test::CompanionClasses::Engine

=head1 SYNOPSIS

Define a test file, for example C<t/01_companion_classes.t>:

    use Test::CompanionClasses;
    run_tests;

Then you can do:

    perl t/01_companion_classes.t --exact Foo::Bar Baz

=head1 DESCRIPTION

This is a very basic frontend for L<Test::CompanionClasses::Engine> which you
can use for your distribution test files (in C<t/>).

The intention is that you use it as shown in the L</SYNOPSIS>.

=head1 COMMAND-LINE USAGE

The following command-line arguments are supported:

=over 4

=item --exact

Specifies that the package filter is to be used exactly, i.e., substring
matching is not enough. See L<Test::CompanionClasses::Engine> for details.

=back

The rest of the command line is interpreted as a list of package filters.
Again, see L<Test::CompanionClasses::Engine> for details.

The C<inherited> mechanism is not supported (yet).

=head1 TAGS

If you talk about this module in blogs, on del.icio.us or anywhere else,
please use the C<testcompanionclasses> tag.

=head1 VERSION 
                   
This document describes version 0.04 of L<Test::CompanionClasses>.

=head1 BUGS AND LIMITATIONS

No bugs have been reported.

Please report any bugs or feature requests to
C<<bug-test-companionclasses@rt.cpan.org>>, or through the web interface at
L<http://rt.cpan.org>.

=head1 INSTALLATION

See perlmodinstall for information and options on installing Perl modules.

=head1 AVAILABILITY

The latest version of this module is available from the Comprehensive Perl
Archive Network (CPAN). Visit <http://www.perl.com/CPAN/> to find a CPAN
site near you. Or see <http://www.perl.com/CPAN/authors/id/M/MA/MARCEL/>.

=head1 AUTHOR

Marcel GrE<uuml>nauer, C<< <marcel@cpan.org> >>

=head1 COPYRIGHT AND LICENSE

Copyright 2007-2008 by Marcel GrE<uuml>nauer

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.


=cut

