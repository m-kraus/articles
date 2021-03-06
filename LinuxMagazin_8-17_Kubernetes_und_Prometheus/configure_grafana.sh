#!/bin/bash

echo "Getting Prometheus and Grafana service url from running minikube cluster:"
PROMETHEUS_URL=$(minikube service --namespace=monitoring --url prometheus)
echo "Prometheus: ${PROMETHEUS_URL}"
GRAFANA_URL=$(minikube service --namespace=monitoring --url grafana | sed "s,://,://admin:admin@,g")
echo "Grafana: ${GRAFANA_URL}"

echo "Importing Prometheus-datasource for Grafana"
DATASOURCE=$(cat <<EOF
{
  "name":"prometheus",
  "type":"prometheus",
  "url":"${PROMETHEUS_URL}",
  "access":"proxy",
  "basicAuth": false
}
EOF
)
curl --silent --fail --show-error \
  --request POST ${GRAFANA_URL}/api/datasources \
  --header "Content-Type: application/json" \
  --data-binary "${DATASOURCE}" ;

DASHBOARDS=( 22 737 )
for D in ${DASHBOARDS[@]}; do
echo "Importing Dashboard https://grafana.com/dashboards/${D}"
curl --silent --fail --show-error \
  --request POST ${GRAFANA_URL}/api/dashboards/import \
  --header "Content-Type: application/json" \
  --data-binary "@./grafana_dashboards/${D}.json" ;
done
