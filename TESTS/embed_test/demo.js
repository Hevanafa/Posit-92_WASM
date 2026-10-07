/**
 * @type {Map<string, HTMLIFrameElement>}
 */
const instances = new Map();

function spawnDemo(sender) {
  if (sender == null)
    throw new Error("sender is required");

  const src = sender.dataset.src;

  if (src == null || src == "")
    throw new Error("src is required");

  if (instances.has(src)) return;

  const iframe = document.createElement("iframe");

  iframe.src = src;
  iframe.width = "640";
  iframe.height = "400";
  iframe.style.border = "none";
  iframe.style.display = "block";

  // document.body.appendChild(iframe);
  sender.after(iframe);
  instances.set(src, iframe);

  return iframe;
}

window.addEventListener("message", e => {
  if (e.origin != window.location.origin) return;
  if (e.data?.from != "posit-92") return;

  // console.log(e.origin, e.data);

  for (const [src, frame] of instances) {
    if (frame.contentWindow == e.source) {
      frame.remove();
      instances.delete(src);
      break
    }
  }
})
