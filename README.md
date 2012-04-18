
# HTTP::Headers::ActionPack
## HTTP Action, Adventure and Excitement

This module provides a set of objects which can serialize and
deserialize complex HTTP header types. This is useful if you
need to interrogate the values in these headers for specific
purposes such as content negotiation, link following, etc.

The following headers are supported:

* Link
** as specificed in [http://tools.ietf.org/html/rfc5988]
* Content-Type
** as specified in [http://www.w3.org/Protocols/rfc2616/rfc2616-sec3.html#sec3.7]
* Accept
** parses each media type and organizes them into a priority list
* Accept-Charset, Accept-Encoding and Accept-Language
** parser into a priority list

There is plans to support these headers as well:

* User-Agent
** should use a module for this since it is such a mess
* Authorization, Proxy-Authorization and WWW-Authenticate
** this should handle Basic, Digest and other variations as well
** as specified in [http://www.ietf.org/rfc/rfc2617.txt]
* Content-Range and Range
** basic range parsing

And if we ever need them, we can support these headers as well:

* Cache-Control
** there are lots of things here, but eventually we might need it
* Expect
** not even really sure what this would need, but its a possibility


