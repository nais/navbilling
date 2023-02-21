# navbilling
Bigquery views to break down billing on teams/apps.

## How to import manually created views to terraform
In order to let terraform manage views that have been manually created in the google cloud console, you need to import them to the terraform state.
This needs to be done locally and is not part of the github action.

1. Install terraform.
2. Create a new key for service account `bigquery-view-ci-cd@nais-analyse-dev-8caa.iam.gserviceaccount.com` and download as json.
3. Run `export GOOGLE_CREDENTIALS=<JSON_FILE_NAME.json>`.
4. Add the view definition to `views/<view name>.sql`.
5. Add dataset and view as resources in `bigquery.tf` referring to view definition from step 4.
6. Run `terraform init`.
7. If dataset is not already imported, run `terraform import google_bigquery_dataset.<terraform id of dataset> <dataset name>`.
8. Run `terraform import google_bigquery_table.<terraform id of view> <dataset name>/<view name>`.