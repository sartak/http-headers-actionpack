package HTTP::Headers::ActionPack::Core;
use v5.16;
use warnings;
use mop;

use Carp qw[ confess ];
use HTTP::Headers::ActionPack::Util qw[
    split_header_words
    join_header_words
    prepare_ordered_params
];

class BaseHeaderType extends HTTP::Headers::ActionPack::Core::Base with HTTP::Headers::ActionPack::Core::WithParams {

    has $!subject is ro;

    method new ($class: $subject, @params) {
        confess "You must specify a subject" unless $subject;

        $class->next::method(
            subject => $subject,
            %{ prepare_ordered_params( @params ) }
        );
    }

    method new_from_string ($class: $header_string) {
        $class->new( @{ (split_header_words( $header_string ))[0] } );
    }

    method as_string is overload('""') {
        join_header_words( $!subject, $self->params_in_order );
    }

}

1;

__END__

=head1 SYNOPSIS

  use HTTP::Headers::ActionPack::Core::BaseHeaderType;

=head1 DESCRIPTION

This is a base class for header values which also contain
a parameter list. There are no real user serviceable parts
in here.

=head1 METHODS

=over 4

=item C<new( $subject, @params )>

=item C<subject>

=item C<new_from_string ( $header_string )>

This will take an HTTP header string
and parse it into and object.

=item C<as_string>

This stringifies the link
respecting the parameter order.

NOTE: This will canonicalize the header such
that it will add a space between each semicolon
and quotes and unquotes all headers appropriately.

=back

=cut
