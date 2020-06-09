#!/bin/bash

HEADER="Content-Type: application/json"

#   CONNECT_SSL_ENDPOINT_IDENTIFICATION_ALGORITHM: "HTTPS"
#   CONNECT_REST_ADVERTISED_HOST_NAME: "connect"
#  https://connect:8083/connectors

sleep 1
docker exec connect curl -X POST -H "${HEADER}" --data @../../aws-rumo-integ-source-translogic-tfa-incrementing-1.json http://localhost:8083/connectors
sleep 1
docker exec connect curl -X POST -H "${HEADER}" --data @../../aws-rumo-integ-sink-tfa-prisma-0.json http://localhost:8083/connectors
sleep 1
docker exec connect curl -X POST -H "${HEADER}" --data @../../aws-rumo-integ-source-translogic-tfa-timestamp-1.json http://localhost:8083/connectors
sleep 1
docker exec connect curl -X POST -H "${HEADER}" --data "${DATA4}" http://localhost:8083/connectors
#docker exec connect curl -X PUT  -H "${HEADER}" --data "${DATA5}" http://localhost:8083/connectors

echo "Sleeping 30 seconds to wait for all connectors to come up"
sleep 30
docker exec connect curl http://localhost:8083/connectors/src_mysql_ts/status|jq
docker exec connect curl http://localhost:8083/connectors/src_mysql_txn/status|jq
docker exec connect curl http://localhost:8083/connectors/src_mysql_bulk/status|jq
docker exec connect curl http://localhost:8083/connectors/sink_postgres/status|jq
docker exec connect curl http://localhost:8083/connectors/|jq
