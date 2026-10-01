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

All the commands listed here assume that you're already in a demo/test project where the `index.html` file sits

**NPM http-server**

```powershell
npx http-server -p 8008 -c-1
```

`-p` or `--port` makes it serve at a certain port

`-c-1` invalidates all the cached files

**Perl http_this**

This requires HTTPThis. Installing it is easy:

```powershell
cpanm App::HTTPThis
```

I use Perl v5.38.2 to run this command

Then, after the installation is complete, use this command:

```powershell
http_this --port 8008 --autoindex
```

`--port` makes it serve at a certain port

`--autoindex` makes it serve the `index.html`, without it, `http_this` defaults to listing the directory

---

You can use any language that can serve a static HTTP server, be it Python, Ruby, PHP, or even Pascal, as long as the `index.html`, `game.wasm`, and the app assets are accessible
