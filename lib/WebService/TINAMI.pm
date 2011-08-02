package WebService::TINAMI;

use strict;
use warnings;
use Furl;
use XML::Simple;
use Carp;
use base qw(WebService::TINAMI::Core);
use WebService::TINAMI::Content;

our $VERSION = '0.01';

sub content { WebService::TINAMI::Content->new(shift->_args) }
sub search  { shift->content->search(@_) }
sub login_info {
    my $self = shift;
    $self->_relogin;

    my $res = $self->_info;
    my $ref = $self->xmls->XMLin($res->content);
    if ($ref->{stat} eq 'ok') {
        return $ref;
    }
    else {
        croak $ref->{err}->{msg};
    }
}

1;
__END__

=head1 NAME

WebService::TINAMI -

=head1 SYNOPSIS

  use WebService::TINAMI;

=head1 DESCRIPTION

WebService::TINAMI is

=head1 AUTHOR

Default Name E<lt>default {at} example.comE<gt>

=head1 SEE ALSO

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
