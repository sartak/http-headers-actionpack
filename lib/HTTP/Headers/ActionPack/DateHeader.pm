package HTTP::Headers::ActionPack::DateHeader;
# ABSTRACT: A Date Header

use strict;
use warnings;

use HTTP::Headers::ActionPack::Util qw[
    header_to_date
    date_to_header
];

use parent 'HTTP::Headers::ActionPack::Core::Base';

sub BUILDARGS {
    my (undef, $date) = @_;
    +{ date => $date }
}

sub new_from_string {
    my ($class, $header_string) = @_;
    $class->new( header_to_date( $header_string ) );
}

sub to_string { date_to_header( (shift)->{'date'} ) }

# implement a simple API
sub second       { (shift)->{'date'}->second       }
sub minute       { (shift)->{'date'}->minute       }
sub hour         { (shift)->{'date'}->hour         }
sub day_of_month { (shift)->{'date'}->day_of_month }
sub month_number { (shift)->{'date'}->mon          }
sub fullmonth    { (shift)->{'date'}->fullmonth    }
sub month        { (shift)->{'date'}->month        }
sub year         { (shift)->{'date'}->year         }
sub day_of_week  { (shift)->{'date'}->day_of_week  }
sub day          { (shift)->{'date'}->day          }
sub fullday      { (shift)->{'date'}->fullday      }
sub epoch        { (shift)->{'date'}->epoch        }

sub date { (shift)->{'date'} }

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

=head1 METHODS

=over 4

=item C<date>

Returns the underlying L<Time::Piece> object.

=item C<new_from_string ( $date_header_string )>

This will take an HTTP header Date string
and parse it into and object.

=item C<to_string>

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






