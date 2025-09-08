# Recursively render all *.j2 under ROOT using CONFIG, output beside source (strip .j2)
# Usage: render_j2_tree <ROOT_DIR> <CONFIG_YAML>
render_j2_tree() {
    local root="$1"
    local config="$2"

    if [[ -z "$root" || -z "$config" ]]; then
        echo "Usage: render_j2_tree <ROOT_DIR> <CONFIG_YAML>" >&2
        return 2
    fi
    if [[ ! -d "$root" ]]; then
        echo "Directory not found: $root" >&2
        return 1
    fi
    if [[ ! -f "$config" ]]; then
        echo "Config file not found: $config" >&2
        return 1
    fi
    if ! command -v jinja2 >/dev/null 2>&1; then
        echo "jinja2-cli not found in PATH" >&2
        return 127
    fi

    # Normalize root (no trailing slash)
    root="${root%/}"

    local count=0
    while IFS= read -r -d '' src; do
        local out="${src%.j2}"
        printf '[📝] Rendering %s -> %s\n' "${src#$root/}" "${out#$root/}"
        if ! jinja2 "$src" "$config" -o "$out"; then
            echo "[❌] Failed: $src" >&2
            return 1
        fi
        ((count++))
    done < <(find "$root" -type f -name '*.j2' -print0)

    ((count==0)) && echo "[ℹ] No templates found under: $root"
}

