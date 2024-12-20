#!/bin/bash

echo "Waiting for Schema Registry to be ready..."

# Wait until Schema Registry is available
until curl -s http://schema-registry:8081/subjects; do
  echo "Schema Registry not ready yet. Retrying..."
  sleep 5
done

echo "Registering Avro schema..."

# Register the Avro schema to Schema Registry
curl -X POST -H "Content-Type: application/vnd.schemaregistry.v1+json" \
  --data "{\"schema\": $(cat /schema-init/my-schema.avsc | jq -Rs .)}" \
  http://schema-registry:8081/subjects/my-topic-value/versions

echo "Schema registered successfully."
