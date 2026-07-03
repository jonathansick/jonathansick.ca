# Product

## Register

brand

## Users

Three audiences, in priority order:

1. **Jonathan himself.** The site is first a personal web presence and creative outlet — a core place to document learnings and finished work. If it doesn't serve that, nothing else matters.
2. **Peers & community.** Developers, astronomers, designers, and makers arriving from the blog, GitHub, Mastodon, or Instagram. They come to find out who Jonathan is and follow threads into his notes and projects.
3. **Prospective clients (secondary).** People evaluating J.Sick Codes may land here. The site should leave them with a deeper appreciation of who Jonathan is — professional and considered — but it is explicitly **not** a sales funnel. Professional work lives at jsick.codes, which stays lean because this site absorbs the personal side.

## Product Purpose

jonathansick.ca is the home of Jonathan-as-renaissance-person: code, design, making, and nature. It grows in three layers:

1. **The splash.** A homepage that gives a strong, immediate impression of who Jonathan is across all those interests, with links to his digital presence elsewhere.
2. **The digital garden.** Non-linear, interlinked notes documenting learnings on different subjects — living documents, not a chronological blog (the blog lives at jonathansick.blog).
3. **The project directory.** An index of individual creative projects — furniture, code, and more — each with photos, metadata, and notes.

Success looks like: a visitor forms a distinct impression of a specific person within one screen, and a returning visitor finds the garden and directory worth wandering. The site is a made object that happens to be a website.

## Brand Personality

**Handmade, wry, precise.**

Craftsman's humor with engineering rigor. The voice is already on the page: the nav reads as a sentence ("Jonathan Sick / Is / Making"), the footer says "Coded by hand in Penetanguishene." Understatement over exclamation; one good sentence over a section of filler; jokes that reward attention rather than demand it.

The graphic sensibility is **retrofuturistic craft**: the Field Notes move of pairing a traditional medium with a futuristic typeface — tradition and precision in tension. Typographically that means a scholarly serif (Skolar) paired with mechanical warmth (an aspiration to add a typewriter-flavored monospace like Nitti for specific interface elements).

**References:** Maggie Appleton (maggieappleton.com — the illustrated digital garden), Robin Sloan (robinsloan.com — writerly, wry personal-web spirit), Frank Chimero (frankchimero.com — quiet typographic confidence), and Field Notes as a physical object (kraft + Futura retrofuturism).

## Anti-references

- **SaaS/startup landing page.** No gradient heroes, feature grids, CTAs, or metric counters. Marketing-site grammar is banned.
- **Dev-portfolio template.** No hero + project-card grid + skills badges + GitHub stats. The project directory is a curated index with photos and notes, not a card wall.
- **Minimalist gray blog.** No Inter-on-white austerity, no colorless "restraint." The site commits to its palette and its serif.
- **Rustic/artisanal costume** (implied by the retrofuturistic stance): the handmade quality comes from typography, wordplay, and real project photography — never from kraft-paper textures, distressed type, or "hand-crafted" visual clichés.

## Design Principles

1. **Coded by hand.** Every surface should feel individually made — bespoke layout decisions, no template grammar. If a section could be swapped into another developer's site unchanged, it fails.
2. **Tradition in tension with precision.** The retrofuturistic pairing is the aesthetic engine: scholarly serif against mechanical mono, warm craft against exact engineering. Don't resolve the tension; design with it.
3. **Wordplay is load-bearing.** The wit lives in the copy and structure (Is/Making), not in decorative flourishes. Preserve and extend it; never paper over it with generic labels.
4. **A garden, not a funnel.** Navigation invites wandering between notes and projects. No conversion paths, no urgency, nothing that herds the visitor.
5. **One good sentence beats a section.** The current homepage is a single 2rem sentence, and that's the register: confident economy. Add pages, not padding.

## Accessibility & Inclusion

- **WCAG 2.1 AA** is the target: ≥4.5:1 contrast for body text, ≥3:1 for large text.
- Known issue to resolve: the brand red (#ed2024) on the mint background (#defff2) measures ≈4.1:1 — fine for large text, under AA for body-size links. Future work should darken the link treatment or reserve pure brand red for large/decorative use.
- Respect `prefers-reduced-motion` in any future animation work.
- Semantic HTML throughout (the codebase already leans this way: `aria-current` nav states, landmark elements).
