SET SERVEROUTPUT ON;
SET VERIFY OFF;

DECLARE
BEGIN
	PC_PARTS_PACKAGE.SHOW_PRODUCTS;
	DBMS_OUTPUT.PUT_LINE(' ');
	DBMS_OUTPUT.PUT_LINE('');
	DBMS_OUTPUT.PUT_LINE('Add two products : ');
	
END;
/


ACCEPT c_name char prompt 'Enter customer name :';
ACCEPT c_contact char prompt 'Enter customer contact no :';
ACCEPT c_address char prompt 'Enter customer address :';

ACCEPT p_id1 number prompt 'Enter 1st product id : '
ACCEPT qnt1 number prompt 'Enter 1st product quantity : '
ACCEPT p_id2 number prompt 'Enter 2nd product id : '
ACCEPT qnt2 number prompt 'Enter 2nd product quantity : '
ACCEPT ok char prompt 'Process the order? [y/n] : '

DECLARE
	
	customer_name orders.customer_name@site2%TYPE;
	customer_contact orders.customer_contact@site2%TYPE;
	customer_address orders.customer_address@site2%TYPE;
	
	
	product_id1 product_view.product_id%TYPE;
	product_id2 product_view.product_id%TYPE;
	product_qnt1 product_view.product_quantity%TYPE;
	product_qnt2 product_view.product_quantity%TYPE;
	
	product1_name product_view.product_name%TYPE;
	product2_name product_view.product_name%TYPE;
	
	process_order char;
	invalid_input EXCEPTION;
	not_enough_product EXCEPTION;
	
	order_idd orders.order_id@site2%TYPE;
	product1_stock number;
	product2_stock number;
	product1_price number;
	product2_price number;
	
	bill number;
	
	sl number :=1;
	
BEGIN
	
	customer_name := '&c_name';
	customer_address := '&c_address';
	customer_contact := '&c_contact';
	
	product_id1 := &p_id1;
	product_id2 := &p_id2;
	product_qnt1:= &qnt1;
	product_qnt2:= &qnt2;
	process_order := '&ok';
	
	if product_id1 is NULL OR product_id1 <= 0 OR
		product_qnt1 is NULL OR product_qnt1 <= 0 OR
		product_id2 is NULL OR product_id2 <= 0 OR
		product_qnt2 is NULL OR product_qnt2 <= 0 OR
		customer_address is NULL OR 
		customer_contact is NULL OR 
		customer_name is NULL THEN
		raise invalid_input;
	end if;
	
	if process_order = 'y' then
		
		
		product1_stock := PC_PARTS_PACKAGE.PRODUCT_IN_STOCK(product_id1,product_qnt1);
		product2_stock := PC_PARTS_PACKAGE.PRODUCT_IN_STOCK(product_id2,product_qnt2);
		
		if product1_stock = 0 OR product2_stock = 0 then
			raise not_enough_product;
		end if;
		
		select count(*) into order_idd from orders@site2;
		order_idd := order_idd + 1;
		
		
		select product_name, unit_price into product1_name, product1_price from product_view where product_id = product_id1;
		select product_name, unit_price into product2_name, product2_price from product_view where product_id = product_id2;
		
		insert into orders@site2 values (order_idd, customer_name, customer_contact, customer_address, TO_CHAR(Sysdate, 'DD-MON-YYYY'));
		
		--DBMS_OUTPUT.PUT_LINE(product1_price*product_qnt1 + product2_price*product_qnt2);
		if (product1_price*product_qnt1 + product2_price*product_qnt2 <=6000) then
			--DBMS_OUTPUT.PUT_LINE('server!');
			insert into order_product@site2 values (order_idd, product_id1, product_qnt1);
			insert into order_product@site2 values (order_idd, product_id2, product_qnt2);
		else
			insert into order_product values (order_idd, product_id1, product_qnt1);
			insert into order_product values (order_idd, product_id2, product_qnt2);
		end if;
		
		if (product1_price<=6000) then
			update product@site2 set product.product_quantity@site2 = product.product_quantity@site2 - product_qnt1 where product.product_id@site2 = product_id1;
		else
			update product set product_quantity = product_quantity - product_qnt1 where product_id = product_id1;
		end if;
		
		if (product2_price<=6000) then
			update product@site2 set product.product_quantity@site2 = product.product_quantity@site2 - product_qnt2 where product.product_id@site2 = product_id2;
		else
			update product set product_quantity = product_quantity - product_qnt2 where product_id = product_id2;
		end if;
		commit;
		DBMS_OUTPUT.PUT_LINE('Order Processed!');
		
		PC_PARTS_PACKAGE.GENERATE_BILL(order_idd);
	else
		DBMS_OUTPUT.PUT_LINE('Order Cancelled');
	end if;
			
		
EXCEPTION		
	WHEN invalid_input THEN
		DBMS_OUTPUT.PUT_LINE('Invalid input!');
	WHEN not_enough_product THEN
		DBMS_OUTPUT.PUT_LINE('Not enought product avaiable!');	
	
END;
/
