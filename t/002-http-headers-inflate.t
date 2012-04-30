#!/usr/bin/perl

use strict;
use warnings;

use Test::More;
use Test::Fatal;

use HTTP::Headers;

BEGIN {
    use_ok('HTTP::Headers::ActionPack');
}

my $pack = HTTP::Headers::ActionPack->new;
isa_ok($pack, 'HTTP::Headers::ActionPack');

{
    my $h = HTTP::Headers->new(
        Date         => 'Mon, 23 Apr 2012 14:14:19 GMT',
        Content_Type => 'application/xml; charset=UTF-8',
        Link         => '<http://example.com/TheBook/chapter2>; rel=previous; title="previous chapter"'
    );

    $pack->inflate( $h );

    isa_ok($h->header('Date'), 'HTTP::Headers::ActionPack::DateHeader', '... object is preserved and');
    isa_ok($h->header('Content-Type'), 'HTTP::Headers::ActionPack::MediaType', '... object is preserved and');
    isa_ok($h->header('Link'), 'HTTP::Headers::ActionPack::LinkList', '... object is preserved and');

    is(
        $h->as_string,
    q{Date: Mon, 23 Apr 2012 14:14:19 GMT
Content-Type: application/xml; charset="UTF-8"
Link: <http://example.com/TheBook/chapter2>; rel="previous"; title="previous chapter"
},
        '... got the stringified headers'
    );
}

done_testing;

