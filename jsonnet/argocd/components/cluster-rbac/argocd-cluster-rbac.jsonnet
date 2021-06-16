// Below as per description in https://tanka.dev/kustomize#consuming-a-kustomization-from-jsonnet
local tanka = import 'github.com/grafana/jsonnet-libs/tanka-util/main.libsonnet';
local kustomize = tanka.kustomize.new(std.thisFile);
local holder = kustomize.build(path='./');

// use same approach as in kube-prometheus project
function(params) {
  _config:: params,
  argocdClusterRBAC: holder {
    cluster_role_binding_argocd_server+: {
      subjects: [{
        kind: 'ServiceAccount',
        name: 'argocd-server',
        namespace: $._config.namespace,
      }],
    },
    cluster_role_binding_argocd_application_controller+: {
      subjects: [{
        kind: 'ServiceAccount',
        name: 'argocd-application-controller',
        namespace: $._config.namespace,
      }],
    },
  },
}
