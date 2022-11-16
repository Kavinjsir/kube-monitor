{
  customMetricsConfig: 'spec:
  resources:
    - groupVersionKind:
        group: cache.example.com
        kind: "Memcached"
        version: "v1alpha1"
      labelsFromPath:
        name:
          - metadata
          - name
        namespace:
          - metadata
          - namespace
        uid:
          - metadata
          - uid
      metrics:
        - name: "info"
          help: "Memcached API info."
          each:
            type: Info
            info:
              # labelsFromPath:
                # version:
                  # - spec
                  # - version
              commonLabels:
                group: "cache.example.com"
                kind: "Memcached"
                version: "v1alpha1"
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

