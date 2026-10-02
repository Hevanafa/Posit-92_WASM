# Stack requirements

This document shows tested stack envelopes

## TL;DR

For projects using Free Pascal RTL units such as `SysUtils`, `Classes`, `FGL`, and `Math`:

Recommended stack size: **512 KB**

**384 KB** has been tested and works, while **320 KB and below crashes**

For minimal Posit-92 projects without the Free Pascal RTL:

**320 KB** has been tested and works

These are tested stack envelopes, not guaranteed minimum requirements

You can change the supposed stack region in the `P92WasmHeap` unit

## Details

**Minimal Posit-92**

```text
WASM memory: 2 MB
Stack: 320 KB
Pool: 128 KB
Status: tested
```

"Minimal" in this case means there's no Free Pascal RTL involved, so everything is built-in by Posit-92

**SysUtils + Classes + FGL test + Math**

Original test:

```text
WASM memory: 32 MB
Stack: 4 MB
Pool: 128 KB
Status: tested
```

Various stack size tests:

```text
4 MB: works
2 MB: works
1 MB: works
768 K: works
512 K: works
384 K: works
320 K: crashes
256 K: crashes
```
