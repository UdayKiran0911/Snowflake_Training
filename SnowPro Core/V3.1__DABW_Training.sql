create or replace database SMOOTHIES;

use database SMOOTHIES;
use schema PUBLIC;

create or replace table SMOOTHIES.PUBLIC.FRUIT_OPTIONS(FRUIT_ID NUMBER, FRUIT_NAME VARCHAR(25));

create file format smoothies.public.two_headerrow_pct_delim
   type = CSV,
   skip_header = 2,   
   field_delimiter = '%',
   trim_space = TRUE
;

SELECT $1, $2
FROM @SMOOTHIES.PUBLIC.MY_UPLOADED_FILES/fruits_available_for_smoothies.txt
(FILE_FORMAT => smoothies.public.two_headerrow_pct_delim);


COPY INTO smoothies.public.fruit_options
FROM (SELECT $2 as FRUIT_ID, $1 as FRUIT_NAME
    FROM @SMOOTHIES.PUBLIC.MY_UPLOADED_FILES/fruits_available_for_smoothies.txt)
file_format = (format_name = smoothies.public.two_headerrow_pct_delim)
on_error = abort_statement
purge = true; -- purge = true, meaning the file will be removed after the data has been copied

create or replace table SMOOTHIES.PUBLIC.ORDERS(ingredients VARCHAR(200));

insert into smoothies.public.orders(ingredients) values ('Apples Dragon Fruit Figs Jackfruit Orange Elderberries Kiwi ')

select * from smoothies.public.orders;

alter table smoothies.public.orders add column name_on_order varchar(100);

alter table smoothies.public.orders add column ORDER_FILLED BOOLEAN DEFAULT FALSE;

describe table smoothies.public.orders;

update smoothies.public.orders
set order_filled = true
where name_on_order is null;

truncate table smoothies.public.orders;



-- drop sequence if exists smoothies.public.order_seq;
-- select * from SMOOTHIES.PUBLIC.ORDERS ;
-- describe table SMOOTHIES.PUBLIC.ORDERS;
-- alter table SMOOTHIES.PUBLIC.ORDERS drop column order_uid;

create or replace sequence order_seq
    start = 1
    increment = 2
    ORDER
    comment = 'Provide a unique id for each smoothie order';

alter table SMOOTHIES.PUBLIC.ORDERS 
add column order_uid integer --adds the column
default smoothies.public.order_seq.nextval  --sets the value of the column to sequence
constraint order_uid unique enforced; --makes sure there is always a unique value in the column

-- drop table smoothies.public.orders;

create or replace table smoothies.public.orders (
       order_uid integer default smoothies.public.order_seq.nextval,
       order_filled boolean default false,
       name_on_order varchar(100),
       ingredients varchar(200),
       constraint order_uid unique (order_uid),
       order_ts timestamp_ltz default current_timestamp()
);