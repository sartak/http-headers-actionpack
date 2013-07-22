package HTTP::Headers::ActionPack;
use v5.16;
use warnings;
use mop;

use HTTP::Headers::ActionPack::Util qw[
    split_header_words
    join_header_words
];

class PriorityList extends HTTP::Headers::ActionPack::Core::BaseHeaderList {

    has $index is ro = {};
    has $items is ro = {};

    method new (@items) {
        my $self = $class->next::method;
        foreach my $item ( @items ) {
            $self->add( @$item )
        }
        $self;
    }

    method new_from_string ($header_string) {
        my $list = $class->new;
        foreach my $header ( split_header_words( $header_string ) ) {
            $list->add_header_value( $header );
        }
        $list;
    }

    method as_string is overload('""') {
        join ', ' => map {
            my ($q, $subject) = @{ $_ };
            join_header_words( $subject, q => $q );
        } $self->iterable;
    }

    method add ($q, $choice) {
        # XXX - should failure to canonicalize be an error? or should
        # canonicalize_choice itself throw an error on bad values?
        $choice = $self->canonicalize_choice($choice)
            or return;
        $q += 0; # be sure to numify this
        $index->{ $choice } = $q;
        $items->{ $q } = [] unless exists $items->{ $q };
        push @{ $items->{ $q } } => $choice;
    }

    method add_header_value {
        my ($choice, %params) = @{ $_[0] };
        $self->add( exists $params{'q'} ? $params{'q'} : 1.0, $choice );
    }

    method get ($q) {
        $items->{ $q };
    }

    method priority_of ($choice) {
        $choice = $self->canonicalize_choice($choice)
            or return;
        $index->{ $choice };
    }

    method iterable {
        map {
            my $q = $_;
            map { [ $q, $_ ] } @{ $items->{ $q } }
        } reverse sort keys %$items;
    }

    method canonicalize_choice ($choice) {
        return $choice;
    }
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
handle the Accept-* headers as they typically will contain
values along with a "q" value to indicate quality.

=head1 METHODS

=over 4

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

When two items have the same priority, they are returned
in the order that they were found in the header.

=item C<canonicalize_choice>

By default, this does nothing. It exists so that subclasses can override it.

=back

=cut
