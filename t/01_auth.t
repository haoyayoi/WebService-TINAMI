use Test::More;
use WebService::TINAMI;
use utf8;

{
    eval { WebService::TINAMI->new };
    like $@, qr/Require api_key/, "mail";
}

{
    eval { WebService::TINAMI->new({ mail => 'mail' }) };
    like $@, qr/Require api_key/, "passwd";
}

{
    eval { WebService::TINAMI->new({ mail => 'mail', passwd => 'passwd' }) };
    like $@, qr/Require api_key/, "api_key";
}

{
    my $tinami = WebService::TINAMI->new({
        mail => 'mail', passwd => 'passwd', api_key => 'key'
    });
    ok $tinami;
}

done_testing();
