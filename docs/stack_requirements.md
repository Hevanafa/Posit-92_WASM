# Stack requirements

This document shows tested stack envelopes

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
256 K: crashes
```
