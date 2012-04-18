#!/usr/bin/perl

use strict;
use warnings;

use Test::More;
use Test::Fatal;

BEGIN {
    use_ok('HTTP::Headers::ActionPack::Link');
}


my $link = HTTP::Headers::ActionPack::Link->new_from_string(
    #'<http://example.com/TheBook/chapter2>; rel="previous"; title="previous chapter"',
    #'</>; rel="http://example.net/foo"'
    q{</TheBook/chapter2>; rel="previous"; title*="UTF-8'de'letztes%20Kapitel"}
    #q{</TheBook/chapter4>; rel="next"; title*=UTF-8'de'n%c3%a4chstes%20Kapitel}
);

warn $link->to_string;

use Data::Dumper; warn Dumper $link;


done_testing;