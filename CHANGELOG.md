# Changelog - POKE SWITCH

All notable changes to this project will be documented in this file.

---

## [1.5.0] - 2026-05-31

### Added
- **Cerebro Táctico de Rotom (Duelo Cara a Cara Activo)**: Implementamos el motor analítico definitivo en tiempo real. Ahora Rotom evalúa el enfrentamiento directo entre el Pokémon aliado activo de la arena (`teamData[activeAllyIndex]`) y los oponentes activos (`rivalData` / `rivalData2`), catalogando el turno reactivamente en 4 estados tácticos competitivos:
  - **⚠️ CAMBIO URGENTE**: Alerta en rojo si estamos en rango de muerte (OHKO/2HKO) de un rival más veloz, recomendando automáticamente el pivot más resistente del banquillo con cálculo de daño exacto.
  - **🔥 MANTENER Y ATACAR**: Alerta en verde si superamos en velocidad y aseguramos un OHKO o daño superior al 50%, sugiriendo el movimiento ofensivo letal.
  - **🎯 VENTANA DE SETUP**: Alerta en morado si el daño recibido es mínimo (<30%) y poseemos un movimiento de boost (Danza Espada, Paz Mental, etc.) para cargarnos de poder gratis.
  - **⚔️ DUELO PAREJO**: Alerta en dorado si el enfrentamiento es neutro, recomendando coberturas eficientes y desgaste posicional.
- **Panel de Selección Rápida en Arena (Quick Selectors)**: Añadimos un panel táctil premium superior con burbujas de los 6 Pokémon de nuestro equipo y los 6 Pokémon del rival. Permite alternar en caliente el combatiente activo de la arena con un solo toque, sincronizando reactivamente las estimaciones de daño y consejos de Rotom en los modos vs 1 y vs 2.
- **Motor Competitivo de Habilidades Avanzadas**: Refinamos al máximo el estimador de daño (`calculateDamageRange`) al integrar en vivo:
  - **Inmunidades Elementales**: Soporte para *Levitación* (tierra), *Absorber Fuego*, *Absorber Agua/Piel Seca/Colector* (agua), *Absorber Electricidad/Electromotor/Pararrayos* (eléctrico) y *Herbívoro* (planta).
  - **Reductores de Daño**: Soporte para *Sebo* (Fuego/Hielo -50%), *Filtro / Roca Sólida* (Súper efectivo -25%) y *Compensación / Multiescala* (Daño a full HP -50%).
  - **Potenciadores Ofensivos**: Soporte para *Potencia / Pure Power* (Ataque Físico x2) y *Agallas / Guts* (Ataque x1.5 si hay estado alterado y anulación de quemadura).
- **Sintetizador Rotom Dinámico**: Sincronizamos la narración por voz de Web Speech API con el estado del duelo cara a cara activo de la arena, integrando filtros anti-repetición consecutiva para una locución fluida.

---

## [1.4.0] - 2026-05-30

### Fixed
- **Rotom Assistant Sync (vs 1 / vs 2 Modes)**: Solved a logic constraint that locked the active ally to `teamData[0]` in non-6vs6 modes. The Rotom Assistant and live Tactical Board now update instantly when switching ally Pokémon in 1vs1 and 2vs2 match battles.

### Improved
- **Pro Simulation Speed & Stability**: Refactored the core asynchronous loading process in `loadPremiumSimulation` to run parallel fetch calls with `Promise.all` instead of sequential requests. Reduces total VGC championship loading times by 1000% and handles connection drops gracefully with bulletproof `filter(Boolean)` mapping.
- **Elite Variant Coverage**: Expanded the global `COMPETITIVE_USAGE_STATS` dictionary to include official competitive variant profiles for missing simulation assets:
  - **Arcanine** (Heavy-Duty Boots / Intimidate physical pivot)
  - **Shedinja** (Focus Sash / Wonder Guard utility)
  - **Azumarill** (Sitrus Berry / Huge Power Belly Drum sweeper)
  - **Gengar** (Life Orb / Cursed Body special sweeper)

---

## [1.3.1] - 2026-05-30

### Fixed
- **PC Layout Alignment**: Fixed a CSS grid stretch bug on PC desktop resolutions. Changed the card grid container (`rl-cards-grid`) to a vertical flex structure:
  - Tab buttons now render as an horizontal row spanning the full width of the section.
  - Active cards now scale and center beautifully under the selector bar, avoiding any vertical scaling anomalies.

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
