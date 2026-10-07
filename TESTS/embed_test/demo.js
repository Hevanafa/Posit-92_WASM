/**
 * @type {Map<string, { iframe: HTMLIFrameElement, sender: HTMLElement } >}
 */
const instances = new Map();

/**
 * 
 * @param {HTMLButtonElement} sender 
 * @returns 
 */
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
  sender.disabled = true;
  instances.set(src, { iframe, sender });

  return iframe;
}

window.addEventListener("message", e => {
  if (e.origin != window.location.origin) return;
  if (e.data?.from != "posit-92") return;

  // console.log(e.origin, e.data);

  for (const [src, { iframe, sender } ] of instances) {
    if (iframe.contentWindow == e.source) {
      iframe.remove();
      sender.disabled = false;
      instances.delete(src);
      break
    }
  }
})
