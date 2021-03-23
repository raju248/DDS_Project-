SET SERVEROUTPUT ON;
SET VERIFY OFF;

DECLARE
BEGIN
	PC_PARTS_PACKAGE.SHOW_CATEGORIES;
	
	PC_PARTS_PACKAGE.show_suppliers;
END;
/



ACCEPT Name char prompt 'Enter product name : '; 
ACCEPT quantity number prompt 'Enter product quantity : '; 
ACCEPT price number prompt 'Enter unit price : '; 
ACCEPT c_id number prompt 'Enter product category id : '; 
ACCEPT sp_id number prompt 'Enter product supplier id : '; 

DECLARE
	p_id product.product_id%TYPE;
	p_name product.product_name%TYPE;
	p_quantity product.product_quantity%TYPE;
	u_price product.unit_price%TYPE;
	ctg_id product.c_id%TYPE;
	ss_id product.s_id%TYPE;
	
	invalid_input EXCEPTION;
	invalid_category_id EXCEPTION;
	invalid_supplier_id EXCEPTION;
	
	valid_ctg_id number := 0;
	valid_s_id number := 0;
	
BEGIN

	p_name := '&Name';
	p_quantity := &quantity;
	u_price := &price;
	ctg_id := &c_id;
	ss_id := &sp_id;
	
	if p_name is NULL then
		raise invalid_input;
	elsif p_quantity is NULL OR  p_quantity <=0 then
		raise invalid_input;
	elsif u_price is NULL or u_price <=0 then
		raise invalid_input;
	elsif ctg_id is NULL or ctg_id <= 0 then
		raise invalid_input;
	end if;
	
	
	select count(1) into valid_ctg_id from categories where c_id = ctg_id;
	select count(1) into valid_s_id from supplier where supplier.s_id = ss_id;
	
	if valid_ctg_id = 0 then
		raise invalid_category_id;
	elsif valid_s_id = 0 then
		raise invalid_supplier_id;
	end if;
	

	select count(*) into p_id from product_view;
	p_id := p_id + 1;
	
	if(u_price>=6000) then
		insert into product@site1 values (p_id, p_name, p_quantity, u_price, ctg_id, ss_id);
	else
		insert into product values (p_id, p_name, p_quantity, u_price, ctg_id, ss_id);
	end if;
	commit;
	PC_PARTS_PACKAGE.SHOW_PRODUCTS;

EXCEPTION
	WHEN invalid_input THEN
		 DBMS_OUTPUT.PUT_LINE('Invalid input!');
	WHEN invalid_category_id THEN
		DBMS_OUTPUT.PUT_LINE('Invalid category id!');
	WHEN invalid_supplier_id THEN
		DBMS_OUTPUT.PUT_LINE('Invalid supplier id!');
	
END;
/

-- commit;
-- select * from product;