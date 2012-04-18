package HTTP::Headers::ActionPack::Link;
# ABSTRACT: A Link

use strict;
use warnings;

use HTTP::Headers::ActionPack::Util qw[
    split_header_words
    join_header_words
];

use parent 'HTTP::Headers::ActionPack::Core::BaseHeaderType';

sub href { (shift)->subject }

sub new_from_string {
    my ($class, $link_header_string) = @_;
    my ($href, @params) = @{ (split_header_words( $link_header_string ))[0] };
    $href =~ s/^<//;
    $href =~ s/>$//;
    $class->new( $href, @params );
}

sub to_string {
    my $self = shift;
    join_header_words( '<' . $self->href . '>', $self->params_in_order );
}

1;

__END__

=head1 SYNOPSIS

  use HTTP::Headers::ActionPack::Link;

=head1 DESCRIPTION

This is an object which represents an HTTP Link header.

=head1 METHODS

=over 4

=item C<href>

=item C<new_from_string ( $link_header_string )>

This will take an HTTP header Link string
and parse it into and object.

=item C<to_string>

This stringifys the link respecting the
parameter order.

NOTE: This will canonicalize the header such
that it will add a space between each semicolon
and quotes and unquotes all headers appropriately.

=back






