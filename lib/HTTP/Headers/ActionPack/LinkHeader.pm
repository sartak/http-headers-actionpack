package HTTP::Headers::ActionPack;
use v5.16;
use warnings;
use mop;

use URI::Escape                     qw[ uri_escape uri_unescape ];
use HTTP::Headers::ActionPack::Util qw[ join_header_words prepare_ordered_params ];

class LinkHeader extends HTTP::Headers::ActionPack::Core::BaseHeaderType {
    
    method new ($class: $href, @params) {

        $href =~ s/^<//;
        $href =~ s/>$//;

        $class->next::method( $href, @params );
    }

    method BUILD {
        foreach my $param ( grep { /\*$/ } @{ $self->param_order } ) {
            my ($encoding, $language, $content) = ( $self->params->{ $param } =~ /^(.*)\'(.*)\'(.*)$/);
            $self->params->{ $param } = {
                encoding => $encoding,
                language => $language,
                content  => uri_unescape( $content )
            };
        }
    }

    method href { $self->subject         }
    method rel  { $self->params->{'rel'} }

    method relation_matches ($relation) {

        if ( my $rel = $self->params->{'rel'} ) {
            # if it is an extension rel type
            # then it is a URI and it should
            # not be compared in a case-insensitive
            # manner ...
            if ( $rel =~ m!^\w+\://! ) {
                $self->params->{'rel'} eq $relation ? 1 : 0;
            }
            # if it is not a URI, then compare
            # it case-insensitively
            else {
                (lc $self->params->{'rel'} ) eq (lc $relation) ? 1 : 0;
            }
        }
    }

    method as_string is overload('""') {

        my @params;
        foreach my $param ( @{ $self->param_order } ) {
            if ( $param =~ /\*$/ ) {
                my $complex = $self->params->{ $param };
                push @params => ( $param,
                    join "'" => (
                        $complex->{'encoding'},
                        $complex->{'language'},
                        uri_escape( $complex->{'content'} ),
                    )
                );
            }
            else {
                push @params => ( $param, $self->params->{ $param } );
            }
            my ($encoding, $language, $content) = ( $self->params->{ $param } =~ /^(.*)\'(.*)\'(.*)$/);
        }

        join_header_words( '<' . $self->href . '>', @params );
    }
}

1;

__END__

=head1 SYNOPSIS

  use HTTP::Headers::ActionPack::LinkHeader;

  # build from string
  my $link = HTTP::Headers::ActionPack::LinkHeader->new_from_string(
      '<http://example.com/TheBook/chapter2>;rel="previous";title="previous chapter"'
  );

  # normal constructor
  my $link = HTTP::Headers::ActionPack::LinkHeader->new(
      '<http://example.com/TheBook/chapter2>' => (
          rel   => "previous",
          title => "previous chapter"
      )
  );

  # normal constructor, and <> around link are optional
  my $link = HTTP::Headers::ActionPack::LinkHeader->new(
      'http://example.com/TheBook/chapter2' => (
          rel   => "previous",
          title => "previous chapter"
      )
  );

=head1 DESCRIPTION

This is an object which represents an HTTP Link header. It
is most often used as a member of a L<HTTP::Headers::ActionPack::LinkList>
object.

=head1 METHODS

=over 4

=item C<href>

=item C<new_from_string ( $link_header_string )>

This will take an HTTP header Link string
and parse it into and object.

=item C<as_string>

This stringifies the link respecting the
parameter order.

NOTE: This will canonicalize the header such
that it will add a space between each semicolon
and quotes and unquotes all headers appropriately.

=back

=cut
