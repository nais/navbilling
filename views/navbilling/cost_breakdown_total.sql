(
    SELECT cluster
         , project_name
         , namespace
         , env
         , team
         , tenant
         , app
         , cost_category
         , dato
         , service_description
         , sku_id
         , sku_description
         , calculated_cost
         , 'gke (nais)' as source
         , 'Google Cloud' as vendor

    FROM `nais-analyse-prod-2dcc.navbilling.cost_breakdown_nais`

    UNION ALL

    SELECT NULL AS cluster
         , project_name
         , NULL AS namespace
         , env
         , team
         , tenant
         , app
         , cost_category
         , dato
         , service_description
         , sku_id
         , sku_description
         , calculated_cost
         , 'gcp-ressurser' as source
         , 'Google Cloud' as vendor

    FROM `nais-analyse-prod-2dcc.navbilling.cost_breakdown_excluding_nais`

    UNION ALL

    SELECT NULL as cluster
         , project_name
         , NULL as namespace
         , env
         , team
         , tenant
         , NULL as app
         , cost_category
         , dato
         , service_description
         , sku_id
         , NULL as sku_description
         , calculated_cost
         , 'aiven' as source
         , 'Aiven' as vendor

    FROM `nais-analyse-prod-2dcc.navbilling.cost_breakdown_aiven`


)