package HTTP::Headers::ActionPack;
use v5.16;
use warnings;
use mop;

use Carp         qw[ confess ];
use Scalar::Util qw[ blessed ];
use List::Util   qw[ first ];

class ContentNegotiation {

    has $!action_pack is ro;

    method choose_media_type ($provided, $header) {
        my $requested       = blessed $header ? $header : $!action_pack->create( 'MediaTypeList' => $header );
        my $parsed_provided = [ map { $!action_pack->create( 'MediaType' => $_ ) } @$provided ];

        my $chosen;
        foreach my $request ( $requested->iterable ) {
            my $requested_type = $request->[1];
            $chosen = $self->_media_match( $requested_type, $parsed_provided );
            return $chosen if $chosen;
        }

        return;
    }

    method choose_language ($provided, $header) {

        return $self->_make_choice(
            choices => $provided,
            header  => $header,
            class   => 'AcceptLanguage',
            matcher => sub { $self->_language_match(@_) },
        );
    }

    method choose_charset ($provided, $header) {

        # NOTE:
        # Making the default charset UTF-8, which
        # is maybe sensible, I dunno.
        # - SL
        return $self->_make_choice(
            choices => $provided,
            header  => $header,
            class   => 'AcceptCharset',
            default => 'UTF-8',
            matcher => sub { $self->_simple_match(@_) },
        );
    }

    method choose_encoding ($provided, $header) {

        return $self->_make_choice(
            choices => $provided,
            header  => $header,
            class   => 'PriorityList',
            default => 'identity',
            matcher => sub { $self->_simple_match(@_) },
        );
    }

    submethod _make_choice (%args) {

        my ($choices, $header, $klass, $default, $matcher)
            = @args{qw( choices header class default matcher )};

        return if @$choices == 0;
        return if $header eq '';

        my $accepted         = blessed $header ? $header : $!action_pack->create( $klass => $header );
        my $star_priority    = $accepted->priority_of( '*' );

        my @canonical = map {
            my $c = $accepted->canonicalize_choice($_);
            $c ? [ $_, $c ] : ()
        } @$choices;

        my ($default_ok, $any_ok);

        if ($default) {
            $default = $accepted->canonicalize_choice($default);
            my $default_priority = $accepted->priority_of( $args{default} );

            if ( not defined $default_priority ) {
                if ( defined $star_priority && $star_priority == 0.0 ) {
                    $default_ok = 0;
                }
                else {
                    $default_ok = 1;
                }
            }
            elsif ( $default_priority == 0.0 ) {
                $default_ok = 0;
            }
            else {
                $default_ok = 1;
            }
        }

        if ( not defined $star_priority ) {
            $any_ok = 0;
        }
        elsif ( $star_priority == 0.0 ) {
            $any_ok = 0;
        }
        else {
            $any_ok = 1;
        }

        my $chosen;
        for my $item ($accepted->iterable) {
            my ($priority, $acceptable) = @$item;

            next if $priority == 0;

            if (my $match = first { $matcher->( $acceptable, $_->[1] ) } @canonical) {
                $chosen = $match->[0];
                last;
            }
        }

        return $chosen if $chosen;

        if ($any_ok) {
            my $match = first {
                my $priority = $accepted->priority_of( $_->[1] );
                return 1 unless defined $priority && $priority == 0;
                return 0;
            }
            @canonical;

            return $match->[0] if $match;
        }

        if ( $default && $default_ok ) {
            my $match = first { $matcher->( $default, $_->[1] ) } @canonical;
            if ($match) {
                my $priority = $accepted->priority_of( $match->[1] );
                return $match->[0] unless defined $priority && $priority == 0;
            }
        }

        return;
    }

    ## ....

    submethod _media_match ($requested, $provided) {
        return $provided->[0] if $requested->matches_all;
        return first { $_->match( $requested ) } @$provided;
    }

    submethod _language_match ($range, $tag) {
        ((lc $range) eq (lc $tag)) || $range eq "*" || $tag =~ /^$range\-/i;
    }

    submethod _simple_match {
        return $_[0] eq $_[1];
    }
}

1;

__END__

=head1 SYNOPSIS

  use HTTP::Headers::ActionPack;

  my $n = HTTP::Headers::ActionPack->new->get_content_negotiator;

  # matches text/html; charset="iso8859-1"
  $n->choose_media_type(
      ["text/html", "text/html;charset=iso8859-1" ],
      "text/html;charset=iso8859-1, application/xml"
  );

  # matches en-US
  $n->choose_language(
      ['en-US', 'es'],
      "da, en-gb;q=0.8, en;q=0.7"
  );

  # matches US-ASCII
  $n->choose_charset(
      [ "UTF-8", "US-ASCII" ],
      "US-ASCII, UTF-8"
  );

  # matches gzip
  $n->choose_encoding(
      [ "gzip", "identity" },
      "gzip, identity;q=0.7"
  );

=head1 DESCRIPTION

This class provides a set of methods used for content negotiation. It makes
full use of all the header objects, such as L<HTTP::Headers::ActionPack::MediaType>,
L<HTTP::Headers::ActionPack::MediaTypeList> and L<HTTP::Headers::ActionPack::PriorityList>.

Content negotiation is a tricky business, it needs to account for such
things as the quality rating, order of elements (both in the header and
in the list of provided items) and in the case of media types it gets
even messier. This module does it's best to figure things out and do what
is expected on it. We have included a number of examples from the RFC
documents in our test suite as well.

=head1 METHODS

=over 4

=item C<choose_media_type ( $provided, $header )>

Given an ARRAY ref of media type strings and an HTTP header, this will
return the appropriately matching L<HTTP::Headers::ActionPack::MediaType>
instance.

=item C<choose_language ( $provided, $header )>

Given a list of language codes and an HTTP header value, this will attempt
to negotiate the best language match. It will return the language string
that best matched.

=item C<choose_charset ( $provided, $header )>

Given a list of charset names and an HTTP header value, this will attempt
to negotiate the best charset match. It will return the name of the charset
that best matched.

=item C<choose_encoding ( $provided, $header )>

Given a list of encoding names and an HTTP header value, this will attempt
to negotiate the best encoding match. It will return the name of the encoding
which best matched.

=back

=head1 SEE ALSO

L<HTTP::Negotiate>

There is nothing wrong with this module, however it attempts to answer all
the negotiation questions at once, whereas this module allows you to do it
one thing at a time.

=cut
