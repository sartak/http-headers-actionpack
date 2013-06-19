package HTTP::Headers::ActionPack::DateHeader;
# ABSTRACT: A Date Header

use strict;
use warnings;

use HTTP::Headers::ActionPack::Util qw[
    header_to_date
    date_to_header
];

use Moo;

extends 'HTTP::Headers::ActionPack::Header';

with 'HTTP::Headers::ActionPack::Role::Header';

has date => (
    is       => 'ro',
    required => 1,
    handles  => {
        second       => 'second',
        minute       => 'minute',
        hour         => 'hour',
        day_of_month => 'mon',
        fullmonth    => 'fullmonth',
        month        => 'month',
        year         => 'year',
        day_of_week  => 'day_of_week',
        day          => 'day',
        fullday      => 'fullday',
        epoch        => 'epoch',
    },
);

sub BUILDARGS {
    my (undef, $date) = @_;
    +{ date => $date }
}

sub new_from_string {
    my ($class, $header_string) = @_;
    $class->new( header_to_date( $header_string ) );
}

sub as_string { date_to_header( (shift)->{'date'} ) }

1;

__END__

=head1 SYNOPSIS

  use HTTP::Headers::ActionPack::DateHeader;

  # create from string
  my $date = HTTP::Headers::ActionPack::DateHeader->new_from_string(
      'Mon, 23 Apr 2012 14:14:19 GMT'
  );

  # create using Time::Peice object
  my $date = HTTP::Headers::ActionPack::DateHeader->new(
      $timepeice_object
  );

=head1 DESCRIPTION

This is an object which represents an HTTP header with a date.
It will inflate the header value into a L<Time::Piece> object
and proxy most of the relevant methods.

=head1 DateTime compatibility

I opted to not use L<DateTime> (by default) for this class since
it is not a core module and can be a memory hog at times. That said,
it should be noted that L<DateTime> objects are compatible with
this class. You will need to pass in a L<DateTime> instance to
C<new> and after that everything should behave properly. If you
want C<new_from_string> to inflate strings to L<DateTime> objects
you will need to override that method yourself.

=head1 METHODS

=over 4

=item C<date>

Returns the underlying L<Time::Piece> object.

=item C<new_from_string ( $date_header_string )>

This will take an HTTP header Date string
and parse it into and object.

=item C<as_string>

=item C<second>

=item C<minute>

=item C<hour>

=item C<day_of_month>

=item C<month_number>

=item C<fullmonth>

=item C<month>

=item C<year>

=item C<day_of_week>

=item C<day>

=item C<fullday>

=item C<epoch>

These delegate to the underlying L<Time::Piece> object.

=back

=cut
