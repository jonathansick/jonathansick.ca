# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

Personal website (jonathansick.ca) — a static site built with **Astro 7**. No framework integrations; `astro.config.mjs` is intentionally empty. The package is named `astro` internally but this is not the Astro project itself.

## Commands

Uses **pnpm** (v11.9.0, pinned via `packageManager`). Node version is pinned to v24.18.0 in `.nvmrc`.

- `pnpm install` — install dependencies
- `pnpm run dev` (or `start`) — dev server at `localhost:4321`
- `pnpm run build` — production build to `./dist/`
- `pnpm run preview` — preview the production build
- `pnpm run lint` / `pnpm run lint:fix` — lint
- `pnpm run format` / `pnpm run format:check` — format
- `pnpm run astro check` — Astro/TypeScript type checking

There is no test suite. CI (`.github/workflows/ci.yaml`) runs on every push and PR: `pnpm run lint`, then `pnpm run format:check`, then `pnpm run build`. Match that order locally before pushing.

## Tooling split (important)

Linting and formatting are divided across **three tools** by file type. This division is deliberate — do not run a tool on file types it doesn't own, and note that `lint`/`format` each invoke two tools:

- **Biome** — lints AND formats JS/TS/JSX/JSON/JSONC/CSS. It explicitly **excludes `.astro` and `public/`** (see `biome.json` `files.includes`).
- **ESLint** — covers `.astro` files ONLY (`eslint-plugin-astro` + `jsx-a11y`). See the comment in `eslint.config.js`.
- **Prettier** — formats only what Biome can't parse: `.astro`, Markdown, YAML, HTML. `.prettierignore` excludes all the JS/TS/JSON/CSS that Biome handles.

`pnpm run lint` = `biome lint` + `eslint`. `pnpm run format` = `biome format --write` + `prettier --write`.

A **Husky** pre-commit hook runs `lint-staged`, which routes each staged file to the right tool (Biome for code, ESLint+Prettier for `.astro`, Prettier for md/yaml/html).

## Architecture

**Layout inheritance** — everything renders through `BaseLayout.astro`:

- `src/layouts/BaseLayout.astro` — the HTML shell: `<head>` metadata (OpenGraph, favicons, Typekit stylesheet), `Header`, `Footer`, and a flexbox sticky-footer wrapper. Takes `title` and `description` props.
- `src/layouts/ContentLayout.astro` — wraps `BaseLayout` for prose pages; reads `title`/`description` from Markdown `frontmatter` and renders an `<h1>` + centered `<main>`.
- `.astro` pages (e.g. `src/pages/index.astro`) use `BaseLayout` directly. Markdown pages (e.g. `src/pages/about.md`) opt into `ContentLayout` via a `layout:` frontmatter field.

**Routing** — file-based from `src/pages/`. The `Header` nav links to `/`, `/about`, and `/making`; `/making` has no page yet, so adding new nav destinations means creating both the page and (if needed) the `HeaderLink`. `HeaderLink.astro` computes active state from `Astro.url.pathname` (exact match for `/`, prefix match otherwise).

**Styling** — global design tokens live in `src/styles/global.css` as CSS custom properties (brand red `--primary-color: #ed2024`, background `#defff2`, and the `--skolar-font-family` / `--enra-sans-font-family` stacks). Component styles are scoped `<style>` blocks inside each `.astro` file. Fonts are loaded from an **external Typekit stylesheet** (`use.typekit.net`) referenced in `BaseLayout`'s head — the variable fonts (`skolar-pe-variable`, `enra-sans-variable`) won't render without network access.

**Static assets** — `public/` holds favicons, the web manifest, and nav SVG icons (`chevron.svg`, `seperator.svg`, referenced from CSS `background-image`). Files here are served at the site root and are excluded from Biome.
