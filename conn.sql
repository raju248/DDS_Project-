drop database link site1;


create database link site1
 connect to system identified by "22448800"
 using '(DESCRIPTION =
       (ADDRESS_LIST =
         (ADDRESS = (PROTOCOL = TCP)
		 (HOST = 192.168.0.104)
		 (PORT = 1621))
       )
       (CONNECT_DATA =
         (SID = XE)
       )
     )'
;  

-- create database link site2
 -- connect to system identified by "12345"
 -- using '(DESCRIPTION =
       -- (ADDRESS_LIST =
         -- (ADDRESS = (PROTOCOL = TCP)
		 -- (HOST = 192.168.0.107)
		 -- (PORT = 1622))
       -- )
       -- (CONNECT_DATA =
         -- (SID = XE)
       -- )
     -- )'
-- ;