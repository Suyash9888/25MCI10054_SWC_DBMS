with cte as
(select transaction_id,
merchant_id,
credit_card_id, 
amount,
transaction_timestamp,
lag(transaction_timestamp) over( Partition by merchant_id, credit_card_id, amount
order by transaction_timestamp
)
as prev_transaction
from transactions)

select  count(*) as payment_count
from cte 
where prev_transaction is not NULL and  transaction_timestamp <=
prev_transaction + interval '10 minutes';