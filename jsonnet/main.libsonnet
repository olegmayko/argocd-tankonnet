local appController = (import 'argocd/components/application-controller/argocd-application-controller.jsonnet');
local clusterRBAC = (import 'argocd/components/cluster-rbac/argocd-cluster-rbac.jsonnet');
local config = (import 'argocd/components/config/argocd-config.jsonnet');
local argocdCrds = (import 'argocd/components/crds/argocd-crds.jsonnet');
local dex = (import 'argocd/components/dex/argocd-dex.jsonnet');
local redis = (import 'argocd/components/redis/argocd-redis.jsonnet');
local repoServer = (import 'argocd/components/repo-server/argocd-repo-server.jsonnet');
local server = (import 'argocd/components/server/argocd-server.jsonnet');
local appsetController = (import 'applicationset/components/appset-controller/appset-controller.jsonnet');
local appsetCrds = (import 'applicationset/components/crds/appset-crds.jsonnet');

{
  values:: {
    common: {
      versions: {
        argocd: 'v2.0.2',
        appsetController: 'v0.1.0',
      },
      images: {
        appsetController: 'quay.io/argocdapplicationset/argocd-applicationset',
      },
      namespace: 'argocd',
      namespaceLabels: { 'app.kubernetes.io/part-of': 'argocd' },
    },

    appController: {
      argocdImage: if std.objectHas($.values.common.images, 'argocd') then $.values.common.images.argocd else null,
      version: $.values.common.versions.argocd,
      namespace: $.values.common.namespace,
    },
    clusterRBAC: {
      namespace: $.values.common.namespace,
    },
    config: {
      argocd_cm: if std.objectHas($.values.common.configmaps, 'argocd_cm') then $.values.common.configmaps.argocd_cm else null,
      argocd_ssh_known_hosts_cm: if std.objectHas($.values.common.configmaps, 'argocd_ssh_known_hosts_cm') then $.values.common.configmaps.argocd_ssh_known_hosts_cm else null,
      config_map_argocd_gpg_keys_cm: if std.objectHas($.values.common.configmaps, 'config_map_argocd_gpg_keys_cm') then $.values.common.configmaps.config_map_argocd_gpg_keys_cm else null,
      config_map_argocd_rbac_cm: if std.objectHas($.values.common.configmaps, 'config_map_argocd_rbac_cm') then $.values.common.configmaps.config_map_argocd_rbac_cm else null,
      config_map_argocd_tls_certs_cm: if std.objectHas($.values.common.configmaps, 'config_map_argocd_tls_certs_cm') then $.values.common.configmaps.config_map_argocd_tls_certs_cm else null,
      secret_argocd_secret: if std.objectHas($.values.common.configmaps, 'secret_argocd_secret') then $.values.common.configmaps.secret_argocd_secret else null,
      namespace: $.values.common.namespace,
    },
    argocdCrds: {},
    dex: {
      argocdImage: if std.objectHas($.values.common.images, 'argocd') then $.values.common.images.argocd else null,
      image: if std.objectHas($.values.common.images, 'dex') then $.values.common.images.dex else null,
      version: $.values.common.versions.argocd,
      namespace: $.values.common.namespace,
    },
    redis: {
      image: if std.objectHas($.values.common.images, 'redis') then $.values.common.images.redis else null,
      namespace: $.values.common.namespace,
    },
    repoServer: {
      argocdImage: if std.objectHas($.values.common.images, 'argocd') then $.values.common.images.argocd else null,
      version: $.values.common.versions.argocd,
      namespace: $.values.common.namespace,
    },
    server: {
      argocdImage: if std.objectHas($.values.common.images, 'argocd') then $.values.common.images.argocd else null,
      version: $.values.common.versions.argocd,
      namespace: $.values.common.namespace,
    },
    appsetCrds: {},
    appsetController: {
      image: if std.objectHas($.values.common.images, 'appsetController') then $.values.common.images.appsetController else null,
      version: $.values.common.versions.appsetController,
      namespace: $.values.common.namespace,
    },
  },

  argocdDex: dex($.values.dex),
  argocdRepoServer: repoServer($.values.repoServer),
  argocdAppController: appController($.values.appController),
  argocdRedis: redis($.values.redis),
  argocdServer: server($.values.server),
  argocdCRD: argocdCrds($.values.argocdCrds),
  argocdConfig: config($.values.config),
  argocdClusterRBAC: clusterRBAC($.values.clusterRBAC),
  argocdNamespace: {
    namespace: {
      apiVersion: 'v1',
      kind: 'Namespace',
      metadata: {
        name: $.values.common.namespace,
        labels: $.values.common.namespaceLabels,
      },
    },
  },
  appsetController: appsetController($.values.appsetController),
  appsetCrds: appsetCrds($.values.appsetCrds),
}
