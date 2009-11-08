package Test::CompanionClasses::Base;
use strict;
use warnings;
use Test::More;
use UNIVERSAL::require;
our $VERSION = '0.06';
use base qw(
  Class::Accessor::Complex
  Data::Inherited
);
#<<<
__PACKAGE__
    ->mk_new
    ->mk_scalar_accessors(qw(package));
#>>>
use constant PLAN => 0;    # default

sub make_real_object {
    my ($self, @args) = @_;
    $self->package->require;
    die $@ if $@;
    $self->package->new(@args);
}

sub run {}

# this can be called as a class method as well
sub planned_test_count {
    my $self = shift;
    my $plan = 0;
    $plan += $_ for $self->every_list('PLAN');
    $plan;
}
1;
__END__

=for test_synopsis
my ($foo, $bar);

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
        is_deeply($foo, $bar, 'some test');
        # ...
    }

=head1 DESCRIPTION

Base class for test companion classes. Each test companion class should
inherit from this class.

The package() property is automatically set; it holds the package name of the
class you are testing. If your test companion class is called C<My::Foo_TEST>,
then C<package()> will return C<My::Foo>.

=head1 METHODS

=over 4

=item C<new>

    my $obj = Test::CompanionClasses::Base->new;
    my $obj = Test::CompanionClasses::Base->new(%args);

Creates and returns a new object. The constructor will accept as arguments a
list of pairs, from component name to initial value. For each pair, the named
component is initialized by calling the method of the same name with the given
value. If called with a single hash reference, it is dereferenced and its
key/value pairs are set as described before.

=item C<clear_package>

    $obj->clear_package;

Clears the value.

=item C<package>

    my $value = $obj->package;
    $obj->package($value);

A basic getter/setter method. If called without an argument, it returns the
value. If called with a single argument, it sets the value.

=item C<package_clear>

    $obj->package_clear;

Clears the value.

=item C<PLAN>

A constant that says how many tests this particular class defines. Real test
companion classes (i.e., subclasses of this class) will want to redefine it
like this:

    use constant PLAN => 5;

Note that you should only specify how many tests the current class runs; test
counts of superclasses are automatically taken care of.

=item C<planned_test_count>

Uses C<PLAN()>, calculated over the test companion class' whole class
hierarchy, to determine how many tests will be run in total.

=item C<make_real_object>

Loads the actual class being tested (see C<package()>) and returns an object
of this class (constructed by calling C<new()> on it).

In your test companion class you will want to test certain assumptions about
your real class, so this method will be useful.

=item C<run>

Test companion classes should override this method and run their tests. Be
sure to call C<SUPER::run(@_)> so that all tests over the class hierarchy are
run.

The C<run()> method in this base class just prints a line informing the test
user that tests for this particular companion class have begun. If you have
several companion classes - and you probably will or you won't have been using
C<Test::CompanionClasses> - this serves as a visual distinction of where on
companion class' tests end the next ones' begin.

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
