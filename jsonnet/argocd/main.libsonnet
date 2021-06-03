local appController = (import 'components/application-controller/argocd-application-controller.jsonnet');
local clusterRBAC = (import 'components/cluster-rbac/argocd-cluster-rbac.jsonnet');
local config = (import 'components/config/argocd-config.jsonnet');
local crds = (import 'components/crds/argocd-crds.jsonnet');
local dex = (import 'components/dex/argocd-dex.jsonnet');
local redis = (import 'components/redis/argocd-redis.jsonnet');
local repoServer = (import 'components/repo-server/argocd-repo-server.jsonnet');
local server = (import 'components/server/argocd-server.jsonnet');
{
  values:: {
    common: {
      versions: {
        argocd: 'v2.0.2',
      },
      namespace: 'argocd',
      namespaceLabels: { 'app.kubernetes.io/part-of': 'argocd'},
    },

    appController: {
      argocdImage: if std.objectHas($.values.common.images, 'argocd') then $.values.common.images.argocd else null,
      version: $.values.common.versions.argocd,
    },
    clusterRBAC: {},
    config: {
      argocd_cm: if std.objectHas($.values.common.configmaps, 'argocd_cm') then $.values.common.configmaps.argocd_cm else null,
      argocd_ssh_known_hosts_cm: if std.objectHas($.values.common.configmaps, 'argocd_ssh_known_hosts_cm') then $.values.common.configmaps.argocd_ssh_known_hosts_cm else null,
    },
    crds: {},
    dex: {
      argocdImage: if std.objectHas($.values.common.images, 'argocd') then $.values.common.images.argocd else null,
      image: if std.objectHas($.values.common.images, 'dex') then $.values.common.images.dex else null,
      version: $.values.common.versions.argocd,
    },
    redis: {
      image: if std.objectHas($.values.common.images, 'redis') then $.values.common.images.redis else null,
    },
    repoServer: {
      argocdImage: if std.objectHas($.values.common.images, 'argocd') then $.values.common.images.argocd else null,
      version: $.values.common.versions.argocd,
    },
    server: {
      argocdImage: if std.objectHas($.values.common.images, 'argocd') then $.values.common.images.argocd else null,
      version: $.values.common.versions.argocd,
    },
  },

  argocdDex: dex($.values.dex),
  argocdRepoServer: repoServer($.values.repoServer),
  argocdAppController: appController($.values.appController),
  argocdRedis: redis($.values.redis),
  argocdServer: server($.values.server),
  argocdCRD: crds($.values.crds),
  argocdConfig: config($.values.config),
  argocdClusterRBAC: clusterRBAC($.values.clusterRBAC),
  argocdNamespace: {
    namespace: {
      apiVersion: 'v1',
      kind: 'Namespace',
      metadata: {
        name: $.values.common.namespace,
        labels: $.values.common.namespaceLabels
      },
    },
  },
}
