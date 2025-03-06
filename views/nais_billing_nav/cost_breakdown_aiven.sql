SELECT cast(concat(date, '-01') as date) as month,
       'aiven' AS project_name,
       environment as env,
       team,
       tenant,
       CASE WHEN team='nais' THEN 'Plattform' ELSE 'Produktteam' END as cost_category,
       service as service_description,
       sum(cast(cost as numeric)) as calculated_cost,
       status
FROM `nais-analyse-prod-2dcc.nais_billing_nav.aiven_cost_items`
WHERE tenant in ('nav', 'dev-nais')
GROUP BY month, team, environment, service, tenant, status