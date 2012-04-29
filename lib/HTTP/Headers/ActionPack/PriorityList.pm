package HTTP::Headers::ActionPack::PriorityList;
# ABSTRACT: A Priority List

use strict;
use warnings;

use HTTP::Headers::ActionPack::Util qw[
    split_header_words
    join_header_words
];

use parent 'HTTP::Headers::ActionPack::Core::BaseHeaderList';

sub BUILDARGS { +{ 'index' => {}, 'items' => {} } }

sub BUILD {
    my ($self, @items) = @_;
    foreach my $item ( @items ) {
        $self->add( @$item )
    }
}

sub index { (shift)->{'index'} }
sub items { (shift)->{'items'} }

sub new_from_string {
    my ($class, $header_string) = @_;
    my $list = $class->new;
    foreach my $header ( split_header_words( $header_string ) ) {
        $list->add_header_value( $header );
    }
    $list;
}

sub to_string {
    my $self = shift;
    join ', ' => map {
        my ($q, $subject) = @{ $_ };
        join_header_words( $subject, q => $q );
    } $self->iterable;
}

sub add {
    my ($self, $q, $choice) = @_;
    $q += 0; # be sure to numify this
    $self->index->{ $choice } = $q;
    $self->items->{ $q } = [] unless exists $self->items->{ $q };
    push @{ $self->items->{ $q } } => $choice;
}

sub add_header_value {
    my $self = shift;
    my ($choice, %params) = @{ $_[0] };
    $self->add( $params{'q'} || 1.0, $choice );
}

sub get {
    my ($self, $q) = @_;
    $self->items->{ $q };
}

sub priority_of {
    my ($self, $choice) = @_;
    $self->index->{ $choice };
}

sub iterable {
    my $self = shift;
    map {
        my $q = $_;
        map { [ $q, $_ ] } @{ $self->items->{ $q } }
    } reverse sort keys %{ $self->items };
}

1;

__END__

=head1 SYNOPSIS

  use HTTP::Headers::ActionPack::PriorityList;

  # simple constructor
  my $plist = HTTP::Headers::ActionPack::PriorityList->new(
      [ 1.0 => 'foo' ],
      [ 0.5 => 'bar' ],
      [ 0.2 => 'baz' ],
  );

  # from headers
  my $plist = HTTP::Headers::ActionPack::PriorityList->new_from_string(
      'foo; q=1.0, bar; q=0.5, baz; q=0.2'
  );

=head1 DESCRIPTION

This is a simple priority list implementation, this is used to
handle the L<Accept-*> headers as they typically will contain
values along with a "q" value to indicate quality.

=head1 METHODS

=item C<new>

=item C<new_from_string ( $header_string )>

This accepts a HTTP header string which get parsed
and loaded accordingly.

=item C<index>

=item C<items>

=item C<add ( $quality, $choice )>

Add in a new C<$choice> with a given C<$quality>.

=item C<get ( $quality )>

Given a certain C<$quality>, it returns the various
choices available.

=item C<priority_of ( $choice )>

Given a certain C<$choice> this returns the associated
quality of it.

=item C<iterable>

This returns a list of two item ARRAY refs with the
quality as the first item and the associated choice
as the second item. These are sorted accordingly.

=back



