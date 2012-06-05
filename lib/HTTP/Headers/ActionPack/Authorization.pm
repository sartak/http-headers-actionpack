package HTTP::Headers::ActionPack::Authorization;
# ABSTRACT: The Authorization Header factory

use strict;
use warnings;

use HTTP::Headers::ActionPack::Authorization::Basic;
use HTTP::Headers::ActionPack::Authorization::Digest;

sub new {
    my $class = shift;
    my $type  = shift;
    $type eq 'Basic'
        ? HTTP::Headers::ActionPack::Authorization::Basic->new( $type, @_ )
        : HTTP::Headers::ActionPack::Authorization::Digest->new( $type, @_ );
}

sub new_from_string {
    my ($class, $header_string) = @_;
    $header_string =~ /^Basic/
        ? HTTP::Headers::ActionPack::Authorization::Basic->new_from_string( $header_string )
        : HTTP::Headers::ActionPack::Authorization::Digest->new_from_string( $header_string );
}

1;

__END__

=head1 SYNOPSIS

  use HTTP::Headers::ActionPack::Authorization;

  # create HTTP::Headers::ActionPack::Authorization::Basic objects ...

  # create from string
  my $auth = HTTP::Headers::ActionPack::Authorization->new_from_string(
      'Basic QWxhZGRpbjpvcGVuIHNlc2FtZQ=='
  );

  # create from parameters
  my $auth = HTTP::Headers::ActionPack::Authorization->new(
      'Basic' => {
          username => 'Aladdin',
          password => 'open sesame'
      }
  );

  my $auth = HTTP::Headers::ActionPack::Authorization->new(
      'Basic' => [ 'Aladdin', 'open sesame' ]
  );

  my $auth = HTTP::Headers::ActionPack::Authorization->new(
      'Basic' => 'QWxhZGRpbjpvcGVuIHNlc2FtZQ=='
  );

  # or HTTP::Headers::ActionPack::Authorization::Digest objects ...

  # create from string
  my $auth = HTTP::Headers::ActionPack::Authorization->new_from_string(
      q{Digest
        username="jon.dough@mobile.biz",
        realm="RoamingUsers@mobile.biz",
        nonce="CjPk9mRqNuT25eRkajM09uTl9nM09uTl9nMz5OX25PZz==",
        uri="sip:home.mobile.biz",
        qop=auth-int,
        nc=00000001,
        cnonce="0a4f113b",
        response="6629fae49393a05397450978507c4ef1",
        opaque="5ccc069c403ebaf9f0171e9517f40e41"}
  );

  # create from parameters
  my $auth = HTTP::Headers::ActionPack::Authorization->new(
      'Digest' => (
          username => 'jon.dough@mobile.biz',
          realm    => 'RoamingUsers@mobile.biz',
          nonce    => "CjPk9mRqNuT25eRkajM09uTl9nM09uTl9nMz5OX25PZz==",
          uri      => "sip:home.mobile.biz",
          qop      => 'auth-int',
          nc       => '00000001',
          cnonce   => "0a4f113b",
          response => "6629fae49393a05397450978507c4ef1",
          opaque   => "5ccc069c403ebaf9f0171e9517f40e41"
      )
  );

=head1 DESCRIPTION

This is a factory class that can be used to create the appropriate
subclass based on the type of Authorization header.

=head1 METHODS

=over 4

=item C<new ( %params )>

=item C<new_from_string ( $header_string )>

=back






