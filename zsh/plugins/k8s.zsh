alias k-netshoot="kubectl run -it --rm --restart=Never -n ${KUBE_NS:-default} --image nicolaka/netshoot net-testing"

# flux get kustomizations --all-namespaces
# flux -n tappy-flux reconcile kustomization --with-source tappy-staging-fks

k() {
    if [[ -n "$KUBE_NS" ]]; then
        kubectl  "$@" -n "$KUBE_NS"
    else
        kubectl "$@"
    fi
}

k-cluster() {
    local kubeconfig_path
    kubeconfig_path=$(tv k8s-cluster)

    if [[ $? -eq 0 && -n "$kubeconfig_path" ]]; then
        export KUBECONFIG="$kubeconfig_path"
        echo "KUBECONFIG set to: $KUBECONFIG"
    else
        echo "Error: Failed to get kubeconfig path from 'tv k8s-cluster'" >&2
        return 1
    fi
}

k-ns() {
    local kube_ns
    kube_ns=$(tv k8s-namespace)

    if [[ $? -eq 0 && -n "$kube_ns" ]]; then
        export KUBE_NS="$kube_ns"
        echo "KUBE_NS set to: $KUBE_NS"
    else
        echo "Error: Failed to get namespace from 'tv k8s-namespace'" >&2
        return 1
    fi
}

k-stern() {
    if [[ -n "$KUBE_NS" ]]; then
        /opt/homebrew/bin/stern  "$@" -n "$KUBE_NS"
    else
        /opt/homebrew/bin/stern --all-namespaces "$@"
    fi
}
