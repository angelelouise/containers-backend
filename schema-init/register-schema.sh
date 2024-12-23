#!/bin/bash

echo "Waiting for Kafka to be ready..."

# Wait for Kafka to be ready
until nc -z kafka 9092; do
  echo "Kafka not ready yet. Retrying..."
  sleep 5
done

echo "Creating Kafka topic..."

# Create Kafka topic
kafka-topics --create \
  --bootstrap-server kafka:9092 \
  --replication-factor 1 \
  --partitions 1 \
  --topic my-topic

echo "Kafka topic 'my-topic' created successfully."

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
