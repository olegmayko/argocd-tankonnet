// Below as per description in https://tanka.dev/kustomize#consuming-a-kustomization-from-jsonnet
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
    ]),
    helper.namespace($._config.namespace),
  ]),
  argocdRepoServer: {
    deployment_argocd_repo_server: std.map(kustomization, [holder.deployment_argocd_repo_server])[0],
    network_policy_argocd_repo_server_network_policy: std.map(kustomization, [holder.network_policy_argocd_repo_server_network_policy])[0],
    service_argocd_repo_server: std.map(kustomization, [holder.service_argocd_repo_server])[0],
  },
}
