#!/usr/bin/perl

use strict;
use warnings;

use Test::More;
use Test::Fatal;

BEGIN {
    use_ok('HTTP::Headers::ActionPack');
}

my $n = HTTP::Headers::ActionPack->new->get_content_negotiator;

isa_ok( $n, 'HTTP::Headers::ActionPack::ContentNegotiation' );

is(
    $n->choose_charset( [], 'ISO-8859-1' ),
    undef,
    '... got nothing back when there are no choices'
);

is(
    $n->choose_charset( [ "UTF-8", "US-ASCII" ], "US-ASCII, UTF-8" ),
    'US-ASCII',
    '... first value in the header wins when priorities are equal'
);

is(
    $n->choose_charset( [ "UTF-8", "US-ASCII" ], "US-ASCII;q=0.7, UTF-8" ),
    'UTF-8',
    '... higher priority charset is chosen over lower'
);

is(
    $n->choose_charset( [ "UTF-8", "US-ASCII", "ISO-8859-1" ], 'ISO-8859-2' ),
    'ISO-8859-1',
    '... got ISO-8859-1 even when it is not explicitly asked for'
);

is(
    $n->choose_charset( [ "UTF-8", "US-ASCII", "ISO-8859-1", "ISO-8859-2" ], 'ISO-8859-2' ),
    'ISO-8859-2',
    '... charset explicitly listed in header is preferred over ISO-8859-1 default'
);

is(
    $n->choose_charset( [ "UTF-8", "US-ASCII" ], 'ISO-8859-1' ), 'UTF-8',
    '... got default back when the default is in list of choices'
);

is(
    $n->choose_charset( ["US-ASCII"], 'ISO-8859-1' ),
    undef,
    '... got nothing back when default is not an acceptable choice'
);

is(
    $n->choose_charset( [ "UTF-8", "US-ASCII" ], "iso-8859-1, utf8" ),
    'UTF-8',
    '... charsets in header are canonicalized'
);

is(
    $n->choose_charset( [ "utf8", "US-ASCII" ], "iso-8859-1, UTF-8" ),
    'UTF-8',
    '... charset choices are canonicalized'
);

done_testing;
