package Test::CompanionClasses::Engine;

# $Id: Tester.pm 12658 2007-03-01 13:03:53Z gr $

use warnings;
use strict;
use FindBin '$Bin';
use File::Find;
use Test::More;
use UNIVERSAL::require;


our $VERSION = '0.01';


use base 'Class::Accessor::Complex';


__PACKAGE__->mk_new;


sub run_tests {
    my ($self, %args) = @_;

    our $package_filter =
        join '|' =>
        map { "\Q$_\E" }
        @{ $args{filter} || [] };
    $package_filter = "^($package_filter)\$" if $args{exact};

    # default uses lib/ one level up, as the program using this class usually
    # lives in t/

    my $lib = $args{lib} || "$Bin/../lib";

    my @test_packages =
        map {
                { real_package => $_,
                  test_package => $_ . '_TEST',
                }
            }
        grep { $package_filter ? m/$package_filter/ : 1 }
        @{ $args{inherited} || [] };

    find(sub {
        return unless -f && /_TEST\.pm$/;

        my $test_package;
        if ($File::Find::name =~ m!\Q$lib\E/(.*_TEST)\.pm$!) {
            ($test_package = $1) =~ s!/!::!g;
        } else {
            die "can't determine package from filename [$File::Find::name]";
        }

        (my $real_package = $test_package) =~ s/_TEST$//;
        return if $package_filter && ($real_package !~ $package_filter);
        push @test_packages =>
            {
                real_package => $real_package,
                test_package => $test_package,
            };
    }, $lib);

    my $plan = 0;    # so plan() doesn't complain on an undef number

    for (@test_packages) {
        $_->{test_package}->require;
        die $@ if $@;
        my $package_plan = $_->{test_package}->planned_test_count;
        if ($package_plan == 0) {
            die sprintf "test package [%s] didn't plan any tests",
                $_->{test_package};
        }
        $_->{plan} = $package_plan;
        $plan += $package_plan;
    }
    plan tests => $plan;

    my @error;
    for (@test_packages) {
        my $current_test_before = Test::More->builder->current_test;
        printf "# %s plans %d test%s\n",
           $_->{test_package}, $_->{plan}, ($_->{plan} == 1 ? '' : 's');

        # FIXME: Because of a bug in PPI, a hash key with the name 'package'
        # is seen as a package statement. Bug report filed. Until then, use
        # quotes.

        $_->{test_package}->new('package' => $_->{real_package})->run;
        my $count_tests_performed =
            Test::More->builder->current_test - $current_test_before;
        if ($count_tests_performed != $_->{plan}) {
            my $error =
                sprintf "# Looks like %s planned %d tests but ran %d.\n",
                    $_->{test_package}, $_->{plan}, $count_tests_performed;
            print $error;
            push @error => $error;
        }
    }

    print @error if @error;
}


1;


__END__

=head1 NAME

Test::CompanionClasses::Engine - run tests defined in companion classes

=head1 SYNOPSIS

    use Test::CompanionClasses;
    Test::CompanionClasses->new->run_tests(...);

=head1 DESCRIPTION

This is the core of C<Test::CompanionClasses>.

=head1 METHODS

=over 4

=item new

A constructor per L<Class::Accessor::Complex>'s C<mk_new()>.

=item run_tests

Actually runs the companion class tests.

Takes named arguments (as a hash). Recognized keys are:

=over 4

=item filter

A reference to a list of strings that are interpreted as package filters. A
companion test class is only run if the corresponding real class' package name
matches this filter list.

=item exact

Works with C<filter>. If this boolean flag is set, the real class name must
match exactly, otherwise a substring match is sufficient.

Examples:

    Test::CompanionClasses->mk_new->run_tests(
        filter => [ qw/Foo::Bar Baz/ ]
    );

will run the companion tests of C<Foo::Bar>, C<Baz> but also
C<Foo::Bar::Flurble>, C<Bazzzz> etc.

    Test::CompanionClasses->mk_new->run_tests(
        filter => [ qw/Foo::Bar Baz/ ]
        exact  => 1,
    );

will only run the companion tests of C<Foo::Bar> and C<Baz>.

=item lib

Sets the directory in and under which C<run_tests()> is looking for test
companion classes. Defaults to C<$Bin/../lib>, where C<$Bin> is the location
of the program as determined by L<FindBin>. This default is used because
normally companion class tests will be run from a perl distribution's C<t/>
directory.

=item inherited

You can also specify that other classes not found in C<lib> should be tested.
Use a reference to an array of class names as the value for C<inherited> and
those classes' companion tests will be run as well. The class names still have
to match the C<filter>, if one was specified.

This is useful if your distribution depends on another one which also has
defined test companion classes. If your distribution changes the way these
other test companion classes are working, you can inherit those tests to see
whether they still work with your distribution.

=back

The method looks for test companion classes in C<lib> and via C<inherited>,
loads them, asks them for their plan, that is,  how many tests they want
to run, then runs them.

=back

=head1 TAGS

If you talk about this module in blogs, on del.icio.us or anywhere else,
please use the C<testcompanionclasses> tag.

=head1 BUGS AND LIMITATIONS

No bugs have been reported.

Please report any bugs or feature requests to
C<bug-test-companionclasses@rt.cpan.org>, or through the web interface at
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

Copyright 2007 by Marcel GrE<uuml>nauer

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

