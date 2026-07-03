---
name: jonathansick.ca
description: Personal site of Jonathan Sick — code, design, making, and nature
colors:
  cardinal-red: "#ed2024"
  georgian-bay-mist: "#defff2"
  cedar-mint: "#99ffd6"
  ink: "#000000"
typography:
  display:
    fontFamily: "skolar-pe-variable, serif"
    fontSize: "2rem"
    fontWeight: 400
    lineHeight: 1.5
  body:
    fontFamily: "skolar-pe-variable, serif"
    fontSize: "1.2rem"
    fontWeight: 400
    lineHeight: 1.5
  label:
    fontFamily: "enra-sans-variable, system-ui, sans-serif"
    fontSize: "0.9rem"
    fontWeight: 350
    letterSpacing: "normal"
  small:
    fontFamily: "enra-sans-variable, system-ui, sans-serif"
    fontSize: "0.8rem"
    fontWeight: 400
spacing:
  sm: "1rem"
  md: "2rem"
components:
  nav-link:
    textColor: "{colors.ink}"
    typography: "{typography.label}"
  nav-link-hover:
    textColor: "{colors.cardinal-red}"
  nav-link-active:
    textColor: "{colors.ink}"
  link-inline:
    textColor: "{colors.cardinal-red}"
  link-inline-hover:
    textColor: "{colors.ink}"
  footer-panel:
    backgroundColor: "{colors.cedar-mint}"
    textColor: "{colors.ink}"
    padding: "2rem"
---

# Design System: jonathansick.ca

## 1. Overview

**Creative North Star: "The Surveyor's Field Kit"**

A precision instrument carried into the field: a scholarly serif for the notes, mechanical marks for the apparatus, and one bright signal color flagging what matters. The system is retrofuturistic craft in the Field Notes tradition — a traditional medium paired with precise, forward-looking marks. The mint field is the terrain; Cardinal Red is the surveyor's flag planted in it. Everything is flat, ink-on-paper: depth comes from blocks of color and thin ruled lines, never from shadows or glass.

The personality is handmade, wry, and precise. Wit lives in the copy and structure (the nav reads as a sentence: "Jonathan Sick / Is / Making"), not in decorative flourishes. Surfaces feel individually made — bespoke layout decisions, confident economy, one good sentence where a template would put a section.

This system explicitly rejects the SaaS/startup landing page (gradient heroes, feature grids, CTAs, metric counters), the dev-portfolio template (project-card walls, skills badges, GitHub stats), the minimalist gray blog (Inter-on-white austerity), and rustic/artisanal costume (kraft textures, distressed type). The handmade quality comes from typography, wordplay, and real photography.

**Key Characteristics:**

- Drenched mint field with a single red signal accent
- Scholarly serif prose; uppercase mechanical sans for interface apparatus
- Flat, ink-on-paper depth: color blocks and 1px red rules, no shadows
- Warm and tactile interaction: generous targets, soft transitions, red revealed on touch
- Inline SVG instrument marks (red circle separators, chevron) as navigation punctuation

## 2. Colors

A drenched mint terrain marked with cardinal-red flags and black ink.

### Primary

- **Cardinal Red** (#ed2024): The signal color — the bird in the cedars, the surveyor's flag. Used for inline links, hover states, the nav's SVG punctuation marks (circle separators, chevron), and 1px rules in the footer. It marks points of interest; it never floods a surface.

### Neutral

- **Georgian Bay Mist** (#defff2): The body background — the site's terrain. Every page sits on it; there is no white page mode.
- **Cedar Mint** (#99ffd6): The footer's deeper mint panel. The one tonal step the system takes; a color block doing the work a shadow would do elsewhere.
- **Ink** (#000000): All prose and headings. Pure black on mint reads as ink on tinted stock (≈19.7:1 contrast).

### Named Rules

**The Field-Flag Rule.** Cardinal Red marks, it never fills. Links, rules, icons, hovers — yes. Backgrounds, large panels, full headings — no. Its rarity against the mint is the brand signature.

**The Large-Type Rule.** Cardinal Red on Georgian Bay Mist measures ≈4.1:1 — below the 4.5:1 AA threshold for body text. Red text is therefore reserved for large type (≥1.5rem), hover states arriving from ink, and non-text marks. Body-size text that must stay red needs a darkened red or an ink underline treatment; resolve toward AA, not away from it.

## 3. Typography

**Display Font:** Skolar PE (variable; serif fallback)
**Body Font:** Skolar PE (variable; serif fallback)
**Label Font:** Enra Sans (variable; system-ui sans fallback), uppercase

**Character:** A scholarly serif carrying the prose, with a light mechanical sans handling the apparatus — nav, labels, footer metadata. The pairing is tradition-in-tension-with-precision. A planned third voice: a typewriter-flavored monospace (Nitti or similar) for specific interface elements — metadata, garden-note status marks — to deepen the mechanical warmth.

### Hierarchy

- **Display** (400, 2rem, 1.5): The homepage bio register — one confident sentence at conversational scale. Not a shouting hero; a well-set opening line.
- **Body** (400, 1.2rem base, 1.5): All prose, in Skolar PE. Generous base size; cap measure at 65–75ch (current containers: 40–42rem).
- **Label** (350, 0.9rem, uppercase): Enra Sans for nav and interface labels. Weight rises to 400 (active) and 500 (logo) as emphasis.
- **Small** (400, 0.8rem): Enra Sans footer metadata and colophon text.

### Named Rules

**The Mechanical Warmth Rule.** Serif for what Jonathan says; sans (and eventually mono) for what the machine says. Prose is always Skolar; apparatus — navigation, labels, metadata, status marks — is always the mechanical voice.

## 4. Elevation

Flat, ink-on-paper. No shadows anywhere in the system. Depth is conveyed by color blocks (the Cedar Mint footer panel against the Georgian Bay Mist page) and by thin ruled lines (1px Cardinal Red borders separating footer regions, like ruled lines on a survey form).

### Named Rules

**The Ink-on-Paper Rule.** If an element needs separation, give it a color block or a 1px red rule. `box-shadow` is prohibited. (The shadowed `Card.astro` in the repo is unused Astro-template boilerplate, not part of this system — delete it rather than imitate it.)

## 5. Components

Warm and tactile: generous targets, soft 0.2s transitions, red revealed on touch. Understated at rest, never inert.

### Navigation

- **Style:** Uppercase Enra Sans (0.9rem, weight 350), horizontal flex list with 2rem gaps.
- **Punctuation:** Inline SVG instrument marks — a red chevron after the logo ("Jonathan Sick ›"), red circle outlines between links. The nav is a typeset sentence with mechanical punctuation.
- **Logo:** Weight 500, never underlined.
- **States:** Default ink; hover transitions to Cardinal Red (0.2s ease-in); active page gains weight 400 and an underline with `aria-current="page"`.
- **Mobile:** Currently wraps naturally; keep the sentence reading order intact at all widths.

### Links (inline, in prose)

- **Style:** Cardinal Red, underlined (browser default), inverting to ink on hover — the mirror of the nav's ink-to-red. Subject to the Large-Type Rule at body size.

### Footer

- **Style:** Cedar Mint panel, two-column grid (info | elsewhere links) collapsing to stacked rows below 800px.
- **Rules:** 1px Cardinal Red border separating the columns (right border on desktop, top border when stacked).
- **Typography:** Enra Sans throughout; 0.8rem info column, uppercase 0.9rem weight-200 "Elsewhere" heading.

### Buttons / Inputs

None exist yet. When they arrive: flat mint-or-ink fills, 1px rules, Enra Sans labels, red reserved for hover/focus signals. No rounded-corner pill grammar; the system's corners are square until a deliberate decision says otherwise.

## 6. Do's and Don'ts

### Do:

- **Do** keep the site drenched in Georgian Bay Mist (#defff2) — there is no white-background mode.
- **Do** use Cardinal Red (#ed2024) as a mark: links, 1px rules, SVG punctuation, hover flashes. The Field-Flag Rule.
- **Do** set all prose in Skolar PE at ≥1.2rem with a 65–75ch measure; keep apparatus in Enra Sans (or a future typewriter mono).
- **Do** preserve and extend the wordplay ("Jonathan Sick / Is / Making", "Coded by hand in Penetanguishene") — the wit is load-bearing.
- **Do** hold WCAG AA: ink for body text, red only at large sizes or as non-text marks (the Large-Type Rule).
- **Do** ship real photography for making/garden content — the projects are physical objects; show them.

### Don't:

- **Don't** use SaaS/startup landing-page grammar: no gradient heroes, feature grids, CTAs, or metric counters (PRODUCT.md anti-reference, verbatim).
- **Don't** build the dev-portfolio template: no project-card walls, skills badges, or GitHub stats (PRODUCT.md anti-reference).
- **Don't** drift toward the minimalist gray blog: no Inter-on-white, no colorless "restraint" (PRODUCT.md anti-reference).
- **Don't** costume the craft: no kraft-paper textures, distressed type, or "hand-crafted" visual clichés — the retrofuturistic pairing does that work (PRODUCT.md anti-reference).
- **Don't** use `box-shadow`, glassmorphism, or gradients — flat ink-on-paper only (the Ink-on-Paper Rule).
- **Don't** put body-size Cardinal Red text on mint without an AA-compliant treatment.
- **Don't** imitate `Card.astro` — it is unused template boilerplate slated for removal, not a pattern.
