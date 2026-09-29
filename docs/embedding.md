# Embedding on webpages

## Basic iframe setup

You can use this snippet anywhere, as long as it points to your preferred localhost server

```html
<iframe src="http://localhost:8008" width="640" height="400"></iframe>
```

In this case, I'm using `server.ts`, which basically serves `index.html` as the entry point

## Recommended HTML structure

As for the entry point, `hello_demoscene` and `hello_intro` have the proper structure, since the `<canvas>` tag itself is automatically inserted by Posit-92

See `index.html` of each demo project to see the details
