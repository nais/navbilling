select * from `nais-io.aiven_cost_regional.cost_breakdown_aiven_daily`
where tenant in ('nav', 'dev-nais', 'ci-nais', 'test-nais')