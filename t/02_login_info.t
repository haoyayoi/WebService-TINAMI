use strict;
use warnings;
use Test::More;
use WebService::TINAMI;
use XML::Simple;

{

    {
        no warnings 'redefine';
        no strict 'refs';
        *{'XML::Simple::XMLin'} = sub { +{ stat => 'ok', no => '122' } }
    }
    my $tinami = WebService::TINAMI->new({ api_key => 'test' });
    my $data = $tinami->login_info;
    is_deeply $data, +{ stat => 'ok', no => '122' }, 'success';
}

done_testing();

