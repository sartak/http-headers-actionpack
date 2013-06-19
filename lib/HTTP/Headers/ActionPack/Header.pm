package HTTP::Headers::ActionPack::Header;
# ABSTRACT: A Base class which adds string overloading

use strict;
use warnings;

use overload '""' => 'as_string', fallback => 1;

use Moo;

1;
