package HTTP::Headers::ActionPack::Core;
use v5.16;
use warnings;
use mop;

use Carp                            qw[ confess ];
use HTTP::Headers::ActionPack::Util qw[
    join_header_params
    prepare_ordered_params
];

class BaseAuthHeader extends HTTP::Headers::ActionPack::Core::Base with HTTP::Headers::ActionPack::Core::WithParams {

    has $!auth_type is ro;

    method new ($type, @params) {
        confess "You must specify an auth-type" unless $type;

        $class->next::method(
            auth_type => $type,
            %{ prepare_ordered_params( @params ) }
        );
    }

    method new_from_string ($header_string) {

        my @parts = HTTP::Headers::Util::_split_header_words( $header_string );
        splice @{ $parts[0] }, 1, 1;

        $class->new( map { @$_ } @parts );
    }

    method as_string is overload('""') {
        $!auth_type . ' ' . join_header_params( ', ' => $self->params_in_order );
    }

}

1;

__END__

=head1 SYNOPSIS

  use HTTP::Headers::ActionPack::Core::BaseAuthHeader;

=head1 DESCRIPTION

This is a base class for Auth-style headers; it inherits
from L<HTTP::Headers::ActionPack::Core::BaseHeaderWithParams>.

=head1 METHODS

=over 4

=item C<new ( %params )>

=item C<new_from_string ( $header_string )>

=item C<auth_type>

=item C<as_string>

=back

=cut
