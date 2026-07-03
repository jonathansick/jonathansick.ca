import { defineConfig } from "eslint/config";
import eslintPluginAstro from "eslint-plugin-astro";

// ESLint only covers .astro files; Biome lints and formats JS/TS/JSON/CSS.
export default defineConfig([
  // Third-party Claude Code assets (installed skills + hooks) are not developed here.
  {
    ignores: [
      "dist/",
      ".astro/",
      ".claude/",
      ".github/skills/",
      ".github/hooks/",
    ],
  },
  ...eslintPluginAstro.configs.recommended,
  ...eslintPluginAstro.configs["jsx-a11y-recommended"],
]);
