// Below as per desription in https://tanka.dev/kustomize#consuming-a-kustomization-from-jsonnet
local tanka = import 'github.com/grafana/jsonnet-libs/tanka-util/main.libsonnet';
local kustomize = tanka.kustomize.new(std.thisFile);
local holder = kustomize.build(path='./');

// import kustomize helper lib
local helper = import 'github.com/anguslees/kustomize-libsonnet/kustomize.libsonnet';

// use same approach as in kube-prometheus project
function(params) {
  _config:: params,
  local kustomization = helper.applyList([
    helper.images([
      { name: 'quay.io/argoproj/argocd', newName: if $._config.argocdImage != null then $._config.argocdImage else self.name, newTag: $._config.version },
      { name: 'ghcr.io/dexidp/dex', newName: if $._config.image != 'default' then $._config.image else self.name },
    ]),
    helper.namespace($._config.namespace),
  ]),
  argocdDex: holder {
    deployment_argocd_dex_server: std.map(kustomization, [holder.deployment_argocd_dex_server])[0],
    network_policy_argocd_dex_server_network_policy: std.map(kustomization, [holder.network_policy_argocd_dex_server_network_policy])[0],
    role_argocd_dex_server: std.map(kustomization, [holder.role_argocd_dex_server])[0],
    role_binding_argocd_dex_server: std.map(kustomization, [holder.role_binding_argocd_dex_server])[0],
    service_account_argocd_dex_server: std.map(kustomization, [holder.service_account_argocd_dex_server])[0],
    service_argocd_dex_server: std.map(kustomization, [holder.service_argocd_dex_server])[0],
  },
}
