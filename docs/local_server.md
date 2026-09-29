## Alternative: Bun

Requires: **[Bun](https://bun.com/)** (at least v1.3.5) either to transpile the engine code or to start the local HTTP server

I decided to move this as optional because of the obscure error message when I tried to get this started on my old laptop from 2017

```text
(Posit-92 engine folder)> bun build .\posit-92.ts
error: Cannot read file "C:\": EPERM
```

### Starting the localhost server

I made a dedicated server script that can be used specifically with Bun

1. Run `bun .\server.ts`
2. Open `http://localhost:8008` in your browser to see if the "Hello world!" actually appears
