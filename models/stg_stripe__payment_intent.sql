
with base as (

    select * 
    from {{ ref('stg_stripe__payment_intent_tmp') }}
),

fields as (

    select
        {{
            fivetran_utils.fill_staging_columns(
                source_columns=adapter.get_columns_in_relation(ref('stg_stripe__payment_intent_tmp')),
                staging_columns=get_payment_intent_columns()
            )
        }}
    from base
),

final as (
    
    select 
        id as payment_intent_id,
        amount,
        amount_capturable,
        amount_received,
        application,
        application_fee_amount,
        canceled_at,
        cancellation_reason,
        capture_method,
        confirmation_method,
        created as created_at,
        currency,
        customer_id,
        description,
        metadata,
        payment_method_id,
        receipt_email,
        statement_descriptor,
        status

        {% if var('stripe__payment_intent_metadata',[]) %}
        , {{ fivetran_utils.pivot_json_extract(string = 'metadata', list_of_properties = var('stripe__payment_intent_metadata')) }}
        {% endif %}

    from fields
)

select * 
from final
