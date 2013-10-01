package HTTP::Headers::ActionPack::Core;
use v5.16;
use warnings;
use mop;

use Hash::Util::FieldHash qw[ fieldhash register id id_2obj ];

fieldhash my %storable_map;

class Base is abstract {
    method new_from_string;
    method as_string;

    method STORABLE_freeze ($cloning) {
        die "I hate STORABLE" unless $cloning;
        register($self);
        $storable_map{$self} = $self;
        return id($self);
    }

    method STORABLE_attach ($cloning, $serialized) {
        die "I really hate STORABLE" unless $cloning;
        return $storable_map{$serialized};
    }

}

1;

__END__

=head1 SYNOPSIS

  use HTTP::Headers::ActionPack::Core::Base;

=head1 DESCRIPTION

There are no real user serviceable parts in here.

=head1 METHODS

=over 4

=item C<new>

=item C<BUILDARGS>

=item C<CREATE>

=item C<BUILD>

=item C<as_string>

=back

=cut
