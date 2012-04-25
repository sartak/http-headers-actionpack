package HTTP::Headers::ActionPack::LinkList;
# ABSTRACT: A List of Link objects

use strict;
use warnings;

use HTTP::Headers::ActionPack::Link;

use parent 'HTTP::Headers::ActionPack::Core::BaseHeaderList';

sub BUILDARGS { shift; +{ items => [ @_ ] } }

sub items { (shift)->{'items'} }

sub add {
    my ($self, $link) = @_;
    push @{ $self->items } => $link;
}

sub add_header_value {
    my ($self, $value) = @_;
    $self->add( HTTP::Headers::ActionPack::Link->new( @$value ) );
}

sub iterable { @{ (shift)->items } }

1;

__END__

=head1 SYNOPSIS

  use HTTP::Headers::ActionPack::LinkList;

=head1 DESCRIPTION

This is a simple list of Links

=head1 METHODS

=item C<add>

=item C<add_header_value>

=item C<iterable>

=back



