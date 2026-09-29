# Embedding on webpages

This document acts as a guideline, so feel free to improvise based on what works for your project

Think of it more like "A Posit-92 embed generally looks like this"

## Basic iframe setup

You can use this snippet anywhere, as long as it points to your preferred localhost server

```html
<iframe src="http://localhost:8008" width="640" height="400"></iframe>
```

In this case, I'm using `server.ts`, which basically serves `index.html` as the entry point

## Recommended HTML structure

As for the entry point, `hello_demoscene` and `hello_intro` have the proper structure, since the `<canvas>` tag itself is automatically inserted by Posit-92

See `index.html` of each demo project to see the details

## Embedding on WordPress

You can add a block resembling a full-width `<div>`, then align items to the centre

After that, insert a **Custom HTML block** containing the same `<iframe>` tag mentioned above, but now with the `border: none`

```html
<iframe src="/your_game_folder/" width="640" height="400" style="border: none">
</iframe>
```

You should change the `src` attribute with wherever you have the game files, as long as it points to the entry point `index.html`

Consider using binaryen's **wasm-opt** to reduce the size of the game's WASM binary.  The build script `optimise_wasm.pl` has the working command line

## Complete example

(TBA)