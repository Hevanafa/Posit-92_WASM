/**
 * @type {HTMLIFrameElement}
 */
var iframeInstance = null;

function spawnDemo() {
  if (iframeInstance == null) {
    iframeInstance = document.createElement("iframe");

    iframeInstance.src = "hello_demoscene";
    iframeInstance.setAttribute("width", "640");
    iframeInstance.setAttribute("height", "400");
    iframeInstance.style = "border: none";
    
    document.body.appendChild(iframeInstance)
  }
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
