{{- /* Vault Agent Template - Renders secrets to .env format */ -}}
{{- /* Secret path: <SERVICE>/data/<ENV> */ -}}
{{- /* Configure via: VAULT_SECRET_PATH (required) */ -}}
{{- /*               VAULT_SECRET_ENV (required) */ -}}

{{ $service := env "VAULT_SECRET_PATH" }}
{{ $env := env "VAULT_SECRET_ENV" }}
{{ $path := printf "%s/data/%s" $service $env }}

{{ with secret $path }}
{{- range $key, $value := .Data.data }}
{{ $key }}={{ $value }}
{{- end }}
{{ end }}
