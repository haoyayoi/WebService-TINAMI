package WebService::TINAMI::Core;

use strict;
use warnings;
use Furl;
use XML::Simple;
use Carp;
use Class::Accessor::Lite (
    rw => [ qw/mail passwd api_key auth_key/ ],
);

our $VERSION = '0.01';

my $TINAMI_API = "http://api.tinami.com";

sub xmls { XML::Simple->new }

sub furl {
    Furl->new(
        agent   => "WebService::TINAMI::Client version $VERSION",
        timeout => 10,
    );
}

sub new {
    my ($class, $args) = @_;

    if ( (not defined $args->{api_key}) || (not $args->{api_key} ne '') ) {
        croak "Require api_key";
    }
    return bless $args, $class;
}

sub api_base           { $TINAMI_API }
sub auth_api           { shift->api_base . "/auth" }
sub login_info_api     { shift->api_base . "/login/info" }
sub content_search_api { shift->api_base . "/content/search" }
sub content_info_api   { shift->api_base . "/content/info" }
sub content_support_api{ shift->api_base . "/content/support" }
sub _args { 
    +{ 
        mail    => $_[0]->{mail},
        passwd  => $_[0]->{passwd},
        api_key => $_[0]->{api_key}
    }
}

sub _relogin {
    my $self = shift;
    if ($self->_is_expired_api) {
        $self->_login;
    }
}

sub _login {
    my $self = shift;

    my $res = $self->furl->post($self->auth_api, [], 
        [ email => $self->mail, password => $self->passwd, api_key => $self->api_key ] );
    unless ($res->is_success) {
        croak $res->status;
    }
    
    my $ref = $self->xmls->XMLin($res->content);
     
    if ($ref->{stat} eq 'ok') {
        $self->{auth_key} = $ref->{auth_key};
    }
    else {
        croak $ref->{err}->{msg};
    }
}

sub _is_expired_api {
    my $self = shift;
    my $res = $self->_info;
    ($res->content =~ m{認証キーの有効期限が切れました}) ? 1 : 0 ;
}

sub _info {
    my $self = shift;
    $self->furl->get($self->login_info_api, [],
        [ api_key => $self->api_key, auth_key => $self->auth_key ],
    );
}

sub _get {
    my $self = shift;
    my $res = $self->furl->get(@_);
    return $self->xmls->XMLin($res->content) if $res->is_success;
}

1;
__END__

=head1 NAME

WebService::TINAMI::Core -

=head1 SYNOPSIS

  use base qw(WebService::TINAMI::Core);

=head1 DESCRIPTION

WebService::TINAMI::Core is for override

=head1 AUTHOR

Default Name E<lt>default {at} example.comE<gt>

=head1 SEE ALSO

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
