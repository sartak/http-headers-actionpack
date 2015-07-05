package HTTP::Headers::ActionPack::Core::BaseHeaderWithParams;
# ABSTRACT: A Base header type with parameters

use strict;
use warnings;

our $VERSION = '0.10';

use Carp qw[ confess ];

use parent 'HTTP::Headers::ActionPack::Core::Base';

# NOTE:
# this is meant to be
# called by subclasses
# in their BUILDARGS
# methods
# - SL
sub _prepare_params {
    my ($class, @params) = @_;

    confess "Params must be an even sized list" unless (((scalar @params) % 2) == 0);

    my @param_order;
    for ( my $i = 0; $i < $#params; $i += 2 ) {
        push @param_order => $params[ $i ];
    }

    return +{
        params      => { @params },
        param_order => \@param_order
    };
}

sub params       { (shift)->{'params'}      }
sub _param_order { (shift)->{'param_order'} }

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

=pod

=for Pod::Coverage params_in_order

=head1 SYNOPSIS

  use HTTP::Headers::ActionPack::Core::BaseHeaderWithParams;

=head1 DESCRIPTION

This is a base class for header values which contain
a parameter list. There are no real user serviceable parts
in here.

=head1 METHODS

=over 4

=item C<params>

Accessor for the unordered hash-ref of parameters.

=item C<add_param( $key, $value )>

Add in a parameter, it will be placed at end
very end of the parameter order.

=item C<remove_param( $key )>

Remove a parameter from the link.

=item C<params_are_empty>

Returns false if there are no parameters on the invocant.

=back

=cut
