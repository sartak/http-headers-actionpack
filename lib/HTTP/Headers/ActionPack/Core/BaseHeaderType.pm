package HTTP::Headers::ActionPack::Core::BaseHeaderType;
# ABSTRACT: A Base header type

use strict;
use warnings;

use Carp qw[ confess ];

use HTTP::Headers::ActionPack::Util qw[
    split_header_words
    join_header_words
];

use parent 'HTTP::Headers::ActionPack::Core::Base';

sub BUILDARGS {
    my $class = shift;
    my ($subject, @params) = @_;

    confess "You must specify a subject"        unless $subject;
    confess "Params must be an even sized list" unless (((scalar @params) % 2) == 0);

    my @param_order;
    for ( my $i = 0; $i < $#params; $i += 2 ) {
        push @param_order => $params[ $i ];
    }

    return +{
        subject     => $subject,
        params      => { @params },
        param_order => \@param_order
    };
}

sub subject      { (shift)->{'subject'}     }
sub params       { (shift)->{'params'}      }
sub _param_order { (shift)->{'param_order'} }

sub new_from_string {
    my ($class, $header_string) = @_;
    $class->new( @{ (split_header_words( $header_string ))[0] } );
}

sub to_string {
    my $self = shift;
    join_header_words( $self->subject, $self->params_in_order );
}

sub add_param {
    my ($self, $k, $v) = @_;
    $self->params->{ $k } = $v;
    push @{ $self->_param_order } => $k;
}

sub remove_param {
    my ($self, $k) = @_;
    $self->{'param_order'} = [ grep { $_ ne $k } @{ $self->{'param_order'} } ];
    return delete $self->params->{ $k };
}

sub params_in_order {
    my $self = shift;
    map { $_, $self->params->{ $_ } } @{ $self->_param_order }
}

sub params_are_empty {
    my $self = shift;
    (scalar keys %{ $self->params }) == 0 ? 1 : 0
}

1;

__END__

=head1 SYNOPSIS

  use HTTP::Headers::ActionPack::Core::BaseHeaderType;

=head1 DESCRIPTION

=head1 METHODS

=over 4

=item C<new( $subject, @params )>

=item C<subject>

=item C<params>

Accessor for the unordered hash-ref of params.

=item C<new_from_string ( $header_string )>

This will take an HTTP header string
and parse it into and object.

=item C<to_string>

This stringifys the link respecting the
parameter order.

NOTE: This will canonicalize the header such
that it will add a space between each semicolon
and quotes and unquotes all headers appropriately.

=item C<add_param( $key, $value )>

Add in a parameter, it will be placed at end
very end of the parameter order.

=item C<remove_param( $key )>

Remove a parameter from the link.

=item C<params_are_empty>

Returns false if there are no parameters on the invovant.

=back






