
use strict;
use warnings;

 BEGIN { require 5.008; } 

use ExtUtils::MakeMaker 6.11;



my %WriteMakefileArgs = (
                       'test' => {
                                   'TESTS' => 't/*.t'
                                 },
                       'NAME' => 'Test::CompanionClasses',
                       'DISTNAME' => 'Test-CompanionClasses',
                       'CONFIGURE_REQUIRES' => {
                                                 'ExtUtils::MakeMaker' => '6.11'
                                               },
                       'AUTHOR' => 'Marcel Gruenauer <marcel@cpan.org>',
                       'BUILD_REQUIRES' => {},
                       'ABSTRACT' => 'Basic invocation of the test companion class engine',
                       'EXE_FILES' => [],
                       'VERSION' => '1.100870',
                       'PREREQ_PM' => {
                                        'Class::Accessor::Complex' => '0',
                                        'Getopt::Long' => '0',
                                        'Scalar::Util' => '0',
                                        'English' => '0',
                                        'parent' => '0',
                                        'FindBin' => '0',
                                        'constant' => '0',
                                        'Exporter' => '0',
                                        'Carp' => '0',
                                        'Test::More' => '0.88',
                                        'File::Find' => '0',
                                        'File::Temp' => '0',
                                        'UNIVERSAL::require' => '0',
                                        'Data::Inherited' => '0'
                                      },
                       'LICENSE' => 'perl'
                     );


delete $WriteMakefileArgs{LICENSE}
  unless eval { ExtUtils::MakeMaker->VERSION(6.31) };

WriteMakefile(%WriteMakefileArgs);



