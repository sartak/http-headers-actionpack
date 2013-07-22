package HTTP::Headers::ActionPack::Authorization;
use v5.16;
use warnings;
use mop;

use Carp         qw[ confess ];
use MIME::Base64 qw[ encode_base64 decode_base64 ];

class Basic extends HTTP::Headers::ActionPack::Core::Base {

    has $auth_type is ro;
    has $username  is ro;
    has $password  is ro;

    method new ($type, $credentials) {
        $type        || confess "Must specify type";
        $credentials || confess "Must provide credentials";

        if ( ref $credentials && ref $credentials eq 'HASH' ) {
            return $class->next::method( auth_type => $type, %$credentials );
        }
        elsif ( ref $credentials && ref $credentials eq 'ARRAY' ) {
            my ($username, $password) = @$credentials;
            return $class->next::method( auth_type => $type, username => $username, password => $password );
        }
        else {
            my ($username, $password) = split ':' => decode_base64( $credentials );
            return $class->next::method( auth_type => $type, username => $username, password => $password );
        }
    }

    method new_from_string ($header_string) {
        my ($type, $credentials) = split /\s/ => $header_string;
        ($type eq 'Basic')
            || confess "The type must be 'Basic', not '$type'";
        $class->new( $type, $credentials );
    }

    method as_string is overload('""') {
        join ' ' => $auth_type, encode_base64( (join ':' => $username, $password), '' )
    }

}

1;

__END__

=head1 SYNOPSIS

  use HTTP::Headers::ActionPack::Authorization::Basic;

  # create from string
  my $auth = HTTP::Headers::ActionPack::Authorization::Basic->new_from_string(
      'Basic QWxhZGRpbjpvcGVuIHNlc2FtZQ=='
  );

  # create from parameters
  my $auth = HTTP::Headers::ActionPack::Authorization::Basic->new(
      'Basic' => {
          username => 'Aladdin',
          password => 'open sesame'
      }
  );

  my $auth = HTTP::Headers::ActionPack::Authorization::Basic->new(
      'Basic' => [ 'Aladdin', 'open sesame' ]
  );

  my $auth = HTTP::Headers::ActionPack::Authorization::Basic->new(
      'Basic' => 'QWxhZGRpbjpvcGVuIHNlc2FtZQ=='
  );

=head1 DESCRIPTION

This class represents the Authorization header with the specific
focus on the 'Basic' type.

=head1 METHODS

=over 4

=item C<new ( $type, $credentials )>

The C<$credentials> argument can either be a Base64 encoded string (as
would be passed in via the header), a HASH ref with username and password
keys, or a two element ARRAY ref where the first element is the username
and the second the password.

=item C<new_from_string ( $header_string )>

=item C<auth_type>

=item C<username>

=item C<password>

=item C<as_string>

=back

=cut
