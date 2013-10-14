package HTTP::Headers::ActionPack;
use v5.16;
use warnings;
use mop;

use HTTP::Headers::ActionPack::LinkHeader;

class LinkList extends HTTP::Headers::ActionPack::Core::BaseHeaderList {

    has $!items is ro;

    method new ($class: @items) {
        $class->next::method( items => \@items )
    }

    method add ($link) {
        push @{$!items} => $link;
    }

    method add_header_value ($value) {
        $self->add( HTTP::Headers::ActionPack::LinkHeader->new( @$value ) );
    }

    method iterable { @{$!items} }

}

1;

__END__

=head1 SYNOPSIS

  use HTTP::Headers::ActionPack::LinkList;

=head1 DESCRIPTION

This is a simple list of Links since the Link header
can legally have more then one link in it.

=head1 METHODS

=over 4

=item C<add ( $link )>

=item C<add_header_value ( $header_value )>

=item C<iterable>

=back

=cut
