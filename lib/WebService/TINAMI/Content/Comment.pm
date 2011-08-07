package WebService::TINAMI::Content::Comment;
use strict;
use warnings;
use utf8;
use base qw(WebService::TINAMI::Core);
use Carp;

sub list_api   { shift->api_base . "/content/comment/list" }
sub add_api    { shift->api_base . "/content/comment/add" }
sub remove_api { shift->api_base . "/content/comment/remove" }

sub list {
    my ($self, $args) = @_;
    
    if ( (not defined $args->{cont_id}) || (not $args->{cont_id} ne '') ) {
        croak "Need content_id";
    }

    my $res = $self->furl->get($self->list_api);
    if ($res->is_success) {
        return $self->xmls->XMLin($res->content);
    }
}

sub add {
    my ($self, $args) = @_;
    
    if ( (not defined $args->{cont_id}) || (not $args->{cont_id} ne '') ) {
        croak "Need content_id";
    }

    my $res = $self->furl->get($self->add_api);
    if ($res->is_success) {
        return $self->xmls->XMLin($res->content);
    }
}

sub remove {
    my ($self, $args) = @_;
    
    if ( (not defined $args->{cont_id}) || (not $args->{cont_id} ne '') ) {
        croak "Need content_id";
    }

    my $res = $self->furl->get($self->remove_api);
    if ($res->is_success) {
        return $self->xmls->XMLin($res->content);
    }
}

1;
