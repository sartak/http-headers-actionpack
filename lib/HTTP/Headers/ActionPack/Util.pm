package HTTP::Headers::ActionPack::Util;
# ABSTRACT: General Utility module

use strict;
use warnings;

use Time::Piece;
use HTTP::Date qw[ str2time time2str ];
use HTTP::Headers::Util;

use Sub::Exporter -setup => {
    exports => [qw[
        header_to_date
        date_to_header
        split_header_words
        join_header_words
        join_header_params
    ]]
};

sub header_to_date { scalar Time::Piece->gmtime( str2time( shift ) ) }
sub date_to_header { time2str( shift->epoch ) }

sub split_header_words {
    my $header = shift;
    map {
        splice @$_, 1, 1;
        $_;
    } HTTP::Headers::Util::_split_header_words( $header );
}

sub join_header_words {
    my ($subject, @params) = @_;
    return $subject . '; ' . join_header_params( '; ' =>  @params ) if @params;
    return $subject;
}

sub join_header_params {
    my ($seperator, @params) = @_;
    my @attrs;
    while ( @params ) {
        my $k = shift @params;
        my $v = shift @params;
        $v =~ s/([\"\\])/\\$1/g;  # escape " and \
        push @attrs => ($k . qq(="$v"));
    }
    return join $seperator =>  @attrs;
}

1;

__END__

=head1 SYNOPSIS

  use HTTP::Headers::ActionPack::Util;

=head1 DESCRIPTION

This is just a basic utility module used internally by
L<HTTP::Headers::ActionPack>. There is no real user servicable parts
in here.

=head1 FUNCTIONS

=over 4

=item C<str2time>

This is imported from L<HTTP::Date> and passed on here
for export.

=item C<split_header_words ( $header )>

This will split up a header, respecting all the quoted strings and
such, and return the subject, followed by an array of parameter pairs.

The parameters are returned as an array so that ordering can be
preserved.

=item C<join_header_words ( $subject, @params )>

This will canonicalize the header such that it will add a
space between each semicolon and quote and escape all headers
values appropriately.

=back

