package HTTP::Headers::ActionPack::AuthenticationInfo;
# ABSTRACT: The Authentication-Info Header

use strict;
use warnings;

our $VERSION = '0.10';

use HTTP::Headers::ActionPack::Util qw[
    join_header_params
];

use parent 'HTTP::Headers::ActionPack::Core::BaseHeaderWithParams';

sub BUILDARGS {
    my $class = shift;
    $class->_prepare_params( @_ )
}

sub new_from_string {
    my ($class, $header_string) = @_;
    $class->new(
        map { @$_ } HTTP::Headers::Util::_split_header_words( $header_string )
    );
}

sub as_string {
    join_header_params( ', ' => (shift)->params_in_order );
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
