# Changelog - POKE SWITCH

All notable changes to this project will be documented in this file.

---

## [1.3.0] - 2026-05-30

### Added
- **Horizontal Pokémon Tabs System (Showdown Style)**: Implemented an horizontal selector bar (`rl-tabs-bar`) displaying mini-sprites and compact names for player team slots and rival threat slots.
- **Tab-Based Switchable Card Engine**: Upgraded rendering dynamics to only display a single active card at a time based on selected tab:
  - Drastically minimized page scroll depth on **Mobile-First viewports**.
  - Persists active selected indexes (`activeRlTabIdx` and `activeRlRivalTabIdx`) seamlessly across edits, stats adjustments, and live matchups calculations.

---

## [1.2.0] - 2026-05-30

### Added
- **Premium Randomlocke Cards Interface**: Replaced the legacy rigid tabular format for both player team and rival threats with an E2E highly responsive grid of premium cards.
- **Showdown-Inspired Layout**: Brought the best features of Pokémon Showdown's Teambuilder to life with premium modern aesthetics:
  - **Identificadores Visuales**: Animated/static sprites, type badges, and Outfit-based typography headers.
  - **Dynamic Attributes & Selectors**: Clean level badges, gender markers, shiny indicators, and customized hoverable selectors for **Items**, **Abilities**, and **Natures** linked to PokeAPI.
  - **Showdown-Style Move Slots**: Stylized interactive slots mapped to the move's elemental type, showing category icon (💥, 🌀, 🛡️), power, and accuracy at a glance.
  - **Direct Stats & Boosts**: Embedded stats bar widget directly within the card structure, including Altered Status pill selectors and fully operational stage boosts (-6 to +6) to streamline live matchup calculations.
- **Glassmorphism Design Tokens**: Subtle blur filters, harmonious pastel type-matching palettes, thin slate borders, and dynamic elevating hover transitions.

### Changed
- **HTML Cleanup**: Refactored the core `index.html` markup to substitute structural `table` hierarchies with clean flex/grid `div` systems, reducing total file size and rendering paint overhead.
- **Responsive Layout**: Reconfigured grid mappings using custom CSS query limits to seamlessly wrap card sub-sections (moves, stats, details) for absolute readability on all modern screen factors.
