use inc::Module::Install;
name 'Test-CompanionClasses';
all_from 'lib/Test/CompanionClasses.pm';
perl_version '5.006';

requires 'Class::Accessor::Complex';
requires 'UNIVERSAL::require';

build_requires 'Test::More' => '0.70';

use_standard_tests(without => 'pod_coverage');
auto_include;
WriteAll;
