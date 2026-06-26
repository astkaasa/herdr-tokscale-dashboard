#!/usr/bin/env bash
set -euo pipefail

mode="${1:-tui}"
if [[ $# -gt 0 ]]; then
  shift
fi

if [[ -n "${HERDR_PLUGIN_CONFIG_DIR:-}" && -f "${HERDR_PLUGIN_CONFIG_DIR}/config.env" ]]; then
  set -a
  # shellcheck disable=SC1090
  . "${HERDR_PLUGIN_CONFIG_DIR}/config.env"
  set +a
fi

open_pane() {
  local cmd=(
    "${HERDR_BIN_PATH:-herdr}"
    plugin
    pane
    open
    --plugin
    "${HERDR_PLUGIN_ID:-tokscale.dashboard}"
    --entrypoint
    tui
    --placement
    split
    --direction
    right
    --focus
  )

  exec "${cmd[@]}"
}

run_tokscale() {
  if [[ -n "${TOKSCALE_CWD:-}" ]]; then
    cd "${TOKSCALE_CWD}"
  fi

  local tokscale_cmd="${TOKSCALE_CMD:-}"

  if [[ -n "${tokscale_cmd}" ]]; then
    exec bash -lc "exec ${tokscale_cmd} \"\$@\"" bash "$@"
  fi

  if [[ -x "${PWD}/target/debug/tokscale" ]]; then
    exec "${PWD}/target/debug/tokscale" "$@"
  fi

  if command -v tokscale >/dev/null 2>&1; then
    exec tokscale "$@"
  fi

  cat >&2 <<'EOF'
Tokscale command not found.

Install `tokscale` on PATH, or set TOKSCALE_CMD in:
  $(herdr plugin config-dir tokscale.dashboard)/config.env

Examples:
  TOKSCALE_CMD="bunx tokscale@latest"
  TOKSCALE_CMD="/path/to/tokscale"
  TOKSCALE_CWD="$HOME/Developer/tokscale"
EOF
  return 127
}

case "${mode}" in
  open)
    open_pane
    ;;
  tui)
    run_tokscale tui "$@"
    ;;
  pulse-json)
    run_tokscale pulse --json "$@"
    ;;
  *)
    run_tokscale "${mode}" "$@"
    ;;
esac
