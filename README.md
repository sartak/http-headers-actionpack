# NAME

HTTP::Headers::ActionPack - HTTP Action, Adventure and Excitement

# VERSION

version 0.10

# SYNOPSIS

    use HTTP::Headers::ActionPack;

    my $pack       = HTTP::Headers::ActionPack->new;
    my $media_type = $pack->create_header( 'Content-Type' => 'application/xml;charset=UTF-8' );
    my $link       = $pack->create( 'LinkHeader' => [ '</test/tree>', rel => "up" ] );

    # auto-magic header inflation
    # for multiple types
    $pack->inflate( $http_headers_instance );
    $pack->inflate( $http_request_instance );
    $pack->inflate( $plack_request_instance );

# DESCRIPTION

This is a module to handle the inflation and deflation of
complex HTTP header types. In many cases header values are
simple strings, but in some cases they are complex values
with a lot of information encoded in them. The goal of this
module is to make the parsing and analysis of these headers
as easy as calling `inflate` on a compatible object (see
below for a list).

This top-level class is basically a Factory for creating
instances of the other classes in this module. It contains
a number of convenience methods to help make common cases
easy to write.

# DEFAULT MAPPINGS

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

NOTE: The 'Client-Date' header is often added by [LWP](https://metacpan.org/pod/LWP) on
[HTTP::Response](https://metacpan.org/pod/HTTP::Response) objects.

# METHODS

- `new( ?%mappings )`

    The constructor takes an option hash of header-name to class
    mappings to add too (or override) the default mappings (see
    above for details). Each class is expected to have a
    `new_from_string` method which can parse the string
    representation of the given header and return an object.

- `mappings`

    This returns the set of mappings in this instance.

- `classes`

    This returns the list of supported classes, which is by default
    the list of classes included in this modules, but it also
    will grab any additionally classes that were specified in the
    `%mappings` parameter to `new` (see above).

- `get_content_negotiator`

    Returns an instance of [HTTP::Headers::ActionPack::ContentNegotiation](https://metacpan.org/pod/HTTP::Headers::ActionPack::ContentNegotiation).

- `create( $class_name, $args )`

    This method, given a `$class_name` and `$args`, will inflate
    the value using the class found in the `classes` list. If
    `$args` is a string it will call `new_from_string` on
    the `$class_name`, but if `$args` is an ARRAY ref, it
    will dereference the ARRAY and pass it to `new`.

- `create_header( $header_name, $header_value )`

    This method, given a `$header_name` and a `$header_value` will
    inflate the value using the class found in the mappings. If
    `$header_value` is a string it will call `new_from_string` on
    the class mapped to the `$header_name`, but if `$header_value`
    is an ARRAY ref, it will dereference the ARRAY and pass it to
    `new`.

- `inflate( $http_headers )`
- `inflate( $http_request )`
- `inflate( $plack_request )`
- `inflate( $web_request )`

    Given either a [HTTP::Headers](https://metacpan.org/pod/HTTP::Headers) instance, a [HTTP::Request](https://metacpan.org/pod/HTTP::Request)
    instance, a [Plack::Request](https://metacpan.org/pod/Plack::Request) instance, or a [Web::Request](https://metacpan.org/pod/Web::Request)
    instance, this method will inflate all the relevant headers
    and store the object in the same instance.

    In theory this should not negatively affect anything since all
    the header objects overload the stringification operator, and
    most often the headers are treated as strings. However, this
    is not for certain and care should be taken.

# CAVEATS

## Plack Compatibility

We have a test in the suite that checks to make sure that
any inflated header objects will pass between [HTTP::Request](https://metacpan.org/pod/HTTP::Request)
and [HTTP::Response](https://metacpan.org/pod/HTTP::Response) objects as well as [Plack::Request](https://metacpan.org/pod/Plack::Request)
and [Plack::Response](https://metacpan.org/pod/Plack::Response) objects.

A simple survey of most of the [Plack::Handler](https://metacpan.org/pod/Plack::Handler) subclasses
shows that most of them will end up properly stringifying
these header objects before sending them out. The notable
exceptions were the Apache handlers.

At the time of this writing, the solution for this would be
for you to either stringify these objects prior to returning
your Plack::Response, or to write a simple middleware component
that would do that for you. In future versions we might provide
just such a middleware (it would likely inflate the header objects
on the request side as well).

## Stringification

As mentioned above, all the header objects overload the
stringification operator, so normal usage of them should just
do what you would expect (stringify in a sensible way). However
this is not certain and so care should be taken when passing
object headers onto another library that is expecting strings.

# SUPPORT

bugs may be submitted through [https://github.com/houseabsolute/http-headers-actionpack/issues](https://github.com/houseabsolute/http-headers-actionpack/issues).

# AUTHORS

- Stevan Little <stevan@cpan.org>
- Dave Rolsky <autarch@urth.org>

# CONTRIBUTORS

- Andrew Nelson <anelson@cpan.org>
- Florian Ragwitz <rafl@debian.org>
- Jesse Luehrs <doy@tozt.net>
- Karen Etheridge <ether@cpan.org>

# COPYRIGHT AND LICENCE

This software is copyright (c) 2012 - 2016 by Infinity Interactive, Inc.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.
