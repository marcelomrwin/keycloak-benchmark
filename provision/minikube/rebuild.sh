#!/usr/bin/env bash
# set -x
set -e
if [ "$GITHUB_ACTIONS" == "" ]; then
  minikube delete
  minikube config set memory 8192
  minikube config set cpus 4
  DRIVER=kvm2
  if [ "$(uname)" == "Darwin" ]; then
    DRIVER=hyperkit
  elif [ "$(expr substr $(uname -s) 1 10)" == "MINGW64_NT" ]; then
    DRIVER=hyperv
  fi
  minikube config set driver ${DRIVER}
  minikube config set container-runtime docker
  minikube start --container-runtime=docker --driver=${DRIVER} --docker-opt="default-ulimit=nofile=102400:102400" --kubernetes-version=v1.25.0
fi
minikube addons enable ingress
rm -rf .task
echo "Minikube initialized. Now run 'task' to provision it with Keycloak"
