#!/usr/bin/perl

use strict;
use warnings;

use Test::More;
use Test::Fatal;

BEGIN {
    use_ok('HTTP::Headers::ActionPack');
    use_ok('HTTP::Headers::ActionPack::DateHeader');
    use_ok('HTTP::Headers::ActionPack::LinkHeader');
    use_ok('HTTP::Headers::ActionPack::LinkList');
    use_ok('HTTP::Headers::ActionPack::MediaType');
    use_ok('HTTP::Headers::ActionPack::MediaTypeList');
    use_ok('HTTP::Headers::ActionPack::PriorityList');
    use_ok('HTTP::Headers::ActionPack::Util');
}

done_testing;