fix cust.info


SELECT * FROM silver.crm_cust_info
insert into silver.crm_cust_info (
    cst_id,            
    cst_key            ,
    cst_firstname      ,
    cst_lastname       ,
    cst_marital_status ,
    cst_gndr           ,
    cst_create_date    
    )
     SELECT
cst_id,
cst_key,
TRIM(cst_firstname) as cst_firstname,
TRIM(cst_lastname) as cst_lastname,
CASE 
      WHEN(upper(cst_marital_status)) = 'S' then 'Single'
      WHEN(upper(cst_marital_status)) = 'M' then 'Married'
else  'n/a'
end as cst_marital_status,
CASE 
      WHEN(upper(cst_gndr)) = 'M' then 'Male'
      WHEN(upper(cst_gndr)) = 'F' then 'Female'
else  'n/a'
end as cst_gndr,
cst_create_date
From(
Select
*,
ROW_NUMBER() over (
partition by cst_id 
order by cst_create_date DESC
) AS flag_last 
from bronze.crm_cust_info
) AS T
where flag_last = 1 and cst_id is not null;
