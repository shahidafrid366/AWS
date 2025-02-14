{{/*
Create a unique app name
*/}}
{{- define "hello-kubernetes.name" -}}
{{- printf "%s-%s" .Chart.Name .Release.Name | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "hello-kubernetes.labels" -}}
{{ include "hello-kubernetes.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "hello-kubernetes.selectorLabels" -}}
app.kubernetes.io/name: {{ .Chart.Name }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create a unique app name for Python Microservice
*/}}
{{- define "python.name" -}}
{{- printf "%s-python-%s" .Chart.Name .Release.Name | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels for Python Microservice
*/}}
{{- define "python.labels" -}}
{{ include "python.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
{{- end }}

{{/*
Selector labels for Python Microservice
*/}}
{{- define "python.selectorLabels" -}}
app.kubernetes.io/name: python-microservice
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}
