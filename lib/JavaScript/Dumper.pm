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

$JavaScript::Dumper::VERSION = '0.006';

@JavaScript::Dumper::EXPORT = qw(js_dumper);

my $JSON; # cache

sub js_dumper ($) { # encode
    ($JSON ||= __PACKAGE__->new)->encode(@_);
}

###############################

###
### Perl => JSON
###

sub value_to_json {
	my ($self, $value) = @_;
	my $type = ref($value) || "foo"; #spews out awkward warnings without the foo
	if ($type eq "SCALAR" && $$value !~ /^[01]$/) {
		return "true" if($$value eq "1");
		return "false" if($$value eq "0");
		return $$value;
	} elsif($type eq "foo" && $value =~ /^\d+$/ ) {
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

 my $js = js_dumper([{foo => "bar", number => 12345, boolean => \1, call => \"function"}]);
 
 # results in:
 # $js = "[{"foo": "bar", "number" => 12345, "boolean" => true, "call": function}]"; 

=head1 DESCRIPTION

This module uses L<JSON::PP> as base and overrides C<value_to_json> to accept SCALAR-refs to be returned without quotes.

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