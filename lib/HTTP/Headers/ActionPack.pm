package HTTP::Headers;
# ABSTRACT: HTTP Action, Adventure and Excitement

use v5.16;
use warnings;
use mop;

use Scalar::Util qw[ blessed ];
use Carp         qw[ confess ];

use HTTP::Headers::ActionPack::ContentNegotiation;
use HTTP::Headers::ActionPack::AcceptCharset;
use HTTP::Headers::ActionPack::AcceptLanguage;
use HTTP::Headers::ActionPack::AuthenticationInfo;
use HTTP::Headers::ActionPack::Authorization;
use HTTP::Headers::ActionPack::Authorization::Basic;
use HTTP::Headers::ActionPack::Authorization::Digest;
use HTTP::Headers::ActionPack::DateHeader;
use HTTP::Headers::ActionPack::LinkHeader;
use HTTP::Headers::ActionPack::LinkList;
use HTTP::Headers::ActionPack::MediaType;
use HTTP::Headers::ActionPack::MediaTypeList;
use HTTP::Headers::ActionPack::PriorityList;
use HTTP::Headers::ActionPack::WWWAuthenticate;

my @DEFAULT_CLASSES = qw[
    HTTP::Headers::ActionPack::AcceptCharset
    HTTP::Headers::ActionPack::AcceptLanguage
    HTTP::Headers::ActionPack::AuthenticationInfo
    HTTP::Headers::ActionPack::Authorization
    HTTP::Headers::ActionPack::Authorization::Basic
    HTTP::Headers::ActionPack::Authorization::Digest
    HTTP::Headers::ActionPack::DateHeader
    HTTP::Headers::ActionPack::LinkHeader
    HTTP::Headers::ActionPack::LinkList
    HTTP::Headers::ActionPack::MediaType
    HTTP::Headers::ActionPack::MediaTypeList
    HTTP::Headers::ActionPack::PriorityList
    HTTP::Headers::ActionPack::WWWAuthenticate
];

my %DEFAULT_MAPPINGS = (
    'link'                => 'HTTP::Headers::ActionPack::LinkList',
    'content-type'        => 'HTTP::Headers::ActionPack::MediaType',
    'accept'              => 'HTTP::Headers::ActionPack::MediaTypeList',
    'accept-charset'      => 'HTTP::Headers::ActionPack::AcceptCharset',
    'accept-encoding'     => 'HTTP::Headers::ActionPack::PriorityList',
    'accept-language'     => 'HTTP::Headers::ActionPack::AcceptLanguage',
    'date'                => 'HTTP::Headers::ActionPack::DateHeader',
    'client-date'         => 'HTTP::Headers::ActionPack::DateHeader', # added by LWP
    'expires'             => 'HTTP::Headers::ActionPack::DateHeader',
    'last-modified'       => 'HTTP::Headers::ActionPack::DateHeader',
    'if-unmodified-since' => 'HTTP::Headers::ActionPack::DateHeader',
    'if-modified-since'   => 'HTTP::Headers::ActionPack::DateHeader',
    'www-authenticate'    => 'HTTP::Headers::ActionPack::WWWAuthenticate',
    'authentication-info' => 'HTTP::Headers::ActionPack::AuthenticationInfo',
    'authorization'       => 'HTTP::Headers::ActionPack::Authorization',
);

class ActionPack {

    has $!mappings is ro;
    has $!classes;

    method new ($class: %additional) {
        my %mappings   = ( %DEFAULT_MAPPINGS, %additional );
        my %classes    = map { $_ => undef } ( @DEFAULT_CLASSES, values %additional );

        $class->next::method(
            mappings => \%mappings,
            classes  => \%classes
        );
    }

    method classes { keys %{$!classes} }

    method has_mapping ($header_name) {
        exists $!mappings->{ lc $header_name } ? 1 : 0
    }

    method get_content_negotiator {
        HTTP::Headers::ActionPack::ContentNegotiation->new( action_pack => $self );
    }

    method create ($class_name, $args) {

        my $klass = exists $!classes->{ $class_name }
            ? $class_name
            : exists $!classes->{ 'HTTP::Headers::ActionPack::' . $class_name }
                ? 'HTTP::Headers::ActionPack::' . $class_name
                : undef;

        (defined $klass)
            || confess "Could not find class '$class_name' (or 'HTTP::Headers::ActionPack::$class_name')";

        ref $args
            ? $klass->new( @$args )
            : $klass->new_from_string( $args );
    }

    method create_header ($header_name, $header_value) {

        my $klass = $!mappings->{ lc $header_name };

        (defined $klass)
            || confess "Could not find mapping for '$header_name'";

        ref $header_value
            ? $klass->new( @$header_value )
            : $klass->new_from_string( $header_value );
    }

    method inflate {
        return $self->_inflate_http_headers( @_ )
            if $_[0]->isa('HTTP::Headers');
        return $self->_inflate_generic_request( @_ )
            if $_[0]->isa('HTTP::Request')
            || $_[0]->isa('Plack::Request')
            || $_[0]->isa('Web::Request');
        confess "I don't know how to inflate '$_[0]'";
    }

    method _inflate_http_headers ($http_headers) {
        foreach my $header ( keys %{$!mappings} ) {
            if ( my $old = $http_headers->header( $header ) ) {
                $http_headers->header( $header => $self->create_header( $header, $old ) )
                    unless blessed $old && $old->isa('HTTP::Headers::ActionPack::Core::Base');
            }
        }
        return $http_headers;
    }

    method _inflate_generic_request ($request) {
        $self->_inflate_http_headers( $request->headers );
        return $request;
    }

}

1;

__END__

=head1 SYNOPSIS

  use HTTP::Headers::ActionPack;

  my $pack       = HTTP::Headers::ActionPack->new;
  my $media_type = $pack->create_header( 'Content-Type' => 'application/xml;charset=UTF-8' );
  my $link       = $pack->create( 'LinkHeader' => [ '</test/tree>', rel => "up" ] );

  # auto-magic header inflation
  # for multiple types
  $pack->inflate( $http_headers_instance );
  $pack->inflate( $http_request_instance );
  $pack->inflate( $plack_request_instance );

=head1 DESCRIPTION

This is a module to handle the inflation and deflation of
complex HTTP header types. In many cases header values are
simple strings, but in some cases they are complex values
with a lot of information encoded in them. The goal of this
module is to make the parsing and analysis of these headers
as easy as calling C<inflate> on a compatible object (see
below for a list).

This top-level class is basically a Factory for creating
instances of the other classes in this module. It contains
a number of convenience methods to help make common cases
easy to write.

=head1 DEFAULT MAPPINGS

This class provides a set of default mappings between HTTP
headers and the classes which can inflate them. Here is the
list of default mappings this class provides.

  Link                HTTP::Headers::ActionPack::LinkList
  Content-Type        HTTP::Headers::ActionPack::MediaType
  Accept              HTTP::Headers::ActionPack::MediaTypeList
  Accept-Charset      HTTP::Headers::ActionPack::PriorityList
  Accept-Encoding     HTTP::Headers::ActionPack::PriorityList
  Accept-Language     HTTP::Headers::ActionPack::PriorityList
  Date                HTTP::Headers::ActionPack::DateHeader
  Client-Date         HTTP::Headers::ActionPack::DateHeader
  Expires             HTTP::Headers::ActionPack::DateHeader
  Last-Modified       HTTP::Headers::ActionPack::DateHeader
  If-Unmodified-Since HTTP::Headers::ActionPack::DateHeader
  If-Modified-Since   HTTP::Headers::ActionPack::DateHeader
  WWW-Authenticate    HTTP::Headers::ActionPack::WWWAuthenticate
  Authentication-Info HTTP::Headers::ActionPack::AuthenticationInfo
  Authorization       HTTP::Headers::ActionPack::Authorization

NOTE: The 'Client-Date' header is often added by L<LWP> on
L<HTTP::Response> objects.

=head1 METHODS

=over 4

=item C<new( ?%mappings )>

The constructor takes an option hash of header-name to class
mappings to add too (or override) the default mappings (see
above for details). Each class is expected to have a
C<new_from_string> method which can parse the string
representation of the given header and return an object.

=item C<mapping>

This returns the set of mappings in this instance.

=item C<classes>

This returns the list of supported classes, which is by default
the list of classes included in this modules, but it also
will grab any additionally classes that were specified in the
C<%mappings> parameter to C<new> (see above).

=item C<get_content_negotiator>

Returns an instance of L<HTTP::Headers::ActionPack::ContentNegotiation>.

=item C<create( $class_name, $args )>

This method, given a C<$class_name> and C<$args>, will inflate
the value using the class found in the C<classes> list. If
C<$args> is a string it will call C<new_from_string> on
the C<$class_name>, but if C<$args> is an ARRAY ref, it
will dereference the ARRAY and pass it to C<new>.

=item C<create_header( $header_name, $header_value )>

This method, given a C<$header_name> and a C<$header_value> will
inflate the value using the class found in the mappings. If
C<$header_value> is a string it will call C<new_from_string> on
the class mapped to the C<$header_name>, but if C<$header_value>
is an ARRAY ref, it will dereference the ARRAY and pass it to
C<new>.

=item C<inflate( $http_headers )>

=item C<inflate( $http_request )>

=item C<inflate( $plack_request )>

=item C<inflate( $web_request )>

Given either a L<HTTP::Headers> instance, a L<HTTP::Request>
instance, a L<Plack::Request> instance, or a L<Web::Request>
instance, this method will inflate all the relevant headers
and store the object in the same instance.

In theory this should not negatively affect anything since all
the header objects overload the stringification operator, and
most often the headers are treated as strings. However, this
is not for certain and care should be taken.

=back

=head1 CAVEATS

=head2 Plack Compatibility

We have a test in the suite that checks to make sure that
any inflated header objects will pass between L<HTTP::Request>
and L<HTTP::Response> objects as well as L<Plack::Request>
and L<Plack::Response> objects.

A simple survey of most of the L<Plack::Handler> subclasses
shows that most of them will end up properly stringifying
these header objects before sending them out. The notable
exceptions were the Apache handlers.

At the time of this writing, the solution for this would be
for you to either stringify these objects prior to returning
your Plack::Response, or to write a simple middleware component
that would do that for you. In future versions we might provide
just such a middleware (it would likely inflate the header objects
on the request side as well).

=head2 Stringification

As mentioned above, all the header objects overload the
stringification operator, so normal usage of them should just
do what you would expect (stringify in a sensible way). However
this is not certain and so care should be taken when passing
object headers onto another library that is expecting strings.

=cut
