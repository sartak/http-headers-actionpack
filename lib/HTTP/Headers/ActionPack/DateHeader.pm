package HTTP::Headers::ActionPack;
use v5.16;
use warnings;
use mop;

use HTTP::Headers::ActionPack::Util qw[
    header_to_date
    date_to_header
];

class DateHeader extends HTTP::Headers::ActionPack::Core::Base {

    has $date is ro;

    method new ($date) {
        $class->next::method( date => $date );
    }

    method new_from_string ($header_string) {
        $class->new( header_to_date( $header_string ) );
    }

    method as_string is overload('""') { date_to_header( $date ) }

    # implement a simple API
    method second       { $date->second       }
    method minute       { $date->minute       }
    method hour         { $date->hour         }
    method day_of_month { $date->day_of_month }
    method month_number { $date->mon          }
    method fullmonth    { $date->fullmonth    }
    method month        { $date->month        }
    method year         { $date->year         }
    method day_of_week  { $date->day_of_week  }
    method day          { $date->day          }
    method fullday      { $date->fullday      }
    method epoch        { $date->epoch        }
}

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
