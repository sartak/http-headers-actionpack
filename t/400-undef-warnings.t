#!/usr/bin/perl

use strict;
use warnings;

use Test::Fatal;
use Test::More;
use Test::Warnings;

use HTTP::Headers::ActionPack::AuthenticationInfo;

my $auth = HTTP::Headers::ActionPack::AuthenticationInfo->new(
    foo => 42,
    bar => undef,
);

isa_ok( $auth, 'HTTP::Headers::ActionPack::AuthenticationInfo' );

is( $auth->as_string, 'foo="42", bar=""', 'auth header as string' );

done_testing();
