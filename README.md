# argocd-tankonnet
 Customize [upstream](https://github.com/argoproj/argo-cd/tree/master/manifests) ArgoCD manifests using [tanka](https://tanka.dev)

## Important

This repo is meant to be consumed as a dependency.
## Getting Started

### Install

Install [Tanka](https://tanka.dev/install) with version > [0.13](https://github.com/grafana/tanka/blob/v0.16.0/CHANGELOG.md#013-2020-12-11)
Install [Jsonnet Bundler](https://tanka.dev/install#jsonnet-bundler)

Install jsonnet dependency `jb install`

### Evaluate example

`tk evaluate example.jsonnet`

For production use please follow tanka [guideline](https://tanka.dev/tutorial/overview)
