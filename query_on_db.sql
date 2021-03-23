SET lin 200;
SET SERVEROUTPUT ON;
SET VERIFY OFF;

DECLARE

BEGIN
	DBMS_OUTPUT.PUT_LINE('Select a option');
	DBMS_OUTPUT.PUT_LINE('1. Today''s total sale.');
	DBMS_OUTPUT.PUT_LINE('2. Most Sold Product. ');
	DBMS_OUTPUT.PUT_LINE('3. Days with maximum sale.');
END;
/



ACCEPT X number prompt 'Enter a option : ';
DECLARE
	op number := &X;
	today_sale number:=0;
	most_sold_product product_view.product_name%TYPE;
	
BEGIN
	
	if op = 1 then
	
		select sum(order_product_view.quantity * product_view.unit_price) into today_sale 
		from orders join order_product_view on orders.order_id = order_product_view.order_id 
		join product_view on product_view.product_id = order_product_view.product_id where order_date = TO_CHAR(Sysdate, 'DD-MON-YYYY');
		
		if today_sale =0 then
			DBMS_OUTPUT.PUT_LINE('No sale found.');
		else
			DBMS_OUTPUT.PUT_LINE('Today''s sale : ' || today_sale || ' TK.');
		end if;
		
		
	elsif op = 2 then
		FOR P in (select * from product_sale_count_view where quantity_sold = (select max(quantity_sold) from product_sale_count_view))
		LOOP
			dbms_output.put_line(RPAD('Product Name ',20,' ') || RPAD('Quantity Sold ',20,' '));
			dbms_output.put_line('------------------------------------------------------------');
			dbms_output.put_line(RPAD(P.product_name,20,' ') || '|' || RPAD(P.quantity_sold,20,' '));
		END LOOP;
		
	elsif op = 3 then
		FOR S in (select order_date, amountSold from date_wise_sale where amountSold
		= (Select max(amountSold) from date_wise_sale))
		LOOP
			dbms_output.put_line(RPAD('Date ',20,' ') || RPAD('Amount',20,' '));
			dbms_output.put_line('------------------------------------------------------------');
			dbms_output.put_line(RPAD(S.order_date,20,' ') || '|' || RPAD(S.amountSold,20,' '));
		END LOOP;
		
	end if;
END;
/

