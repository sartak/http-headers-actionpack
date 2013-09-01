package HTTP::Headers::ActionPack::Core;
use v5.16;
use warnings;
use mop;

role WithParams {

    has $!params      is ro = {};
    has $!param_order is ro = [];

    method add_param ($k, $v) {
        $!params->{ $k } = $v;
        push @{$!param_order} => $k;
    }

    method remove_param ($k) {
        $!param_order = [ grep { $_ ne $k } @{$!param_order} ];
        return delete $!params->{ $k };
    }

    method params_in_order {
        map { $_, $!params->{ $_ } } @{$!param_order}
    }

    method params_are_empty {
        (scalar keys %{$!params}) == 0 ? 1 : 0
    }

}

1;

__END__

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
