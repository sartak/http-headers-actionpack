#!/usr/bin/perl

use strict;
use warnings;

use Test::More;
use Test::Fatal;

BEGIN {
    use_ok('HTTP::Headers::ActionPack');
}

my $pack = HTTP::Headers::ActionPack->new;
isa_ok($pack, 'HTTP::Headers::ActionPack');

my $media_type = $pack->create( 'Content-Type' => 'application/xml;charset=UTF-8' );
isa_ok($media_type, 'HTTP::Headers::ActionPack::MediaType');

is($media_type->to_string, 'application/xml; charset=UTF-8', '... got the right string');

done_testing;