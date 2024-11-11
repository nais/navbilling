SELECT 'aiven' AS project_name,
       environment as env,
       team,
       tenant,
       CASE WHEN team='nais' THEN 'Plattform' ELSE 'Produktteam' END as cost_category,
       date as dato,
       service as service_description,
       service as sku_id,
       sum(costInEuros) as calculated_cost
FROM `nais-analyse-prod-2dcc.aivencost.costitemsv2`
GROUP BY date, team, environment, service, tenant