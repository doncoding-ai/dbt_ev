
    
    

select
    model_id as unique_field,
    count(*) as n_records

from ANALYTICS.ev.dimension_model
where model_id is not null
group by model_id
having count(*) > 1


