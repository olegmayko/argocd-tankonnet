// Below as per description in https://tanka.dev/kustomize#consuming-a-kustomization-from-jsonnet
local tanka = import 'github.com/grafana/jsonnet-libs/tanka-util/main.libsonnet';
local kustomize = tanka.kustomize.new(std.thisFile);
local holder = kustomize.build(path='./');

// use same approach as in kube-prometheus project
function(params) {
  _config:: params,
  argocdCRD: holder {
    config_map_argocd_cm+: if $._config.argocd_cm != null then $._config.argocd_cm,
    config_map_argocd_ssh_known_hosts_cm+: if $._config.argocd_ssh_known_hosts_cm != null then $._config.argocd_ssh_known_hosts_cm,
  },
}
