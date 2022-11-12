local kp =
  (import 'kube-prometheus/main.libsonnet') +
  // Note that NodePort type services is likely not a good idea for your production use case, it is only used for demonstration purposes here.
  (import 'kube-prometheus/addons/node-ports.libsonnet') +
  (import 'kube-prometheus/addons/all-namespaces.libsonnet') +

  {
    values+:: {
      common+: {
        namespace: 'monitoring',
      },
      grafana+: {
        config: {  // http://docs.grafana.org/installation/configuration/
          sections: {
            // Do not require grafana users to login/authenticate
            'auth.anonymous': { enabled: true },
          },
        },
      },
    },
    prometheus+: {
      namespaces: [],
    },
    alertmanager+: {
      alertmanager+: {
        spec+: {
          logLevel: 'debug',  // So firing alerts show up in log
        },
      },
    },
  };

{ ['00namespace-' + name]: kp.kubePrometheus[name] for name in std.objectFields(kp.kubePrometheus) } +
{ ['0prometheus-operator-' + name]: kp.prometheusOperator[name] for name in std.objectFields(kp.prometheusOperator) } +
{ ['node-exporter-' + name]: kp.nodeExporter[name] for name in std.objectFields(kp.nodeExporter) } +
{ ['kube-state-metrics-' + name]: kp.kubeStateMetrics[name] for name in std.objectFields(kp.kubeStateMetrics) } +
{ ['alertmanager-' + name]: kp.alertmanager[name] for name in std.objectFields(kp.alertmanager) } +
{ ['prometheus-' + name]: kp.prometheus[name] for name in std.objectFields(kp.prometheus) } +
{ ['grafana-' + name]: kp.grafana[name] for name in std.objectFields(kp.grafana) } +
{
  'kube-state-metrics-deployment'+: {
    spec+: {
      template+: {
        spec+: {
          containers: [
            super.containers[0] {
              args: [
                '--custom-resource-state-config',
                (import './kube-state-metrics-config.jsonnet').customMetricsConfig,
              ] + super.args,
            },
          ] + super.containers[1:],
        },
      },
    },
  },
}
