package HTTP::Headers::ActionPack::Core::Base;
# ABSTRACT: A Base class

use strict;
use warnings;

use overload '""' => 'to_string', fallback => 1;

sub new {
    my $class = shift;
    my $self  = $class->CREATE( $class->BUILDARGS( @_ ) );
    $self->BUILD( @_ );
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

There is no real user servicable parts in here.

=head1 METHODS

=item C<new>

=item C<BUILDARGS>

=item C<CREATE>

=item C<BUILD>

=item C<to_string>

=back



