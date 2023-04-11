SELECT b.project_name
     , b.project_id
     , b.env
     , b.team
     , COALESCE(b.tenant, 'nav') as tenant
     , (SELECT value from UNNEST(labels) WHERE key='app') as app
     -- TODO: cost_category er veldig ufullstendig
     , CASE
           WHEN starts_with(b.team, 'nais') THEN 'Plattform'
           WHEN b.team in ('nada', 'knada-gcp') THEN 'Dataplattform'
           WHEN b.team = 'isoc' THEN 'ISOC'
           WHEN (b.project_name LIKE '%-dev' OR b.project_name LIKE '%-prod') THEN 'Produktteam'
           ELSE 'Annet'
    END AS cost_category
     , DATE(b.usage_start_time) AS dato
     , b.service_description
     , b.sku_id
     , b.sku_description
     , (SUM(CAST(b.cost * 1000000 AS int64)) + SUM(IFNULL((
                                                              SELECT
                                                                  SUM(IF(c.type != 'COMMITTED_USAGE_DISCOUNT_DOLLAR_BASE', CAST(c.amount * 1000000 AS int64), 0))
                                                              FROM
                                                                  UNNEST(credits) c),
                                                          0))) / 1000000
    AS calculated_cost

FROM `nais-io.nais_billing_regional.gcp_billing_export` b

WHERE b.k8s_namespace IS NULL -- Betyr at det ikke er en GKE-kostnad
  -- CUD som ikke fordeles på team. Inkluderes ved å ikke trekke fra CUD-credits i stedet
  AND b.sku_id NOT IN ('08CF-4B12-9DDF', 'F61D-4D51-AAFC')

GROUP BY project_name, project_id, env, tenant, team, dato, service_description, sku_id, sku_description, app, cost_category