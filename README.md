# Tokscale Dashboard for Herdr

Open Tokscale as a local Herdr dashboard pane.

This plugin is a thin Herdr adapter. Tokscale still owns telemetry scanning, pricing, Personal Pulse, and exports. Herdr only opens the dashboard pane and provides the shortcut/action surface.

## Prerequisite

Install Tokscale first. This plugin does not bundle Tokscale; it only opens Tokscale inside Herdr.

Tokscale project and full install docs: <https://github.com/junhoyeo/tokscale>

Quick start:

```bash
npx tokscale@latest

# or
bunx tokscale@latest

# or
deno x npm:tokscale@latest
```

For Herdr, either put a `tokscale` command on `PATH`, or set `TOKSCALE_CMD` in this plugin's config.

## Install Plugin

For local development:

```bash
herdr plugin link /path/to/herdr-tokscale-dashboard
```

From GitHub:

```bash
herdr plugin install astkaasa/herdr-tokscale-dashboard
```

## Configure

If `tokscale` is already in `PATH`, no config is required.

For npx, bunx, deno, or a custom binary path:

```bash
config_dir="$(herdr plugin config-dir tokscale.dashboard)"
cp config.env.example "$config_dir/config.env"
```

Then edit `config.env`:

```bash
TOKSCALE_CMD="bunx tokscale@latest"

# or:
TOKSCALE_CMD="/path/to/tokscale"
```

## Use

Open the dashboard pane:

```bash
herdr plugin action invoke tokscale.dashboard.open
```

Or open the pane directly:

```bash
herdr plugin pane open --plugin tokscale.dashboard --entrypoint tui --placement split --direction right --focus
```

Print the Pulse JSON action:

```bash
herdr plugin action invoke tokscale.dashboard.pulse-json
```

## Marketplace

Herdr marketplace discovery is based on public GitHub repositories tagged with the `herdr-plugin` topic. It is an automatic index, not a reviewed catalog.
