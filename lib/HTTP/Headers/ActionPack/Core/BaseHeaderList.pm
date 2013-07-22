package HTTP::Headers::ActionPack::Core;
use v5.16;
use warnings;
use mop;

use Scalar::Util                    qw[ blessed ];
use HTTP::Headers::ActionPack::Util qw[ split_header_words ];

class BaseHeaderList extends HTTP::Headers::ActionPack::Core::Base is abstract {

    method new_from_string ($header_string) {
        my $list = $class->new;
        foreach my $header ( split_header_words( $header_string ) ) {
            $list->add_header_value( $header )
        }
        $list;
    }

    method as_string is overload('""') {
        join ', ' => map { blessed $_ ? $_->as_string : $_ } $self->iterable;
    }

    method add;
    method add_header_value;
    method iterable;
}

1;

__END__

=head1 SYNOPSIS

  use HTTP::Headers::ActionPack::Core::BaseHeaderList;

=head1 DESCRIPTION

This is a base class for header lists. There are no real
user serviceable parts in here.

=head1 METHODS

=over 4

=item C<new_from_string ( $header_string )>

This accepts a HTTP header string which get parsed
and loaded accordingly.

=item C<as_string>

=back

=head1 ABSTRACT METHODS

=over 4

=item C<add>

=item C<add_header_value>

=item C<iterable>

=back

=cut
