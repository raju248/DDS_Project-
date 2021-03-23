--drop table staff;
drop table order_product;
drop table orders;
--drop table branch;
--drop table product_supplier;
drop table product;
drop table supplier;
drop table categories;



create table categories
(
    c_id int primary key,
    c_name varchar2(20) not null
);


insert into categories values (1,'Keyboard');
insert into categories values (2,'Mouse');
INSERT INTO CATEGORIES VALUES (3, 'Processor');
INSERT INTO CATEGORIES VALUES (4, 'Ram');


create table supplier
(   
    s_id int primary key,
    s_name varchar2(50) not null,
    s_contact varchar2(50) not null,
    s_address varchar2(70) not null
);


insert into supplier values(1,'Smart Tech','0175963499','Multiplan');
insert into supplier values(2,'Global brand','0175963480','BCS Computer City');


create table product
(
    product_id int primary key,
    product_name varchar2(50) not null,
    product_quantity int not null,
	unit_price int not null,
    c_id int not null,
    foreign key (c_id) references categories(c_id) on delete cascade,
    s_id int not null,
	foreign key (s_id) references supplier(s_id) on delete cascade
);


insert into product values (1, 'Logitech G402 Mouse',20,3300,2,1);
insert into product values (2, 'Fantech K611',10,1700,1,2);
INSERT INTO PRODUCT VALUES (3, 'AMD Ryzen 5 3600', 100, 18500, 3, 1);
INSERT INTO PRODUCT VALUES (5, 'Intel Core i5', 100, 16000, 3, 1);


create table orders
(
    order_id int primary key,
    customer_name varchar2(50) not null,
    customer_contact varchar2(50) not null,
    customer_address varchar2(50) not null,
	order_date DATE default CURRENT_DATE
);


insert into orders values (1, 'Mahi', '01816544844', 'Mohanogor project', '19-MAR-2021');
insert into orders values (2, 'Ador', '01754089800', 'Rongpur', '18-MAR-2021');
insert into orders values (3, 'Rajib', '01816544480', 'Luxmibazar', '17-MAR-2021');
insert into orders values (4, 'Ashik', '014694089780', 'Bonosree', '17-MAR-2021');


create table order_product
(
    order_id int not null,
    foreign key (order_id) references orders(order_id) on delete cascade ,
    product_id int not null,
    foreign key (product_id) references  product(product_id) on delete cascade ,
    quantity int not null
);


insert into order_product values (1,1,2);
insert into order_product values (1,2,1);
insert into order_product values (2,2,1);

insert into order_product values (3,2,10);
insert into order_product values (3,1,5);
insert into order_product values (4,1,6);



-- select * from product;
-- select * from orders;
-- select * from order_product;

-- create table order_product
-- (
    -- order_id int not null,
    -- product_id int not null,
    -- quantity int not null
-- );


create table product
(
    product_id int primary key,
    product_name varchar2(50) not null,
    product_quantity int not null,
	unit_price int not null,
    c_id int not null,
    s_id int not null,
);