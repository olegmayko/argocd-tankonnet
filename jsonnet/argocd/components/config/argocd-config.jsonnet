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
    helper.namespace($._config.namespace),
  ]),
  argocdConfig: holder {
    config_map_argocd_cm: if $._config.argocd_cm != null then $._config.argocd_cm else std.map(kustomization, [holder.config_map_argocd_cm])[0],
    config_map_argocd_gpg_keys_cm: if $._config.config_map_argocd_gpg_keys_cm != null then $._config.config_map_argocd_gpg_keys_cm else std.map(kustomization, [holder.config_map_argocd_gpg_keys_cm])[0],
    config_map_argocd_rbac_cm: if $._config.config_map_argocd_rbac_cm != null then $._config.config_map_argocd_rbac_cm else std.map(kustomization, [holder.config_map_argocd_rbac_cm])[0],
    config_map_argocd_ssh_known_hosts_cm: if $._config.argocd_ssh_known_hosts_cm != null then $._config.argocd_ssh_known_hosts_cm else std.map(kustomization, [holder.config_map_argocd_ssh_known_hosts_cm])[0],
    config_map_argocd_tls_certs_cm: if $._config.config_map_argocd_tls_certs_cm != null then $._config.config_map_argocd_tls_certs_cm else std.map(kustomization, [holder.config_map_argocd_tls_certs_cm])[0],
    secret_argocd_secret: if $._config.secret_argocd_secret != null then $._config.secret_argocd_secret else std.map(kustomization, [holder.secret_argocd_secret])[0],
  },
}
