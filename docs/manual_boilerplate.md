# Manual boilerplate copying

This document is more of a guideline on how to get started with the statically linked Posit-92 engine

## Preparation

### First pass

- Create a new folder for your project
  - For example: `Posit-92_hello_world`
- Copy the content of `hello_demoscene` to your project directory

#### What to copy exactly?

- `game.lpr`, `assets.pas`, `project.lpi` - The Pascal entry point along with the Lazarus project information
- `index.html`, `game.js`, `posit-92.css` - The webpage & JS entry point

The thing about `assets.pas` is that you can place it in `units` or at the root project, as long as the compiler can find it

#### Required assets

All the default assets are located in the `assets` directory

- `fonts\`:
  - P92 Sans BMFont images & font definitions
  - P92 Boot font
  - Font licence
- `btn_play.png` - Posit-92 logo used by the play button
- `posit-92_64px.png` - required by the loading screen before WASM initialisation
- `images\`:
  - default cursor
  - Specimen P-92 (2 frames) - Posit-92's slime girl mascot head

### Second pass

- Enter `experimental` then run `tsc` once
  - This step is to transpile the engine's glue code
- Copy these files to your project's root:
  - `experimental\engine\posit-92.js` - this is the engine's main glue code
  - `experimental\mixins\` then pick your mixin files, typically `p92-bmfont.mixin.js` and `p92-sound.mixin.js`

### Third pass

- Copy `experimental\units` to your project root, then rename it as `engine`
- Create a new folder named `units` at your project root
  - This is where your custom units will live
- Open `project.lpi` with Lazarus
- Edit the unit paths in **Project menu > Project options**, then scroll down to **Compiler Options**
- Click **Paths**
- Then, change **Other unit files (-Fu)** to `engine;units`
- Press OK
- After that, save your project options from the Project menu, then click **Save Project**

## Path setup using Lazarus

- Open `project.lpi` with Lazarus IDE
- Double check your compiler settings in **Tools menu > Options**

The compiler executable and FPC source directory must match the target `wasm32-embedded`

For example:

Compiler executable:

```text
E:\fpc-wasm\fpc\bin\x86_64-win64\fpc.exe
```

FPC source directory:

```text
E:\fpc-wasm\fpcsrc
```

As far as I know, there's no build & run option by default, since the project type is a `library` anyway

## Compiling to WASM

### Using Lazarus

Simply by using **Run menu > Compile** (`Ctrl+F9`), it can already output `game.wasm`

### Command line using Perl

- `make_demo.pl` for demo projects,
- `make.pl` for your own standalone project

## Running

Refer to [local_server.md](./local_server.md) to start a local server
