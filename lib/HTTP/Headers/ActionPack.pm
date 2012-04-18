package HTTP::Headers::ActionPack;
# ABSTRACT: General Utility module

use strict;
use warnings;

use Carp qw[ confess ];

my %DEFAULT_MAPPINGS = (
    'link'            => 'HTTP::Headers::ActionPack::Link',
    'content-type'    => 'HTTP::Headers::ActionPack::MediaType',
    'accept'          => 'HTTP::Headers::ActionPack::MediaTypeList',
    'accept-charset'  => 'HTTP::Headers::ActionPack::PriorityList',
    'accept-encoding' => 'HTTP::Headers::ActionPack::PriorityList',
    'accept-language' => 'HTTP::Headers::ActionPack::PriorityList',
);

sub new {
    my $class = shift;
    bless {
        mappings => { %DEFAULT_MAPPINGS, @_ }
    } => $class;
}

sub create {
    my ($self, $header_name, $header_value) = @_;

    my $class = $self->{'mappings'}->{ lc $header_name };

    (defined $class)
        || confess "Could not find mapping for '$header_name'";

    eval "use $class;";
    confess $@ if $@;

    $class->new_from_string( $header_value );
}

1;

__END__

=head1 SYNOPSIS

  use HTTP::Headers::ActionPack;

=head1 DESCRIPTION

=back

