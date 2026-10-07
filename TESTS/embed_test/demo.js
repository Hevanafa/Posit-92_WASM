/**
 * @type {HTMLIFrameElement}
 */
// var iframeInstance = null;


// function spawnDemo() {
//   if (iframeInstance == null) {
//     iframeInstance = document.createElement("iframe");

//     iframeInstance.src = src;
//     iframeInstance.setAttribute("width", "640");
//     iframeInstance.setAttribute("height", "400");
//     iframeInstance.style = "border: none";
    
//     document.body.appendChild(iframeInstance)
//   }
// }

/**
 * @type {Map<string, HTMLIFrameElement>}
 */
const instances = new Map();

function spawnDemo(src) {
  if (src == null || src == "")
    throw new Error("src is required");

  if (instances.has(src)) return;

  const iframe = document.createElement("iframe");

  iframe.src = src;
  iframe.width = "640";
  iframe.height = "400";
  iframe.style.border = "none";

  document.body.appendChild(iframe);

  instances.set(src, iframe);

  return iframe;
}

window.addEventListener("message", e => {
  // console.log(e.origin, e.data);

  if (e.origin != window.location.origin) return;
  if (e.data?.from != "posit-92") return;
  
  console.log(e.origin, e.data);

  if (iframeInstance != null) {
    document.body.removeChild(iframeInstance);
    iframeInstance = null
  }
})
