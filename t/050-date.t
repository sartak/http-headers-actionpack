
#!/usr/bin/perl

use strict;
use warnings;

use Test::More;
use Test::Fatal;

BEGIN {
    use_ok('HTTP::Headers::ActionPack::DateHeader');
}

sub test_date {
    my $h = shift;

    isa_ok($h, 'HTTP::Headers::ActionPack::DateHeader');

    while (my ($k, $v) = splice @_, 0, 2) {
        is $h->$k, $v, "... got the $k";
    }
}

test_date(
    HTTP::Headers::ActionPack::DateHeader->new_from_string('Mon, 23 Apr 2012 14:14:19 GMT'),
    day => 'Mon', day_of_month => 23, month => 'Apr', year => 2012,
    hour => 14, minute => 14, second => 19,
    as_string => 'Mon, 23 Apr 2012 14:14:19 GMT',
);

test_date(
    HTTP::Headers::ActionPack::DateHeader->new_from_string('Sat, 23 Apr 2112 14:14:19 GMT'),
    day => 'Sat', day_of_month => 23, month => 'Apr', year => 2112,
    hour => 14, minute => 14, second => 19,
    as_string => 'Sat, 23 Apr 2112 14:14:19 GMT',
);

test_date(
    HTTP::Headers::ActionPack::DateHeader->new(
        scalar Time::Piece->gmtime( HTTP::Date::str2time( 'Mon, 23 Apr 2012 14:14:19 GMT' ) )
    ),
    day => 'Mon', day_of_month => 23, month => 'Apr', year => 2012,
    hour => 14, minute => 14, second => 19,
    as_string => 'Mon, 23 Apr 2012 14:14:19 GMT',
);

test_date(
    HTTP::Headers::ActionPack::DateHeader->new(
        scalar Time::Piece->gmtime( HTTP::Date::str2time( 'Sat, 23 Apr 2112 14:14:19 GMT' ) )
    ),
    day => 'Sat', day_of_month => 23, month => 'Apr', year => 2112,
    hour => 14, minute => 14, second => 19,
    as_string => 'Sat, 23 Apr 2112 14:14:19 GMT',
);

done_testing;

