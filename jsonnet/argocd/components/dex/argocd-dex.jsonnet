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
  ]),
  argocdDex: holder {
    deployment_argocd_dex_server: std.map(kustomization, [holder.deployment_argocd_dex_server])[0],
  },
}