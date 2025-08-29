# --- Kubernetes shortcuts (exact pipelines, just wrapped) ---
export-env {
    $env.KUBECONFIG = ""
}

# Generic Wrapper
def --wrapped kctl [...rest] {
    kubectl -o json ...$rest
    | from json
    | get items
}


# 1) Pods in kube-system with total restarts per pod (sorted desc)
def --env kpods_restarts_ks [] {
  kubectl get pods -n kube-system -o json
  | from json
  | get items
  | each {
      let statuses = ($in.status.containerStatuses? | default [])
      let restarts = (
        $statuses
        | each { $in.restartCount? | default 0 }
        | math sum
      )
      { name: $in.metadata.name, restarts: $restarts }
    }
  | sort-by restarts --reverse
}

# 2) All running pods across namespaces (namespace, name, podIP)
def --env kpods_running_all [] {
  kubectl get pods -A -o json
  | from json
  | get items
  | where status.phase == "Running"
  | select metadata.namespace metadata.name status.podIP
}

# 3) Top 5 pods by total memory requests (sum across containers)
def --env kpods_top_mem [] {
  kubectl get pods -A -o json
  | from json
  | get items
  | each {|pod|
      let mems = ($pod.spec.containers
          | default []                                      # some pods might have no containers
          | each {|c|
              $c
              | get resources.requests.memory            # missing -> nothing
              | default "0"                                 # treat missing as 0
              | str replace -a 'Ki' 'KiB'                   # make units parseable by into filesize
              | str replace -a 'Mi' 'MiB'
              | str replace -a 'Gi' 'GiB'
              | str replace -a 'Ti' 'TiB'
              | into filesize
          })
      {
        namespace: $pod.metadata.namespace,
        name: $pod.metadata.name,
        mem_request: ($mems | math sum)                     # total per pod
      }
    }
  | sort-by mem_request --reverse
  | first 5
}

# 4) LoadBalancer services (ns, name, externalIPs, ports)
def --env ksvc_lbs_all [] {
  kubectl get svc -A -o json
  | from json
  | get items
  | where spec.type == "LoadBalancer"
  | select metadata.namespace metadata.name spec.externalIPs spec.ports
}

# 5) Deployments with fewer ready replicas than desired
def --env kdeploys_unready_all [] {
  kubectl get deploy -A -o json
  | from json
  | get items
  | each {
      {
        namespace: $in.metadata.namespace,
        name: $in.metadata.name,
        ready: ($in.status.readyReplicas? | default 0 | into int),
        replicas: ($in.status.replicas? | default 0 | into int)
      }
    }
  | where { $in.ready < $in.replicas }
  | select namespace name ready replicas
  | sort-by namespace name
}

# 6) Node names and architecture
def --env knodes_arch [] {
  kubectl get nodes -o json
  | from json
  | get items
  | select metadata.name status.nodeInfo.architecture
}
