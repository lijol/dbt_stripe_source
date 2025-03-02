{{ config(enabled=var('using_credit_notes', False)) }}

with base as (

    select * 
    from {{ ref('stg_stripe__credit_note_line_item_tmp') }}
),

fields as (

    select
        {{
            fivetran_utils.fill_staging_columns(
                source_columns=adapter.get_columns_in_relation(ref('stg_stripe__credit_note_line_item_tmp')),
                staging_columns=get_credit_note_line_item_columns()
            )
        }}
    from base
),

final as (
    
    select 
        id as credit_note_line_item_id,
        credit_note_id,
        amount,
        discount_amount,
        description,
        quantity,
        type,
        unit_amount,
        unit_amount_decimal
    from fields
)

select * 
from final
