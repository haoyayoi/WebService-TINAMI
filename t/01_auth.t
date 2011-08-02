use Test::More;
use WebService::TINAMI;
use utf8;

{
    eval { WebService::TINAMI->new };
    like $@, qr/mail/, "mail";
}

{
    eval { WebService::TINAMI->new({ mail => 'mail' }) };
    like $@, qr/passwd/, "passwd";
}

{
    eval { WebService::TINAMI->new({ mail => 'mail', passwd => 'passwd' }) };
    like $@, qr/api_key/, "api_key";
}

{
    eval { WebService::TINAMI->new({
        mail => 'mail', passwd => 'passwd', api_key => 'key'
    }) };
    like $@, qr/APIキーが指定されていないか、値が不正です/, "api_key";
}


done_testing();
