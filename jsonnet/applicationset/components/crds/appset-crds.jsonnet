// Below as per description in https://tanka.dev/kustomize#consuming-a-kustomization-from-jsonnet
local tanka = import 'github.com/grafana/jsonnet-libs/tanka-util/main.libsonnet';
local kustomize = tanka.kustomize.new(std.thisFile);
local holder = kustomize.build(path='./');

// use same approach as in kube-prometheus project
function(params) {
  _config:: params,
  applicationsetCRD: holder,
}
