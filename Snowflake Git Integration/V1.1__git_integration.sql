# 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

use role accountadmin;
create or replace database git_demo;
use database git_demo;


create or replace secret git_secrets -- exists at scehma level, PUBLIC is the default schema if not created
    type = password -- if using access token, otherwise choose Auth or SSO etc.
    username = 'UdayKiran0911'
    password = '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';

show secrets;

-- drop secret git_secrets;

create or replace api integration git_private_api_integration -- account level objects
    api_provider = git_https_api
    api_allowed_prefixes = ('https://github.com/UdayKiran0911')
    allowed_authentication_secrets = (git_secrets)
    enabled = true

-- drop api integration git_api_integration;

show api integrations;
show integrations;


create or replace git repository git_private_sr -- schema level object
    api_integration = git_private_api_integration
    git_credentials = git_secrets
    origin = 'https://github.com/UdayKiran0911/private-snow-repo'

-- drop git repository git_private_sr;


show git repositories;


create or replace api integration git_public_api_integration -- account level objects
    api_provider = git_https_api
    api_allowed_prefixes = ('https://github.com/UdayKiran0911')
    enabled = true

create or replace git repository git_public_sr -- schema level object
    api_integration = git_public_api_integration
    origin = 'https://github.com/UdayKiran0911/public-snow-repo'

-- drop git repository git_public_sr;

show git repositories;

show git branches in git repository git_private_sr;
show git branches in git repository git_public_sr;

alter git repository git_private_sr fetch;

ls @git_private_sr/branches/main;

alter git repository git_private_sr fetch;


EXECUTE IMMEDIATE FROM @git_private_sr/branches/main/V1__INVENTORY_TABLE_DDL.SQL;
EXECUTE IMMEDIATE FROM @git_private_sr/branches/main/V2__FILE_FORMAT_DDL.SQL;
EXECUTE IMMEDIATE FROM @git_private_sr/branches/main/V3__STAGE_DDL.SQL;
EXECUTE IMMEDIATE FROM @git_private_sr/branches/main/V4__COPY_STMT.SQL;
EXECUTE IMMEDIATE FROM @git_private_sr/branches/main/V5__STREAM_DDL.SQL;

desc table git_demo.public.invetory;
insert into git_demo.public.invetory values
(1,1,current_date(), 'Hello-01'),
(2,2,current_date(), 'Hello-02'),
(3,3,current_date(), 'Hello-03'),
(4,-1,current_date(), 'Hello-04'),
(5,-2,current_date(), 'Hello-05');

select * from git_demo.public.invetory where column3 = 'Hello-05';

alter git repository git_private_sr fetch;
ls @git_private_sr/branches/main;


EXECUTE IMMEDIATE FROM @git_private_sr/branches/main/V6__CREATE_SP.SQL;

CALL git_demo.public.FILTER_BY_COLUMN_VALUE('INVETORY','Hello-03');