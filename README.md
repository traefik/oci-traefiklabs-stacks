# oci-traefiklabs-stacks

To launch it locally, you'll need to go back to latest terraform version before license change:

```sh
sudo apt-get install terraform=1.5.7-1
```

and set those env. variables:

```sh
export TF_VAR_chart_hub_token=
export TF_VAR_chart_hub_version="v3.17.0"
export TF_VAR_chart_namespace="traefik"
export TF_VAR_chart_values=""
export TF_VAR_region="eu-madrid-1"
export TF_VAR_tenancy_ocid=""
export TF_VAR_compartment_ocid=""
export TF_VAR_oke_cluster_create=true
export TF_VAR_chart_create_namespace=true
export TF_VAR_local_run=true
```
