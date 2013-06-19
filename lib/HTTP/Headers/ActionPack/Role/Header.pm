package HTTP::Headers::ActionPack::Role::Header;
# ABSTRACT: Role which all headers consume

use strict;
use warnings;

use Moo::Role;

requires 'as_string';

1;
