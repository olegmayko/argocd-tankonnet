//local argocdCm = (import 'argocd-cm.jsonnet');
//local argocdSSHKnownHostCm = (import 'argocd-ssh-known-hosts-cm.jsonnet');
local argo = (import 'jsonnet/argocd/main.libsonnet') +

             {
               values+:: {
                 // overwrite below if you'd like to use custom images and/or different image of argoCD or overwrite default configmaps.
                 common+: {
                      images+: {
                      #  argocd: customArgocdImage,
                      #  dex: customDexImage,
                      #  redis: customRedisImage
                      },
                      versions+: {
                       # argocd: 'v2.0.3',
                      },
                      configmaps+: {
                       # argocd_cm: argocdCm,
                       # argocd_ssh_known_hosts_cm: argocdSSHKnownHostCm,
                      },
                 },
               },
             };

{ [name]: argo.argocdAppController[name] for name in std.objectFields(argo.argocdAppController) }
{ [name]: argo.argocdClusterRBAC[name] for name in std.objectFields(argo.argocdClusterRBAC) }
{ [name]: argo.argocdConfig[name] for name in std.objectFields(argo.argocdConfig) }
{ [name]: argo.argocdCRD[name] for name in std.objectFields(argo.argocdCRD) }
{ [name]: argo.argocdDex[name] for name in std.objectFields(argo.argocdDex) }
{ [name]: argo.argocdRedis[name] for name in std.objectFields(argo.argocdRedis) }
{ [name]: argo.argocdRepoServer[name] for name in std.objectFields(argo.argocdRepoServer) }
{ [name]: argo.argocdServer[name] for name in std.objectFields(argo.argocdServer) }
{ 'argocdNamespace': argo.argocdNamespace.namespace }
