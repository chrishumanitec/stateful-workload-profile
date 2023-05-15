{{/* vim: set filetype=mustache: */}}

{{/* Create chart name and version as used by the chart label. */}}
{{- define "stateful-workload.chart" }}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end }}

{{/* Common labels */}}
{{- define "stateful-workload.labels" }}
helm.sh/chart: {{ include "stateful-workload.chart" . }}
{{ include "stateful-workload.selectorLabels" . }}
app.kubernetes.io/managed-by: {{ .Release.Service | quote }}
{{- end }}

{{/* Selector labels */}}
{{- define "stateful-workload.selectorLabels" }}
app.kubernetes.io/name: {{ .Release.Name | quote }}
app.kubernetes.io/instance: {{ .Release.Name | quote }}
{{- end }}

{{/* Probe */}}
{{- define "stateful-workload.containerProbe" }}
{{- if eq .type "http" }}
httpGet:
    path: {{ .path }}
    {{- if .port }}
    port: {{ .port }}
    {{- end }}
    {{- if .scheme }}
    scheme: {{ .scheme }}
    {{- end }}
    {{- if .headers }}
    httpHeaders:
    {{- range $name, $val := .headers }}
    - name: {{ $name }}
      value: {{ $val }}
    {{- end }}
    {{- end }}
{{- end }}
{{- if eq .type "tcp" }}
tcpSocket:
    port: {{ .port }}
{{- end }}
{{- if eq .type "command" }}
exec:
    command:
    {{- range .command }}
    - {{ . | quote }}
    {{- end }}
{{- end }}
{{- if .initialDelaySeconds }}
initialDelaySeconds: {{ .initialDelaySeconds }}
{{- end }}
{{- if .periodSeconds }}
periodSeconds: {{ .periodSeconds }}
{{- end }}
{{- if .timeoutSeconds }}
timeoutSeconds: {{ .timeoutSeconds }}
{{- end }}
{{- if .successThreshold }}
successThreshold: {{ .successThreshold }}
{{- end }}
{{- if .failureThreshold }}
failureThreshold: {{ .failureThreshold }}
{{- end }}
{{- end }}

{{/* Lifecycle Handler */}}
{{- define "stateful-workload.lifecycleHandler" }}
{{- if eq .type "http" }}
httpGet:
    path: {{ .path }}
    {{- if .host }}
    host: {{ .host }}
    {{- end }}
    {{- if .port }}
    port: {{ .port }}
    {{- end }}
    {{- if .scheme }}
    scheme: {{ .scheme }}
    {{- end }}
    {{- if .headers }}
    httpHeaders:
    {{- range $name, $val := .headers }}
    - name: {{ $name }}
      value: {{ $val }}
    {{- end }}
    {{- end }}
{{- end }}
{{- if eq .type "tcp" }}
tcpSocket:
    port: {{ .port }}
    {{- if .host }}
    host: {{ .host }}
    {{- end }}
{{- end }}
{{- if eq .type "command" }}
exec:
    command:
    {{- range .command }}
    - {{ . | quote }}
    {{- end }}
{{- end }}
{{- end }}
