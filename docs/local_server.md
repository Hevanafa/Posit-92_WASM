# Starting a Local Server

Posit-92 (WASM) projects need to be served through a local HTTP server rather than from the filesystem or directly run by Lazarus

Any ordinary static HTTP server should work

## Bun

I made a dedicated server script that can be used specifically with Bun

1. Run:
   ```powershell
   bun .\server.ts
   ```
2. Open `http://localhost:8008` in your browser
3. Check that the "Hello world!" page appears

The Bun server is only one option; you can use another static HTTP server if you want

## Other HTTP servers

NPM http-server:

```powershell
npx http-server -c-1 .
```

`-c-1` invalidates all the cached files

You can use any language that can serve a static HTTP server, be it Python, Perl, Ruby, PHP, or even Pascal, as long as the `index.html`, `game.wasm`, and the app assets are accessible
