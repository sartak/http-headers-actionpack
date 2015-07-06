package HTTP::Headers::ActionPack::Role::Header;
# ABSTRACT: A Base class

use strict;
use warnings;

our $VERSION = '0.10';

use Moo::Role 2;

requires 'as_string';

use overload q{""} => 'as_string', fallback => 1;

1;
