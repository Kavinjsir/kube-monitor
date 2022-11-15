{
  customMetricsConfig: 'spec:
  resources:
    - groupVersionKind:
        group: cache.example.com
        kind: "Memcached"
        version: "v1alpha1"
      metrics:
        - name: "status"
          help: "Memcached status"
          each:
            type: StateSet
            stateSet:
              labelName: status
              labelsFromPath:
                type:
                  - type
              list:
               - "True"
               - "False"
               - Unknown
              path:
                - status
                - conditions
              valueFrom:
                - status
'
}

