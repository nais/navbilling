select
    *
from
    `nais-io.aiven_cost_regional.kafka_cost`
where
    tenant in ('nav', 'dev-nais', 'ci-nais')