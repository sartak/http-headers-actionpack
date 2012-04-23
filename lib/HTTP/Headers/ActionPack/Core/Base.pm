package HTTP::Headers::ActionPack::Core::Base;
# ABSTRACT: A Base class

use strict;
use warnings;

sub new {
    my $class = shift;
    my $self  = $class->CREATE( $class->BUILDARGS( @_ ) );
    $self->BUILD;
    $self;
}

sub BUILDARGS { +{ ref $_[0] eq 'HASH' ? %{ $_[0] } : @_ } }

sub CREATE {
    my ($class, $instance) = @_;
    bless $instance => $class;
}

sub BUILD {}

sub to_string {
    my $self = shift;
    "$self"
}

1;

__END__

=head1 SYNOPSIS

  use HTTP::Headers::ActionPack::Core::Base;

=head1 DESCRIPTION

This is a simple priority list implementation.

=head1 METHODS

=item C<new>

=item C<BUILDARGS>

=item C<CREATE>

=item C<BUILD>

=item C<to_string>

=back



