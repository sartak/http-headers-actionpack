package HTTP::Headers::ActionPack;
use v5.16;
use warnings;
use mop;

use HTTP::Headers::ActionPack::Util qw[
    join_header_params
    prepare_ordered_params
];

class AuthenticationInfo extends HTTP::Headers::ActionPack::Core::Base with HTTP::Headers::ActionPack::Core::WithParams {

    method new (@params) {
        $class->next::method( prepare_ordered_params( @params ) )
    }

    method new_from_string ($header_string) {
        $class->new(
            map { @$_ } HTTP::Headers::Util::_split_header_words( $header_string )
        );
    }

    method as_string is overload('""') {
        join_header_params( ', ' => $self->params_in_order );
    }
}

1;

__END__

=head1 SYNOPSIS

  use HTTP::Headers::ActionPack::AuthenticationInfo;

  # create from string
  my $auth_info = HTTP::Headers::ActionPack::AuthenticationInfo->new_from_string(
      'qop=auth-int, rspauth="6629fae49393a05397450978507c4ef1", cnonce="0a4f113b", nc=00000001'
  );

  # create from parameters
  my $auth_info = HTTP::Headers::ActionPack::AuthenticationInfo->new(
      qop     => 'auth-int',
      rspauth => "6629fae49393a05397450978507c4ef1",
      cnonce  => "0a4f113b",
      nc      => '00000001'
  );

=head1 DESCRIPTION

This class represents the Authentication-Info header, it is a pretty parameter
based header and so inherits from L<HTTP::Headers::ActionPack::Core::BaseHeaderWithParams>
to handle all the parameters.

=head1 METHODS

=over 4

=item C<new ( %params )>

=item C<new_from_string ( $header_string )>

=item C<as_string>

=back

=cut
