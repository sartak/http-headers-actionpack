#!/usr/bin/perl

use strict;
use warnings;

use Test::More;
use Test::Fatal;

BEGIN {
    use_ok('HTTP::Headers::ActionPack::MediaTypeList');
}

{
    my $list = HTTP::Headers::ActionPack::MediaTypeList->new_from_string(
        'audio/*; q=0.2, audio/basic'
    );
    isa_ok($list, 'HTTP::Headers::ActionPack::MediaTypeList');

    is(
        $list->to_string,
        'audio/basic, audio/*; q=0.2',
        '... got the expected string back'
    );
}

{
    my $list = HTTP::Headers::ActionPack::MediaTypeList->new_from_string(
        'text/plain; q=0.5, text/html, text/x-dvi; q=0.8, text/x-c'
    );
    isa_ok($list, 'HTTP::Headers::ActionPack::MediaTypeList');

    is(
        $list->to_string,
        'text/x-c, text/html, text/x-dvi; q=0.8, text/plain; q=0.5',
        '... got the expected string back'
    );
}

{
    my $list = HTTP::Headers::ActionPack::MediaTypeList->new_from_string(
        'text/*, text/html, text/html;level=1, */*'
    );
    isa_ok($list, 'HTTP::Headers::ActionPack::MediaTypeList');

    is(
        $list->to_string,
        'text/html; level=1, text/html, text/*, */*',
        '... got the expected string back'
    );
}

{
    my $list = HTTP::Headers::ActionPack::MediaTypeList->new_from_string(
        'text/html;charset=iso8859-1, application/xml'
    );
    isa_ok($list, 'HTTP::Headers::ActionPack::MediaTypeList');

    is(
        $list->to_string,
        'application/xml, text/html; charset=iso8859-1',
        '... got the expected string back'
    );
}

{
    my $list = HTTP::Headers::ActionPack::MediaTypeList->new_from_string(
        'application/xml;q=0.7, text/html, */*'
    );
    isa_ok($list, 'HTTP::Headers::ActionPack::MediaTypeList');

    is(
        $list->to_string,
        'text/html, */*, application/xml; q=0.7',
        '... got the expected string back'
    );
}

{
    my $list = HTTP::Headers::ActionPack::MediaTypeList->new_from_string(
        'application/json;v=3;foo=bar, application/json;v=2'
    );
    isa_ok($list, 'HTTP::Headers::ActionPack::MediaTypeList');

    is(
        $list->to_string,
        'application/json; v=2, application/json; v=3; foo=bar',
        '... got the expected string back'
    );
}


done_testing;