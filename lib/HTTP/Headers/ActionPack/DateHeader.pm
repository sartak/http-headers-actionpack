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

  use HTTP::Headers::ActionPack::Link;

=head1 DESCRIPTION

This is an object which represents an HTTP Link header.

=head1 METHODS

=over 4

=item C<href>

=item C<new_from_string ( $link_header_string )>

This will take an HTTP header Link string
and parse it into and object.

=item C<to_string>

This stringifys the link respecting the
parameter order.

NOTE: This will canonicalize the header such
that it will add a space between each semicolon
and quotes and unquotes all headers appropriately.

=back






