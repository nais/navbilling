SELECT
    project.name project_name,
    project.id project_id,
    (SELECT value from UNNEST(project.labels) WHERE key='team') as team,
    (SELECT value from UNNEST(project.labels) WHERE key='environment') as env,
    (SELECT value from UNNEST(project.labels) WHERE key='tenant') as tenant,
    (SELECT value from UNNEST(labels) WHERE key='k8s-namespace') as k8s_namespace,
    (SELECT value from UNNEST(labels) WHERE key='k8s-label/app') as k8s_app,
    service.description service_description,
    sku.id sku_id,
    sku.description sku_description,
    usage_start_time,
    usage_end_time,
    usage.amount usage_amount,
    usage.unit usage_unit,
    cost,
    credits,
    labels
FROM `nais-io.nais_billing_regional.gcp_billing_export_resource_v1_014686_D32BB4_68DF8E`