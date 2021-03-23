drop view product_view;
CREATE VIEW product_view AS
Select * from product
union
select * from product@site2; 

drop view order_product_view;
CREATE VIEW order_product_view AS
Select * from order_product
union
select * from order_product@site2; 



drop view date_wise_sale;
create or replace view date_wise_sale as
(select orders.order_date@site2, sum(product_view.unit_price*order_product_view.quantity) amountSold 
from order_product_view, orders@site2, product_view where order_product_view.order_id = orders.order_id@site2
and order_product_view.product_id = product_view.product_id group by orders.order_date@site2);


drop view product_sale_count_view;
create or replace view product_sale_count_view as
select product_view.product_id, product_name, sum(order_product_view.quantity) as quantity_sold from order_product_view, product_view 
where product_view.product_id = order_product_view.product_id group by product_view.product_id, product_view.product_name;
