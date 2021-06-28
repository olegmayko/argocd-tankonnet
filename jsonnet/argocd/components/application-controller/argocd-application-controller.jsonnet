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
  argocdAppController: holder {
    network_policy_argocd_application_controller_network_policy: std.map(kustomization, [holder.network_policy_argocd_application_controller_network_policy])[0],
    role_argocd_application_controller: std.map(kustomization, [holder.role_argocd_application_controller])[0],
    role_binding_argocd_application_controller: std.map(kustomization, [holder.role_binding_argocd_application_controller])[0],
    service_account_argocd_application_controller: std.map(kustomization, [holder.service_account_argocd_application_controller])[0],
    service_argocd_metrics: std.map(kustomization, [holder.service_argocd_metrics])[0],
    stateful_set_argocd_application_controller: std.map(kustomization, [holder.stateful_set_argocd_application_controller])[0],
  },
}
