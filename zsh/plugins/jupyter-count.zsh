function count_jupyter_instances() {
    # Show the amount of jupyter kernels
    jupyter_count=$(procs jupyter --json | jq ". | length")
    if [ "$jupyter_count" -gt 0 ]; then
      echo "You have $jupyter_count Jupyter kernel(s) running."
    fi
}
