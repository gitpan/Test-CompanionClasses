package Test::CompanionClasses::Base;

# $Id: Test.pm 11960 2006-08-10 14:42:20Z gr $

use strict;
use warnings;
use Test::More;
use UNIVERSAL::require;


our $VERSION = '0.04';


use base qw(
    Class::Accessor::Complex
    Data::Inherited
);


__PACKAGE__
    ->mk_new
    ->mk_scalar_accessors(qw(package));


use constant PLAN => 0;    # default


sub make_real_object {
    my ($self, @args) = @_;
    $self->package->require;
    die $@ if $@;
    $self->package->new(@args);
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

The package() property is automatically set; it holds the package name of the
class you are testing. If your test companion class is called C<My::Foo_TEST>,
then C<package()> will return C<My::Foo>.

=head1 METHODS

=over 4

=item new

    my $obj = Test::CompanionClasses::Base->new;
    my $obj = Test::CompanionClasses::Base->new(%args);

Creates and returns a new object. The constructor will accept as arguments a
list of pairs, from component name to initial value. For each pair, the named
component is initialized by calling the method of the same name with the given
value. If called with a single hash reference, it is dereferenced and its
key/value pairs are set as described before.

=item clear_package

    $obj->clear_package;

Clears the value.

=item package

    my $value = $obj->package;
    $obj->package($value);

A basic getter/setter method. If called without an argument, it returns the
value. If called with a single argument, it sets the value.

=item package_clear

    $obj->package_clear;

Clears the value.

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

Test::CompanionClasses::Base inherits from L<Class::Accessor::Complex> and
L<Data::Inherited>.

The superclass L<Class::Accessor::Complex> defines these methods and
functions:

    mk_abstract_accessors(), mk_array_accessors(), mk_boolean_accessors(),
    mk_class_array_accessors(), mk_class_hash_accessors(),
    mk_class_scalar_accessors(), mk_concat_accessors(),
    mk_forward_accessors(), mk_hash_accessors(), mk_integer_accessors(),
    mk_new(), mk_object_accessors(), mk_scalar_accessors(),
    mk_set_accessors(), mk_singleton()

The superclass L<Class::Accessor> defines these methods and functions:

    _carp(), _croak(), _mk_accessors(), accessor_name_for(),
    best_practice_accessor_name_for(), best_practice_mutator_name_for(),
    follow_best_practice(), get(), make_accessor(), make_ro_accessor(),
    make_wo_accessor(), mk_accessors(), mk_ro_accessors(),
    mk_wo_accessors(), mutator_name_for(), set()

The superclass L<Class::Accessor::Installer> defines these methods and
functions:

    install_accessor()

The superclass L<Data::Inherited> defines these methods and functions:

    every_hash(), every_list(), flush_every_cache_by_key()

=head1 TAGS

If you talk about this module in blogs, on del.icio.us or anywhere else,
please use the C<testcompanionclasses> tag.

=head1 VERSION 
                   
This document describes version 0.04 of L<Test::CompanionClasses::Base>.

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

