package WebService::TINAMI::Content;

use strict;
use warnings;
use utf8;
use base qw(WebService::TINAMI);

our $VERSION = '0.01';

sub search {
    my ($self, $args) = @_;
    
    unless ($args->{sort} =~ m{v(alue|iew)|new|score|rand}) {
        delete $args->{sort};
    }

    my @cont_type;
    for my $i (@{$args->{cont_type}}) {
        if ($i =~ m{1|2|3|4|5}) {
            unless ( grep (/$i/, @cont_type) ) {
                push @cont_type, $i;
            }
        }
    }
    $args->{'cont_type[]'} = \@cont_type if @cont_type;
 
    $self->_relogin;
    my $res = $self->furl->get($self->content_search_api, [], $args);
    if ($res->is_success) {
        return $self->xmls->XMLin($res->content);
    }
    else {
        return $res->status;
    }
}

1;
__END__

=head1 NAME

WebService::TINAMI::Content -

=head1 SYNOPSIS

  use WebService::TINAMI::Content;

=head1 DESCRIPTION

WebService::TINAMI::Content is

=head1 AUTHOR

Default Name E<lt>default {at} example.comE<gt>

=head1 SEE ALSO

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
