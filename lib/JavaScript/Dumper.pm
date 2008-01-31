package JavaScript::Dumper;

# JSON-2.0

use 5.005;
use strict;
require Exporter;
use base "JSON::PP";
use overload;

use Carp ();
use B ();

use Class::C3;
#use Devel::Peek;

$JavaScript::Dumper::VERSION = '0.001';

@JavaScript::Dumper::EXPORT = qw(js_dumper);

*js_dumper = *to_json;   # will be obsoleted.

# Functions

my %encode_allow_method
     = map {($_ => 1)} qw/utf8 pretty allow_nonref latin1 allow_tied self_encode escape_slash
                          allow_blessed convert_blessed
                        /;
my %decode_allow_method
     = map {($_ => 1)} qw/utf8 allow_nonref disable_UTF8 strict singlequote allow_bigint
                          allow_barekey literal_value max_size relaxed/;


sub to_json { # encode
    my ($obj, $opt) = @_;

    if ($opt) {
        my $json = JavaScript::Dumper->new->utf8;

        for my $method (keys %$opt) {
            Carp::croak("non acceptble option")
                unless (exists $encode_allow_method{$method});
            $json->$method($opt->{$method});
        }

        return $json->encode($obj);
    }
    else {
        return __PACKAGE__->new->utf8->encode($obj);
    }

}


sub from_json { # decode
    my ($obj, $opt) = @_;

    if ($opt) {
        my $json = JavaScript::Dumper->new->utf8;

        for my $method (keys %$opt) {
            Carp::croak("non acceptble option")
                unless (exists $decode_allow_method{$method});
            $json->$method($opt->{$method});
        }

        return $json->decode($obj);
    }
    else {
        __PACKAGE__->new->utf8->decode(shift);
    }
}



###############################

###
### Perl => JSON
###

sub valueToJson {
	my ($self, $value) = @_;
	my $type = ref($value);
	if ($type eq 'SCALAR' &&  $$value !~ /^[01]$/) {
		return "true" if($$value eq "1");
		return "false" if($$value eq "0");
		return $$value;
	} elsif(!$type && $value =~ /^\d+$/ ) {
		return $value;
	}
	$self->next::method($value);
}


###############################
# Utilities
#

BEGIN {

}





1;
__END__
=pod

=head1 NAME

JavaScript::Dumper - Dump JavaScript data structures from Perl objects. Allows unquoted strings and numbers. 

=head1 SYNOPSIS

 use JavaScript::Dumper;

 my $js = js_dumper([{foo => "bar", call => \"function"}]);
 
 # results in:
 # $js = "[{"foo": "bar", "call": function}]"; 

=head1 DESCRIPTION

This module uses L<JSON::PP> as base and overrides C<valueToJson> to accept SCALAR-refs to be returned without quotes.

=head1 FUNCTIONS

=over

=item js_dumper

Dumps any perl data structure.

\'1' becomes "true"
\'0' becomes "false"

See L<JSON::PP> or L<JSON::XS> for more details.

=back


=head1 METHODS

=over

=item new

Returns JavaScript::Dumper object.

=item others

For all other methods see JSON::PP and JSON::XS.

=back


=head1 CAVEATS

JavaScript::Dumper is as slow as JSON::PP. You might want to cache the output or use it only for small objects.


=head1 TODO

=over

=item JavaScript::Dumper::XS

Find someone who does a speedy version of this module

=back


=head1 SEE ALSO

L<JSON::PP>, L<JSON::XS>

=head1 AUTHOR

Moritz Onken (perler)

=head1 COPYRIGHT AND LICENSE

Copyright 2007 by Moritz Onken

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself. 

=cut
