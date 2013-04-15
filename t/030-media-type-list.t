#!/usr/bin/perl

use strict;
use warnings;

use Test::More;
use Test::Fatal;

BEGIN {
    use_ok('HTTP::Headers::ActionPack::MediaTypeList');
}

{
    my $list = HTTP::Headers::ActionPack::MediaTypeList->new(
        HTTP::Headers::ActionPack::MediaType->new('audio/*'),
        HTTP::Headers::ActionPack::MediaType->new('audio/basic')
    );
    isa_ok($list, 'HTTP::Headers::ActionPack::MediaTypeList');

    is(
        $list->as_string,
        'audio/basic; q="1", audio/*; q="1"',
        '... got the expected string back'
    );
}
done_testing;exit;
{
    my $list = HTTP::Headers::ActionPack::MediaTypeList->new(
        [ 0.2 => HTTP::Headers::ActionPack::MediaType->new('audio/*')     ],
        [ 1.0 => HTTP::Headers::ActionPack::MediaType->new('audio/basic' ) ]
    );
    isa_ok($list, 'HTTP::Headers::ActionPack::MediaTypeList');

    is(
        $list->as_string,
        'audio/basic; q="1", audio/*; q="0.2"',
        '... got the expected string back'
    );
}

{
    my $list = HTTP::Headers::ActionPack::MediaTypeList->new_from_string(
        'audio/*; q=0.2, audio/basic'
    );
    isa_ok($list, 'HTTP::Headers::ActionPack::MediaTypeList');

    is(
        $list->as_string,
        'audio/basic; q="1", audio/*; q="0.2"',
        '... got the expected string back'
    );
}

{
    my $list = HTTP::Headers::ActionPack::MediaTypeList->new_from_string(
        'text/plain; q=0.5, text/html, text/x-dvi; q=0.8, text/x-c'
    );
    isa_ok($list, 'HTTP::Headers::ActionPack::MediaTypeList');

    my @tests = (
        [ 'text/plain', 0.5 ],
        [ 'text/html',  1 ],
        [ 'text/x-dvi', 0.8 ],
        [ 'text/x-c',   1 ],
    );

    for my $pair (@tests) {
        my ( $type, $q ) = @$pair;

        is(
            $list->priority_of($type),
            $q,
            "... priority for $type is $q"
        );
    }

    is(
        $list->as_string,
        'text/html; q="1", text/x-c; q="1", text/x-dvi; q="0.8", text/plain; q="0.5"',
        '... got the expected string back'
    );
}

{
    my $list = HTTP::Headers::ActionPack::MediaTypeList->new_from_string(
        'text/*, text/html, text/html;level=1, */*'
    );
    isa_ok($list, 'HTTP::Headers::ActionPack::MediaTypeList');

    is(
        $list->as_string,
        'text/html; level="1"; q="1", text/html; q="1", text/*; q="1", */*; q="1"',
        '... got the expected string back'
    );
}

{
    my $list = HTTP::Headers::ActionPack::MediaTypeList->new_from_string(
        'text/html;charset=iso8859-1, application/xml'
    );
    isa_ok($list, 'HTTP::Headers::ActionPack::MediaTypeList');

    is(
        $list->as_string,
        'text/html; charset="iso8859-1"; q="1", application/xml; q="1"',
        '... got the expected string back'
    );
}

{
    my $list = HTTP::Headers::ActionPack::MediaTypeList->new_from_string(
        'application/xml;q=0.7, text/html, */*'
    );
    isa_ok($list, 'HTTP::Headers::ActionPack::MediaTypeList');

    is(
        $list->as_string,
        'text/html; q="1", */*; q="1", application/xml; q="0.7"',
        '... got the expected string back'
    );
}

{
    my $list = HTTP::Headers::ActionPack::MediaTypeList->new_from_string(
        'application/json;v=3;foo=bar, application/json;v=2'
    );
    isa_ok($list, 'HTTP::Headers::ActionPack::MediaTypeList');

    is(
        $list->as_string,
        'application/json; v="2"; q="1", application/json; v="3"; foo="bar"; q="1"',
        '... got the expected string back'
    );
}


done_testing;
