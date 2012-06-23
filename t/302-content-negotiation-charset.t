#!/usr/bin/perl

use strict;
use warnings;

use Test::More;
use Test::Fatal;

BEGIN {
    use_ok('HTTP::Headers::ActionPack');
}

my $n = HTTP::Headers::ActionPack->new->get_content_negotiator;
isa_ok($n, 'HTTP::Headers::ActionPack::ContentNegotiation');

is($n->choose_charset( [], 'ISO-8859-1' ), undef, '... got nothing back (charset is short circuited)');

is(
    $n->choose_charset( [ "UTF-8", "US-ASCII" ], "US-ASCII, UTF-8" ),
    'US-ASCII',
    '... got the right charset back'
);

is(
    $n->choose_charset( [ "UTF-8", "US-ASCII" ], "US-ASCII;q=0.7, UTF-8" ),
    'UTF-8',
    '... got the right charset back'
);

is($n->choose_charset( [ "UTF-8", "US-ASCII" ], 'ISO-8859-1' ), undef, '... got nothing back (charset is short circuited)');

is(
    $n->choose_charset( [ "UTF-8", "US-ASCII" ], "iso-8859-1, utf-8" ),
    'utf-8',
    '... got the right charset back'
);

done_testing;