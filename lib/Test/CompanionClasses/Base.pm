package Test::CompanionClasses::Base;

# $Id: Test.pm 11960 2006-08-10 14:42:20Z gr $

use strict;
use warnings;
use Test::More;
use UNIVERSAL::require;

our $VERSION = '0.01';


use base qw(
    Class::Accessor::Complex
    Data::Inherited
);


__PACKAGE__
    ->mk_new
    ->mk_scalar_accessors(qw(package));


use constant PLAN => 0;    # default


sub make_real_object {
    my $self = shift;
    $self->package->require;
    die $@ if $@;
    $self->package->new;
}


sub run {
    my $self = shift;
    printf "# BEGIN %s\n", $self->package;
}


# this can be called as a class method as well

sub planned_test_count {
    my $self = shift;
    my $plan = 0;
    $plan += $_ for $self->every_list('PLAN');
    $plan;
}


1;


__END__

=head1 NAME

Test::CompanionClasses::Base - base class for test companion classes

=head1 SYNOPSIS

    package My::Foo_TEST;

    use warnings;
    use strict;

    use base 'Test::CompanionClasses::Base';

    use constant PLAN => 5;

    sub run {
        my $self = shift;
        $self->SUPER::run(@_);
        is_deeply(...);
        ...
    }

=head1 DESCRIPTION

Base class for test companion classes. Each test companion class should
inherit from this class.

=head1 METHODS

=over 4

=item new

A constructor per L<Class::Accessor::Complex>'s C<mk_new()>.

=item package

Automatically set; holds the package name of the class you are testing. If
your test companion class is called C<My::Foo_TEST>, then C<package()> will
return C<My::Foo>.

An accessor per L<Class::Accessor::Complex>'s C<mk_scalar_accessor()>.

=item PLAN

A constant that says how many tests this particular class defines. Real test
companion classes (i.e., subclasses of this class) will want to redefine it
like this:

    use constant PLAN => 5;

Note that you should only specify how many tests the current class runs; test
counts of superclasses are automatically taken care of.

=item planned_test_count

Uses C<PLAN()>, calculated over the test companion class' whole class
hierarchy, to determine how many tests will be run in total.

=item make_real_object

Loads the actual class being tested (cf. C<package()>) and returns an object
of this class (constructed by calling C<new()> on it).

In your test companion class you will want to test certain assumptions about
your real class, so this method will be useful.

=item run

Test companion classes should override this method and run their tests. Be
sure to call C<SUPER::run(@_)> so that all tests over the class hierarchy are
run.

The C<run()> method in this base class just prints a line informing the test
user that tests for this particular companion class have begun. If you have
several companion classes - and you probably will or you won't have been using
C<Test::CompanionClasses> - this serves as a visual distinction of where on
companion class' tests end the next ones' begin.

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

