# Architecture: Information Architecture & Content Model

This document is the site's information architecture and data-model specification: the site map, the content collections and their schemas, the media strategy, the build-time pipelines, and the implementation roadmap. It sits alongside PRODUCT.md (which wins on strategy and voice) and DESIGN.md (which wins on visual decisions); **this document wins on IA, routes, and data-model decisions**. It is a design record, not implemented code — the sequencing in §12 orders the build.

The organizing idea follows the "Surveyor's Field Kit" north star: the site is a **notebook** (living, revisited notes), a **project directory** (the finished and in-progress work), and the apparatus around them (CV, library, now, uses). Everything Jonathan produces — software, furniture, papers, talks, photo essays — lives in one unified projects collection; everything he's thinking through lives in the notebook.

## 1. Site map & routing

| Route                   | Feeds from                                          | Notes                                                                       |
| ----------------------- | --------------------------------------------------- | --------------------------------------------------------------------------- |
| `/`                     | — (later: featured projects, recently tended notes) | Exists.                                                                     |
| `/about`                | —                                                   | Exists.                                                                     |
| `/cv`                   | `cv` data + `projects`, via `buildCv()`             | Print stylesheet; optional `/cv.json` JSON Resume endpoint.                 |
| `/uses`                 | `uses` data collection                              | Grouped by category order.                                                  |
| `/now`                  | `now` collection                                    | Latest entry + "Previously" list (nownownow.com convention).                |
| `/now/[id]`             | `now`                                               | Permalink per update, e.g. `/now/2026-07-09`.                               |
| `/projects`             | `projects`                                          | Client-side multi-facet filtering; unpublished entries excluded everywhere. |
| `/projects/type/[type]` | `projects`                                          | Pre-rendered single-facet pages.                                            |
| `/projects/[id]`        | `projects`                                          | Gallery, attachments, backlinked notes.                                     |
| `/notebook`             | `notebook` + `now` adapter                          | Filter by topic, type, maturity; now entries appear as "field reports."     |
| `/notebook/[id]`        | `notebook`                                          | Created/revised/maturity apparatus, backlinks.                              |
| `/library`              | `library`                                           | Grouped by medium.                                                          |
| `/library/[...id]`      | `library`                                           | Rest param — ids contain `/` (e.g. `books/annihilation`).                   |
| `/topics/[id]`          | `topics` + all content collections                  | Cross-collection topic hubs.                                                |
| `/feed.xml`             | all dated collections                               | New-items-only (§9).                                                        |
| `/404`, `/colophon`     | —                                                   | Roadmap (§10).                                                              |

**`/making`.** The current nav links to `/making`, which has no page. The nav label "Making" stays (the nav-as-sentence is load-bearing) and points at `/projects`; `/making` becomes a 301 to `/projects` in `public/_redirects` so any link that guessed the URL still lands.

**Naming the garden.** The digital-garden section is **`/notebook`** — the surveyor's field notebook, chosen over `/garden`, `/notes`, and `/field-notes`. The _model_ is Maggie Appleton's digital garden (non-chronological, interlinked, revisited notes, filterable by topic/type/maturity); the _metaphor_ is the notebook, which is why the maturity stages are **sketch → draft → fair-copy** rather than seedling/budding/evergreen (§5).

## 2. Platform ground truth (Astro 7.0.6)

Verified against the installed Astro 7.0.6, so implementation doesn't trip on stale v5-era examples:

- Astro 7 ships **Zod 4**. Import `{ z }` from `astro/zod` — the `astro:content` `z` export is deprecated. Zod 4 idiom shifts: `z.looseObject()` replaces `.passthrough()`; string formats are top-level functions — `z.url()`, `z.email()` — not the deprecated `z.string().url()`; build discriminated-union variants with `base.extend({...})`, never `z.intersection`.
- Collection config lives at **`src/content.config.ts`** — the legacy `src/content/config.ts` path requires a compat flag.
- The `file()` loader natively parses JSON, YAML, and TOML. The `glob()` loader maps `foo/index.md` → id `foo` and honors a `slug` frontmatter override.
- **`reference()` does not validate that the target exists** at build time — it is a shape transform only. A dangling reference surfaces as `getEntry() → undefined` at render. §8 describes the throwing resolver that turns these into build failures.
- Discriminated unions: give **no default to the discriminator** — every file declares its `type:` / `medium:` / `kind:` explicitly. `reference()` cannot serve as a discriminator. Include an explicit `other` variant as a catch-all, because a discriminated union has no fallback branch.
- `astro.config.mjs` currently lacks `site` — required for sitemap and RSS absolute URLs (implementation-phase item, §12).

## 3. Content directories & loaders

```
src/
  content.config.ts          # all 7 collections (required path in Astro 7)
  schemas/media.ts           # cfImage, galleryItem, attachment sub-schemas
  content/
    projects/<slug>/index.md # folder-per-project (colocate future files)
    notebook/<slug>.md
    library/books/<slug>.md  # …and records/, films/, tv/
    now/2026-07-09.md        # one file per update; full-date filename is the id
  data/
    topics.yaml
    uses.yaml
    cv.yaml
  lib/                       # images.ts, files.ts, taxonomy.ts, cv.ts,
                             # notebook adapter, backlinks.ts
```

**Format decisions.**

- **Plain `.md` everywhere for v1.** Galleries and attachments live in frontmatter and are rendered by layouts, so pages don't need components in their bodies. MDX enters only if a specific note later needs inline components.
- **YAML over TOML** for data files — Prettier already owns YAML in this repo's tooling split, so it formats for free.
- **Loaders:** `glob()` for the four markdown collections (`projects`, `notebook`, `library`, `now`); `file()` for `topics` and `uses`. `cv.yaml` also loads via `file()`, but a JSON Resume document is one object, not a list of entries — either wrap it with a custom `parser` (needs `js-yaml`) or key the YAML under a single `main:` entry to avoid the dependency.
- **Folder-per-project** (`projects/<slug>/index.md`) so future colocated files (source images pre-upload, notes) have a home; the glob loader collapses `index.md` to the folder's slug.

## 4. Projects collection

One unified collection for **everything produced** — software, woodworking, home improvement, talks, papers, the thesis, photo essays, art. A core schema carries what every project shares; a Zod discriminated union on `type` adds per-medium fields. This is deliberately _not_ separate "portfolio" / "publications" / "photos" sections: one directory, one detail-page grammar, faceted by type.

**Core fields** (all variants):

| Field                     | Type / constraint                                | Notes                                                     |
| ------------------------- | ------------------------------------------------ | --------------------------------------------------------- |
| `title`                   | string                                           |                                                           |
| `short_description`       | string, ≤200 chars                               | Index cards and meta descriptions.                        |
| `date_start` / `date_end` | date / optional date                             | `date_end` absent while in progress.                      |
| `date_precision`          | `day \| month \| year`, default `day`            | Old projects often only have a year; render accordingly.  |
| `status`                  | `in-progress \| completed \| ongoing \| retired` | `ongoing` for software that's maintained, not "finished." |
| `thumbnail`               | `cfImage` (§7)                                   |                                                           |
| `gallery`                 | `galleryItem[]` (§7)                             | Photos, R2 video clips, Stream embeds.                    |
| `attachments`             | `attachment[]` (§7)                              | PDFs, slides, plans — R2-served files.                    |
| `topics`                  | `reference('topics')[]`                          | Controlled vocabulary (§8).                               |
| `links`                   | `{ label, url }[]`                               | Freeform external links.                                  |
| `related_notes`           | `reference('notebook')[]`                        | Drives backlinks both ways (§8).                          |
| `featured`                | boolean, default false                           | Homepage candidates.                                      |
| `published`               | boolean, default true                            | `false` = in git, built nowhere (§5 caveat applies).      |
| `cv`                      | `{ include?, section?, summary? }`               | CV opt-in/out and overrides (§9).                         |

The `cv` object: `include: boolean` (defaults by type — see §9), `section?: publications | talks | projects | education | awards`, `summary?: string` (overrides `short_description` in CV context).

**Type variants** — `z.discriminatedUnion('type', [...])`, each variant `projectCore.extend({...})`:

| `type`             | Additional fields                                                        |
| ------------------ | ------------------------------------------------------------------------ |
| `software`         | `repository_url`, `package_url`, `languages[]`, `frameworks[]`           |
| `woodworking`      | craft fields: `materials[]`, `finishes[]`, `techniques[]`, `dimensions`  |
| `home-improvement` | same craft fields (shared sub-schema with `woodworking`)                 |
| `talk`             | `venue`, `event_url`, `slides_url`, `video_url`, `coauthors[]`           |
| `paper`            | `venue`, `doi`, `arxiv_id`, `coauthors[]`                                |
| `thesis`           | `institution`, `degree`, `advisor`, `doi`                                |
| `photo-essay`      | `location?`, `occasion?`                                                 |
| `art`              | `medium` + the craft fields                                              |
| `other`            | core only — the explicit catch-all a discriminated union otherwise lacks |

**`photo-essay` vs `art`.** A photo essay is a curated gallery from a trip, event, or session — the core `gallery` _is_ the content, and its detail layout is gallery-first. `art` is for made objects (prints, drawings, whatever comes) where materials and technique matter. They stay separate types because they answer different questions: "where was this and what happened" versus "what is this and how was it made."

Every file declares `type:` explicitly — the discriminator has no default (§2).

Sketch of the config shape (illustrative, not final code):

```ts
// src/content.config.ts
import { defineCollection, reference } from "astro:content";
import { glob, file } from "astro/loaders";
import { z } from "astro/zod"; // Zod 4; astro:content's z is deprecated

const projectCore = z.object({
  title: z.string(),
  short_description: z.string().max(200),
  // …core fields per the table above
});

const projects = defineCollection({
  loader: glob({ pattern: "**/index.md", base: "./src/content/projects" }),
  schema: z.discriminatedUnion("type", [
    projectCore.extend({
      type: z.literal("software"),
      repository_url: z.url().optional() /* Zod 4 top-level format, … */,
    }),
    projectCore.extend({ type: z.literal("woodworking"), ...craftFields }),
    // …one extend per variant; never z.intersection
    projectCore.extend({ type: z.literal("other") }),
  ]),
});
```

## 5. Notebook collection

The digital garden (§1 naming note). Notes are living documents, revisited over time — not blog posts (the blog lives at jonathansick.blog).

| Field           | Type / constraint                                              | Notes                                                        |
| --------------- | -------------------------------------------------------------- | ------------------------------------------------------------ |
| `title`         | string                                                         |                                                              |
| `description`   | optional string                                                |                                                              |
| `created`       | date                                                           | When the note was planted.                                   |
| `revised`       | date                                                           | Explicit frontmatter — see below.                            |
| `maturity`      | `sketch \| draft \| fair-copy \| superseded`, default `sketch` | The notebook metaphor's draft/stable/deprecated lifecycle.   |
| `superseded_by` | optional `reference('notebook')`                               | Required when `superseded` — the successor the layout links. |
| `note_type`     | `note \| essay \| guide \| list`                               | Shape of the content, orthogonal to maturity.                |
| `topics`        | `reference('topics')[]`                                        |                                                              |
| `related`       | `reference('notebook')[]`                                      | Note-to-note links; drives backlinks (§8).                   |
| `projects`      | `reference('projects')[]`                                      | Note-to-project links; drives backlinks (§8).                |
| `published`     | boolean, default true                                          | See "two dials" below.                                       |

**`revised` is an editorial act, not automation.** It is explicit frontmatter, deliberately _not_ derived from git: Cloudflare builds use shallow clones (no history to mine), and a typo fix shouldn't claim the note was "tended." Bumping `revised` is the author saying "this note was substantively revisited" — and it's what the feed gate keys on (§9).

**Maturity stages.** `sketch` (rough, just planted), `draft` (has a thesis, worth a reader's time), `fair-copy` (settled, polished — the notebook term for a cleanly rewritten page), `superseded` (kept for the record, points at its replacement via `superseded_by`). Maturity is displayed as apparatus on every note (Enra Sans, per DESIGN.md's Mechanical Warmth Rule) and is a filter facet on `/notebook`.

**Two independent visibility dials.** `published` and `maturity` are deliberately separate axes:

- `published: false` — the note is committed to git but **built nowhere**: no route, no index, no feed, no sitemap. It's the "safe to commit an interim idea" switch. The field is named `published`, not `draft`, precisely so it doesn't collide with the `draft` maturity stage. _Caveat, recorded here on purpose:_ if the repository is public, the source of an unpublished note is still visible on GitHub — `published: false` is a presentation gate, not a secrecy mechanism.
- `maturity` — how finished the note is. A `sketch` **is** on the site and in the index (gardens show their seedlings); it just stays out of the feed until promoted (§9).

## 6. Library collection

Books, records, films, and TV — each entry a short review essay (the markdown body). Discriminated union on `medium`.

**Core:** `title`, `cover?: cfImage`, `date_added` (date), `date_finished?` (date), `recommended: boolean` (a curation flag — there are no star ratings; the site recommends or it doesn't), `topics: reference('topics')[]`, `external_url?` (Bookshop, Discogs, Letterboxd — a pointer, not an affiliate program), `published` (default true).

**Variants:**

| `medium` | Additional fields                                          |
| -------- | ---------------------------------------------------------- |
| `book`   | `author[]`, `year`, `publisher?`, `isbn?`                  |
| `record` | `artist`, `year`, `label?`, `format?: lp \| cd \| digital` |
| `film`   | `director`, `year`                                         |
| `tv`     | `creator?`, `years` (string, e.g. `"2019–2023"`)           |

Entries live in medium subfolders (`library/books/annihilation.md`), so ids contain a slash and the detail route is a rest param, `/library/[...id]`. The subfolder is **deliberately redundant** with the `medium` field — the folder organizes the repo, the field types the schema — and index pages assert the two agree so a misfiled entry fails the build rather than rendering in the wrong shelf.

## 7. Media & files (Cloudflare)

All imagery is served from Cloudflare Images; downloadable files from R2. Sub-schemas live in `src/schemas/media.ts` and are shared across collections.

### cfImage

```yaml
thumbnail:
  id: projects/hall-table/finished-01
  alt: Walnut hall table with hand-cut dovetails, in afternoon light
  caption: The finished table, June 2026
  width: 3024
  height: 4032
```

- `id` (Cloudflare Images ID), `alt` (**required** — no alt, no build), `caption?`, `width`, `height`.
- Delivery URL: `https://imagedelivery.net/<ACCOUNT_HASH>/<id>/<variant>`. The account hash comes from `PUBLIC_CF_IMAGES_HASH`; `src/lib/images.ts` builds URLs and srcsets.
- Enable **flexible variants** in the Cloudflare dashboard for arbitrary-width srcsets, plus named variants **`thumb`**, **`gallery`**, **`full`**, and **`og`** (1200×630) for the fixed roles.
- `width`/`height` are required in frontmatter because there is no build-time dimension API without a network call per image; layouts need them for aspect-ratio boxes (no layout shift). A backfill script that queries the Images API is a noted follow-up.
- _Recorded limitation:_ images with **custom IDs** (like the readable `projects/hall-table/finished-01` style above) cannot be served signed/private. Fine for a public site; don't put anything private behind a custom ID.

### galleryItem

Discriminated union on `kind`:

- **`photo`** — a `cfImage` plus `stage: process | finished`, so project galleries can separate build photos from glamour shots.
- **`video`** — an R2-hosted mp4 (`key`) with a `poster: cfImage`. **This is the default for short clips**: native `<video>`, no Stream billing.
- **`stream`** — a Cloudflare Stream `uid`, for long or adaptive-bitrate content like talk recordings.

### attachment

`{ key, label, media_type?, bytes? }` — files served from a **public R2 bucket on a custom domain** (e.g. `files.jonathansick.ca`; the default `r2.dev` URLs are rate-limited and not for production). Base URL from `PUBLIC_FILES_BASE_URL`; `src/lib/files.ts` joins keys to URLs. `bytes` lets layouts print "PDF, 2.4 MB" without a HEAD request.

## 8. Taxonomy, cross-links, backlinks

**One controlled vocabulary.** `topics` is a `file()` data collection over `src/data/topics.yaml` — a list of `{ id, name, description }`. All three content collections reference it via `reference('topics')`, and the same records supply display copy for the `/topics/[id]` hub pages, which gather everything (projects, notes, library entries) sharing a topic.

**Dangling references fail the build.** Because `reference()` doesn't check existence (§2), `src/lib/taxonomy.ts` exposes a throwing `resolveTopics()` used by every page that renders topics. A typo'd topic id becomes a build failure, not a silently empty link.

**Backlinks.** "Linked from" lists on notes and projects are derived at build time in `src/lib/backlinks.ts` from the frontmatter reference fields (`related`, `projects`, `related_notes`) — one memoized pass over all collections, inverted into a map. Parsing markdown bodies for inline links is a listed future enhancement, not v1.

## 9. /now, CV pipeline, filtering, feeds

### /now

Schema: `{ date, title?, location?, summary? }`. One file per update, named by full date (`now/2026-07-09.md`) — the filename is the id and the permalink. Full-date stamps are deliberate: cadence can be irregular (two updates in a week, then a quiet quarter) without a monthly naming scheme going stale. `/now` renders the newest entry with a "Previously" list of permalinks.

**Field reports.** The `/notebook` index merges now entries through a small adapter (`src/lib/`): each becomes a `kind: 'field-report'` item with a distinct badge, linking to its `/now/...` permalink. The notebook is the field kit; the now page is its dated field reports.

### CV pipeline

`/cv` renders from two sources merged at build time by `src/lib/cv.ts` (pure and testable):

1. `src/data/cv.yaml` — a **pure JSON Resume document** (https://jsonresume.org/schema). Keeping it standard means external jsonresume tooling (themes, exporters) keeps working; nothing site-specific leaks in.
2. Project-derived entries: gather projects where `cv.include ?? defaultByType` — `paper`, `talk`, and `thesis` default **in**; everything else defaults **out**; any project can flip its default.

Mapping: `paper → publications`, `talk → talks`, `thesis → education` _and_ `publications`; `cv.section` overrides the destination, `cv.summary` overrides the description. Merge with the YAML sections, sort descending by date, and **dedupe by DOI, then by normalized title** — when a YAML entry and a project describe the same artifact, the project entry wins (it has the richer detail page to link to). Optional `/cv.json` endpoint emits the merged document as JSON Resume. A Claude skill for CV maintenance is a noted follow-up, out of scope here.

### Index filtering

Static-build-compatible, two tiers:

- **Pre-rendered single-facet pages:** `/projects/type/[type]` and `/topics/[id]` — real URLs, crawlable, zero JS.
- **Combined facets** on `/projects` and `/notebook` (type × topic × maturity) are progressive enhancement: vanilla JS toggling visibility over `data-*` attributes, with History-API query-param sync so filtered views are shareable. No JS → the full index, still fine.

No pagination in v1 — the corpus is curated dozens, not thousands. Astro's `paginate()` slots in later without schema changes.

Unpublished entries (`published: false`) are excluded from routes, indexes, feeds, and the sitemap — enforce with a shared `getPublished()` helper rather than per-page filters.

### Feeds & sitemap

`/feed.xml` via `@astrojs/rss`, combining all dated collections. The policy is **new-items-only + POSSE**:

- An item emits **once, when published** — never on edits. Guids are stable.
- **Notebook feed gate: maturity ≥ `draft`.** Sketches are on the site and in the index but stay out of the feed — subscribers' attention isn't spent on stubs. A note enters the feed once, on first promotion past `sketch`, with `pubDate = revised` at promotion time — so it surfaces as _new_ when it becomes worth reading, not back-dated to when it was planted. `superseded` notes never emit.
- Projects, now updates, and library entries emit on publication: `pubDate = date_start` / `date` / `date_added` respectively.
- **Edit visibility** comes from two channels, neither of them the feed: a "recently revised" strip on the `/notebook` index (sorted by `revised`), and hand-announced significant rewrites via micro.blog, which POSSEs to Bluesky and Mastodon.

_Rejected alternatives, recorded so they aren't re-litigated:_ a change-based feed (items re-emitting on `revised` bumps) causes guid churn and near-duplicate items in readers; putting sketches in the feed spends subscriber attention on stubs and pressures sketches to be born finished, which kills the garden.

Per-section feed URLs (`/notebook/feed.xml`, `/projects/feed.xml`, …) are **reserved** — same item shapes, filtered — but not v1.

`@astrojs/sitemap` with `lastmod` from `revised`/date fields. Both RSS and sitemap require `site` in `astro.config.mjs` (§2).

## 10. Completeness roadmap

Documented so they're planned, not discovered:

- **404 page** — a wordplay opportunity ("off the surveyed map"), per PRODUCT.md's load-bearing wit.
- **`/colophon`** — how the site is made; the footer already gestures at it ("Coded by hand in Penetanguishene").
- **Legacy-URL redirect inventory** in `public/_redirects` (Cloudflare), including the `/making` → `/projects` 301 (§1).
- **Per-entry OG images** via the `og` (1200×630) Cloudflare Images variant.
- **`robots.txt`**.
- **JSON-LD** — `Person` on `/`, `ScholarlyArticle` on paper pages.
- **`rel="me"`** links for Mastodon verification.
- **Print stylesheet** for `/cv`.
- **Pagefind search** once the notebook has enough mass to need it.

## 11. Explicit uncertainties

Flagged so implementation verifies rather than assumes:

- **Zod 4 defaulted-discriminator behavior** — unverified; the design avoids depending on it (every file declares its discriminator, §2).
- **`image()` helper × discriminated unions** — unexercised here; all imagery is remote (Cloudflare Images), so the local-asset helper never meets a union. If local images ever enter frontmatter, test this first.
- **`@astrojs/rss` / `@astrojs/sitemap` / `@astrojs/mdx` compatibility with Astro 7.0.6** — confirm versions at install time.
- **`astro:env` API surface** in Astro 7 — if it differs from expectations, the fallback is plain `import.meta.env.PUBLIC_*` (both `PUBLIC_CF_IMAGES_HASH` and `PUBLIC_FILES_BASE_URL` are public values; no secrets involved).

## 12. Implementation sequencing

The build order, each step leaving the site green (this document specifies; it does not execute):

1. **Dependencies + config** — `@astrojs/rss`, `@astrojs/sitemap` (versions per §11); add `site` to `astro.config.mjs`.
2. **Schemas** — `src/content.config.ts` with all seven collections + `src/schemas/media.ts`; seed one entry per collection; `astro sync` to confirm generated types.
3. **`src/lib/` utilities** — `images.ts`, `files.ts`, `taxonomy.ts`, `cv.ts`, the now→notebook adapter, `backlinks.ts`.
4. **Detail routes** — `/projects/[id]`, `/notebook/[id]`, `/library/[...id]`, `/now/[id]`.
5. **Indexes + facets** — `/projects`, `/notebook`, `/library`, `/now`, `/topics/[id]`, `/projects/type/[type]`; nav update + `/making` redirect.
6. **`/cv` and `/uses`**.
7. **Feeds, sitemap, redirects, 404, colophon.**
