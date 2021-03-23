SET SERVEROUTPUT ON;
SET VERIFY OFF;



ACCEPT name char prompt 'Enter supplier name :';
ACCEPT contact char prompt 'Enter supplier contact no :';
ACCEPT address char prompt 'Enter supplier address :';

DECLARE
	s_name supplier.s_name%TYPE;
	s_contact supplier.s_contact%TYPE;
	s_address supplier.s_address%TYPE;
	invalid_input EXCEPTION;
	s_id supplier.s_id%TYPE;
	
BEGIN

	s_name := '&name';
	s_contact := '&contact';
	s_address := '&address';
	
	if s_name is NULL 
	OR s_contact is NULL 
	OR s_address is NULL
	then
		raise invalid_input;
	end if;
	
	
	select count(*) into s_id from supplier;
	s_id := s_id + 1;
	
	insert into supplier values (s_id, s_name, s_contact, s_address); 
	commit;

EXCEPTION
	WHEN invalid_input THEN
		 DBMS_OUTPUT.PUT_LINE('Invalid input!');
	
END;
/

-- commit;
-- select * from product;