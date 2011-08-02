package WebService::TINAMI;

use strict;
use warnings;
use Furl;
use XML::Simple;
use Carp;
use Class::Accessor::Lite (
    rw => [ qw/furl xmls mail passwd api_key auth_key/ ],
);

our $VERSION = '0.01';

my $TINAMI_API = "http://api.tinami.com";
my $TINAMI_AUTH = $TINAMI_API . "/auth";
my $TINAMI_LOGIN_INFO = $TINAMI_API . "/login/info";

sub new {
    my ($class, $args) = @_;

    for my $key (qw/mail passwd api_key/) {
        if ( (not defined $args->{$key}) || (not $args->{$key} ne '') ) {
            croak "Require $key.";
        }
    }
    my $self = bless $args, $class;
    
    my $furl = Furl->new(
        agent   => "Net::TINAMI::Client version $VERSION",
        timeout => 10,
    );
    $self->furl($furl);
    my $xmls = XML::Simple->new;
    $self->xmls($xmls);
    
    $self->_login;
    return $self;
}

sub _login {
    my $self = shift;

    my $res = $self->furl->post($TINAMI_AUTH, [], 
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

sub info {
    my $self = shift;
    if ($self->_is_expired_api) {
        $self->_login;
    }

    my $res = $self->_info;
    my $ref = $self->xmls->XMLin($res->content);
    if ($ref->{stat} eq 'ok') {
        return $ref;
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
    return $self->furl->get($TINAMI_LOGIN_INFO, [],
        [ api_key => $self->api_key, auth_key => $self->auth_key ],
    );
}

1;
__END__

=head1 NAME

Net::TINAMI -

=head1 SYNOPSIS

  use Net::TINAMI;

=head1 DESCRIPTION

Net::TINAMI is

=head1 AUTHOR

Default Name E<lt>default {at} example.comE<gt>

=head1 SEE ALSO

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
