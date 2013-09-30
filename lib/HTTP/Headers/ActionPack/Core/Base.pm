package HTTP::Headers::ActionPack::Core;
use v5.16;
use warnings;
use mop;

class Base is abstract {
    method new_from_string;
    method as_string;

    method STORABLE_freeze ($cloning) {
        return mop::util::get_object_id( $self ) if $cloning;
        die "I hate STORABLE";
    }

    method STORABLE_attach ($cloning, $serialized) {
        return mop::util::get_object_from_id( $serialized ) if $cloning;
        die "I really hate STORABLE";
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
