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
      { name: 'redis', newName: if $._config.image != null then $._config.image else self.name },
    ]),
    helper.namespace($._config.namespace),
  ]),
  argocdRedis: holder {
    deployment_argocd_redis+: std.map(kustomization, [holder.deployment_argocd_redis])[0] {
      spec+: {
        template+: {
          spec+: {
            serviceAccountName: 'default',
          },
        },
      },
    },
    network_policy_argocd_redis_network_policy: std.map(kustomization, [holder.network_policy_argocd_redis_network_policy])[0],
    role_argocd_redis: {},
    role_binding_argocd_redis: {},
    service_account_argocd_redis: {},
    service_argocd_redis: std.map(kustomization, [holder.service_argocd_redis])[0],
  },
}
