resource "helm_release" "loki_logs" {
  name       = "loki-logs"
  repository = "https://grafana.github.io/helm-charts"
  chart      = "loki-stack"
  namespace  = var.monitor_namespace
}

resource "helm_release" "prometheus" {
  name          = "prometheus"
  repository    = "https://prometheus-community.github.io/helm-charts"
  chart         = "kube-prometheus-stack"
  namespace     = var.monitor_namespace
  force_update  = true
  recreate_pods = true
  version       = "46.4.2"

  values = [<<YAML
  prometheus:
    server:
      persistentVolume:
        enabled: true
    prometheusSpec:
      podMonitorSelectorNilUsesHelmValues: false
      serviceMonitorSelectorNilUsesHelmValues: false
      externalUrl: "https://grafana.${terraform.workspace}.nextfaze.ai/prometheus"
    # storageSpec:
    #   volumeClaimTemplate:
    #     spec:
    #       storageClassName: gp2
    #       accessModes:
    #         - ReadWriteOnce
    #       resources:
    #         requests:
    #           storage: 10Gi
    #     selector:
    #       matchLabels:
    #         persistence: grafana
  grafana:
    ingress:
      enabled: true
      annotations:
        nginx.ingress.kubernetes.io/enable-cors: "true"
        cert-manager.io/cluster-issuer: ${var.cluster_issuer_name}
        kubernetes.io/ingress.class: nginx

      tls:
        - secretName: grafana-cert-secret
          hosts:
            - grafana.${terraform.workspace}.nextfaze.ai
      hosts:
        - grafana.${terraform.workspace}.nextfaze.ai
      paths:
        - /
    adminPassword: ${var.grafana_admin_password}
    # persistence:
    #   enabled: true
    #   storageClassName: gp2
    #   selector:
    #     matchLabels:
    #       persistence: grafana
    datasources:
      name: Prometheus
      type: Prometheus
      uid: prometheus
      url: http://prometheus-kube-prometheus-prometheus.${var.monitor_namespace}:9090/
      access: proxy
      jsonData:
        timeInterval: 30
    additionalDataSources:
      - name: Logs
        type: loki
        url: http://${helm_release.loki_logs.name}:3100
        access: proxy
        jsonData:
          derivedFields:
            - datasourceUid: tracing
              matcherRegex: trace_id=(\w+)
              name: Tracing
              url: $$${__value.raw}
  alertmanager:
    ingress:
      enabled: true
      annotations:
        nginx.ingress.kubernetes.io/enable-cors: "true"
        cert-manager.io/cluster-issuer: ${var.cluster_issuer_name}
        kubernetes.io/ingress.class: nginx
      tls:
        - secretName: grafana-cert-secret
          hosts:
            - grafana.${terraform.workspace}.nextfaze.ai
      hosts:
        - grafana.${terraform.workspace}.nextfaze.ai
      paths:
        - /alertmanager
    alertmanagerSpec:
      externalUrl: "https://grafana.${terraform.workspace}.${var.hosturl}/alertmanager"
      routePrefix: /alertmanager
    config:
      global:
        resolve_timeout: 1m
        slack_api_url: ${var.slack_webhook}
      route:
        group_by:
          - job
        group_wait: 30s
        group_interval: 5m
        repeat_interval: 12h
        receiver: "null"
        routes:
          - match:
              alertname: Watchdog
            receiver: "null"
          - match:
              alertname: InfoInhibitor
            receiver: "null"
          - match:
              alertname: KubeControllerManagerDown
            receiver: "null"
          - match:
              alertname: KubeSchedulerDown
            receiver: "null"
          - match:
              alertname: KubeClientCertificateExpiration
            receiver: "null"
          - receiver: slack-notifications
            continue: true

      receivers:
        - name: "null"
        - name: slack-notifications
          slack_configs:
            - channel: ${terraform.workspace}-alerts
              send_resolved: true
              title: >-
                [{{ .Status | toUpper }}{{ if eq .Status "firing" }}:{{ .Alerts.Firing |
                len }}{{ end }}] {{ .CommonLabels.alertname }} for {{
                .CommonLabels.job }}

                {{- if gt (len .CommonLabels) (len .GroupLabels) -}}
                  {{" "}}(
                  {{- with .CommonLabels.Remove .GroupLabels.Names }}
                    {{- range $index, $label := .SortedPairs -}}
                      {{ if $index }}, {{ end }}
                      {{- $label.Name }}="{{ $label.Value -}}"
                    {{- end }}
                  {{- end -}}
                  )
                {{- end }}
              text: >-
                {{ range .Alerts -}} *Alert:* {{ .Annotations.title }}{{ if
                .Labels.severity }} - `{{ .Labels.severity }}`{{ end }}

                *Description:* {{ .Annotations.description }}

                *Details:*
                  {{ range .Labels.SortedPairs }} • *{{ .Name }}:* `{{ .Value }}`
                  {{ end }}
                  *Run Book*: {{ .Annotations.runbook_url }}
                 {{ end }}

  YAML
  ]
}

resource "helm_release" "kube_metrics_server" {
  name       = "kube-metrics-server"
  repository = "https://kubernetes-sigs.github.io/metrics-server/"
  chart      = "metrics-server"
  depends_on = [
    var.monitor_namespace
  ]
}
