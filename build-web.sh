#!/bin/bash
# Build the Walkthrough Notes browser version into public/app/.
# Injects the same native-speech-shim + autosave + ops layers the APK build
# uses (the shim and native bridges no-op in a plain browser), plus PWA tags.
set -e
SITE="$(cd "$(dirname "$0")" && pwd)"
SRC_HTML="$HOME/workspace/your_files/walkthrough-notes/walkthrough-notes.html"
PROJ="$HOME/workspace/walkthrough-apk"
OUT="$SITE/public/app/index.html"

python3 - "$SRC_HTML" "$PROJ/native-speech-shim.js" "$PROJ/autosave.js" "$PROJ/ops.js" "$OUT" <<'EOF'
import sys
src, shim_path, autosave_path, ops_path, out = sys.argv[1], sys.argv[2], sys.argv[3], sys.argv[4], sys.argv[5]
html = open(src, encoding="utf-8").read()
shim = open(shim_path, encoding="utf-8").read()
autosave = open(autosave_path, encoding="utf-8").read()
ops = open(ops_path, encoding="utf-8").read()

# PWA head tags
pwa = ('<link rel="manifest" href="manifest.json">'
       '<meta name="theme-color" content="#175f43">'
       '<link rel="icon" type="image/png" sizes="192x192" href="icon-192.png">'
       '<link rel="apple-touch-icon" href="icon-192.png">'
       '<meta name="mobile-web-app-capable" content="yes">'
       '<meta name="apple-mobile-web-app-capable" content="yes">'
       '<meta name="apple-mobile-web-app-status-bar-style" content="default">')
html = html.replace('</head>', pwa + '</head>', 1)

# service worker registration before </body>
swreg = ('<script>if ("serviceWorker" in navigator) {'
         'window.addEventListener("load", function () {'
         'navigator.serviceWorker.register("./sw.js").catch(function () {});'
         '});}</script>')
html = html.replace('</body>', swreg + '</body>', 1)

marker = "<script>"
idx = html.find(marker)
assert idx != -1, "no <script> tag found"
injected = html[:idx] + "<script>\n" + shim + "\n</script>\n" + html[idx:]
# autosave + ops run inside the page's own scope: bare JS, no nested <script> tags
fmarker = "var finalDraft = null;"
fidx = injected.find(fmarker)
assert fidx != -1, "finalDraft marker not found"
eol = injected.find("\n", fidx)
injected = (injected[:eol+1] + "\n/* ---- APK autosave (build-injected) ---- */\n"
            + autosave + "\n/* ---- Walkthrough Ops expansion (build-injected) ---- */\n"
            + ops + "\n" + injected[eol+1:])
open(out, "w", encoding="utf-8").write(injected)
print("  index.html:", len(injected), "bytes")
EOF
echo "WEB_BUILD_OK"
