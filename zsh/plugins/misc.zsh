sharelp() {
    if [ $# -eq 0 ]; then
        echo "Usage: sharel <local_port>"
        echo "Example: sharel 8000"
        return 1
    fi

    local_port=$1
    echo "Creating reverse tunnel: localhost:${local_port}"
    echo "Tunnel is active. Press Ctrl+C to close."

    # -N prevents executing remote commands (no shell)
    ssh -N -R 8077:localhost:${local_port} dev1.jongretar.com
}
