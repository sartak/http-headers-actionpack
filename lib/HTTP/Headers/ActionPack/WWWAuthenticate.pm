package HTTP::Headers::ActionPack::WWWAuthenticate;
# ABSTRACT: The WWW-Authenticate Header

use strict;
use warnings;

use HTTP::Headers::ActionPack::Util qw[
    join_header_params
];

use parent 'HTTP::Headers::ActionPack::Core::BaseHeaderType';

sub new_from_string {
    my ($class, $header_string) = @_;

    my @parts = HTTP::Headers::Util::_split_header_words( $header_string );
    splice @{ $parts[0] }, 1, 1;

    $class->new( map { @$_ } @parts );
}

sub auth_type { (shift)->subject         }
sub realm     { (shift)->params->{'realm'} }

sub as_string {
    my $self = shift;
    $self->auth_type . ' ' . join_header_params( ', ' => $self->params_in_order );
}

1;

__END__

=head1 SYNOPSIS

  use HTTP::Headers::ActionPack::WWWAuthenticate;

  # create from string
  my $date = HTTP::Headers::ActionPack::WWWAuthenticate->new_from_string(
      'Basic realm="WallyWorld"'
  );

  # create using parameters
  my $date = HTTP::Headers::ActionPack::WWWAuthenticate->new(
      'Basic' => (
          realm => 'WallyWorld'
      )
  );

=head1 DESCRIPTION

=head1 METHODS

=over 4

=item C<new ( %params )>

=item C<new_from_string ( $header_string )>

=item C<auth_type>

=item C<realm>

=item C<as_string>

=back






