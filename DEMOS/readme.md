# Demo Projects

The projects in this directory demonstrate Posit-92 features, usually one feature at a time

For implementation details, see the source files inside each demo

Each project has its own `project.lpi`, with `game.lpr` as the entry point


## Boilerplates

- **hello_intro** -- Full project structure with 3 states: intro, loading, and playing
- **hello_demoscene** -- Full structure without the intro sequence
- **hello_minimal** -- The bare minimum Posit-92 application


## Basics

(TODO: Replace this )

- **bigint_demo** -- Shows how big integers are handled via browser API
  - **BigIntMixin** mixin is used here
- **chain_easing** -- Demonstrates how to chain easings
- **collision** -- Demonstrates how to implement simple arcade collisions: rectangle and circle
- **easings** -- Shows how to implement easing
- **fullscreen** -- Shows how to approach the fullscreen feature
- **gamepad_demo**
- **graphics_demo**
- **micro_tlist** -- Demonstrates how to use the built-in `TList` (without the RTL bloat)
- **music** -- Shows a music player that can handle repeat song
  - **Sounds** mixin is used here
- **particles**
- **print_colour**
- **rainbow_screen** -- Demonstrates how to use the `Colour` unit
- **square_screen** -- Demonstrates how to use a custom screen size
- **sound**
  - **Sounds** mixin is used here
- **sprites** -- Sprite loading & various rendering techniques
- **timing** -- Shows the difference between `getTimer` and `getFullTimer`
- **webgl_demo** -- Shows how to setup WebGL with Posit-92
  - **WebGLMixin** mixin is used here

### Advanced

- chase_game
- dos_display

### Immediate GUI

- **immediate_gui**
- **immedgui_nine_slice**
- **immedgui_prompt**

The string interop from Pascal to JS is already demonstrated in `writeLog` mechanism in `LOGGER.PAS` unit

### Sprite Effects

### Screen Effects

- **vga_crt_effect**

### Progressive Web App (PWA)

- **pwa_demo** -- Shows the most basic setup of an installable Progressive Web App
