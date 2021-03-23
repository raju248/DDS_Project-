SET SERVEROUTPUT ON;
SET VERIFY OFF;


CREATE OR REPLACE PACKAGE PC_PARTS_PACKAGE AS

	PROCEDURE SHOW_PRODUCTS;
	PROCEDURE SHOW_SUPPLIERS;
	PROCEDURE SHOW_CATEGORIES;
	FUNCTION PRODUCT_IN_STOCK(P_ID IN product_view.product_id%TYPE, P_QNT IN product_view.product_quantity%TYPE)
	RETURN NUMBER;
	PROCEDURE GENERATE_BILL(ORDER_IDD IN ORDERS.ORDER_ID%TYPE);

END PC_PARTS_PACKAGE;
/


CREATE OR REPLACE PACKAGE BODY PC_PARTS_PACKAGE AS

	PROCEDURE SHOW_PRODUCTS
	AS
	BEGIN
		dbms_output.put_line(RPAD('Product Id',20,' ')
		|| RPAD('Product Name',30,' ')
		|| RPAD('Product Available',20,' ')
		|| RPAD('Unit Price',20,' '));
		dbms_output.put_line('-------------------------------------------------------------');
		FOR P in (select * from product_view)
		LOOP
			dbms_output.put_line(RPAD(P.product_id,20,' ')
			|| RPAD(P.product_name,30,' ')
			|| RPAD(P.product_quantity,20,' ')
			|| RPAD(P.unit_price,20,' '));
		END LOOP;
		dbms_output.put_line(' ');
	END;

	PROCEDURE SHOW_SUPPLIERS
	AS
	BEGIN

		dbms_output.put_line(RPAD('Supplier Id',20,' ')
		|| RPAD('Supplier Name',20,' ')
		|| RPAD('Supplier Contact',20,' ')
		|| RPAD('Supplier Address',20,' '));
		dbms_output.put_line('----------------------------------------------');
		FOR P in (select * from supplier)
		LOOP
			dbms_output.put_line(RPAD(P.s_id,20,' ')
			|| RPAD(P.s_name,20,' ')
			|| RPAD(P.s_contact,20,' ')
			|| RPAD(P.s_address,20,' '));
		END LOOP;
		dbms_output.put_line(' ');
	END;
	
	
	PROCEDURE SHOW_CATEGORIES
	AS
	BEGIN
		dbms_output.put_line(RPAD('Category Id',30,' ')|| chr(9)||RPAD('Category Name',30,' '));
		dbms_output.put_line('----------------------------------------------');
		FOR C in (select * from categories)
		LOOP
			dbms_output.put_line(RPAD(C.c_id,30,' ') || chr(9) || RPAD(C.c_name,30,' '));
		END LOOP;
		dbms_output.put_line(' ');
	END;
	
	FUNCTION PRODUCT_IN_STOCK(P_ID IN product_view.product_id%TYPE, P_QNT IN product_view.product_quantity%TYPE)
	RETURN NUMBER 
	IS
		p_qnt_available number;
	BEGIN

		select count(1) into p_qnt_available from product_view where product_id = P_ID and product_quantity >= P_QNT;
		
		return p_qnt_available;

	END PRODUCT_IN_STOCK;
	
	
	PROCEDURE GENERATE_BILL(ORDER_IDD IN ORDERS.ORDER_ID%TYPE)
	AS
		bill number;
		c_name orders.customer_name%TYPE;
		c_contact orders.customer_contact%TYPE;
		c_address orders.customer_address%TYPE;
		dt orders.order_date%TYPE;
		sl number :=1;
	BEGIN
		
		select customer_name, customer_contact, customer_address, order_date into c_name, c_contact, c_address, dt from orders where orders.order_id = order_idd;
	
		DBMS_OUTPUT.PUT_LINE('Order ID : ' || ORDER_IDD);
		DBMS_OUTPUT.PUT_LINE('Order Date : ' || dt);
		DBMS_OUTPUT.PUT_LINE('Customer name : ' || c_name);
		DBMS_OUTPUT.PUT_LINE('Customer Contact No : ' || c_contact);
		DBMS_OUTPUT.PUT_LINE('Customer Address : ' || c_address);
		
		
		dbms_output.put_line(RPAD('SL',5,' ')
		|| RPAD('Product ID',15,' ')
		|| RPAD('Product Name',25,' ')
		|| RPAD('Price',10,' ')
		|| RPAD('Qnt. ',10,' ')
		|| RPAD('Total', 10, ' '));
		
		DBMS_OUTPUT.PUT_LINE('-------------------------------------------------------------------------------');
		
		FOR R in (select pd.product_id, pd.product_name, pd.unit_price, op.quantity, op.quantity*pd.unit_price total from orders ords 
		join order_product_view op on ords.order_id = op.order_id 
		join product_view pd on pd.product_id = op.product_id  where ords.order_id = order_idd)
		LOOP
		
			dbms_output.put_line(RPAD(sl,5,' ')
			|| RPAD(R.product_id,15,' ')
			|| RPAD(R.product_name,25,' ')
			|| RPAD(R.unit_price,10,' ')
			|| RPAD(R.quantity,10,' ')
			|| RPAD(R.total, 10, ' '));	
			
			sl := sl + 1;
			
		END LOOP;
		
		select sum(product_view.unit_price*order_product_view.quantity) into bill from orders 
		join order_product_view on orders.order_id = order_product_view.order_id 
		join product_view on product_view.product_id = order_product_view.product_id 
		where orders.order_id = order_idd;
		
		DBMS_OUTPUT.PUT_LINE('ORDER BILL : ' || bill || ' TK.');
	END;
	

END PC_PARTS_PACKAGE;
/
