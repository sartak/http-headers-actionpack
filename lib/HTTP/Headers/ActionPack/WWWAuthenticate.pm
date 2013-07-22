package HTTP::Headers::ActionPack;
use v5.16;
use warnings;
use mop;

class WWWAuthenticate extends HTTP::Headers::ActionPack::Core::BaseAuthHeader is overload('inherited') {
    method realm { $self->params->{'realm'} }
}

1;

__END__

=head1 SYNOPSIS

  use HTTP::Headers::ActionPack::WWWAuthenticate;

  # create from string
  my $www_authen = HTTP::Headers::ActionPack::WWWAuthenticate->new_from_string(
      'Basic realm="WallyWorld"'
  );

  # create using parameters
  my $www_authen = HTTP::Headers::ActionPack::WWWAuthenticate->new(
      'Basic' => (
          realm => 'WallyWorld'
      )
  );

  # create from string
  my $www_authen = HTTP::Headers::ActionPack::WWWAuthenticate->new_from_string(
      q{Digest
          realm="testrealm@host.com",
          qop="auth,auth-int",
          nonce="dcd98b7102dd2f0e8b11d0f600bfb0c093",
          opaque="5ccc069c403ebaf9f0171e9517f40e41"'}
  );

  # create using parameters
  my $www_authen = HTTP::Headers::ActionPack::WWWAuthenticate->new(
      'Digest' => (
          realm  => 'testrealm@host.com',
          qop    => "auth,auth-int",
          nonce  => "dcd98b7102dd2f0e8b11d0f600bfb0c093",
          opaque => "5ccc069c403ebaf9f0171e9517f40e41"
      )
  );

=head1 DESCRIPTION

This class represents the WWW-Authenticate header and all it's variations,
it is based on the L<HTTP::Headers::ActionPack::Core::BaseAuthHeader> class.

=head1 METHODS

=over 4

=item C<new ( %params )>

=item C<new_from_string ( $header_string )>

=item C<realm>

=item C<as_string>

=back

=cut
