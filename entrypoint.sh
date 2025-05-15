#! /usr/bin/env sh
set -e
# set -x

SERVER_CONTEXTPATH=${SERVER_CONTEXTPATH:-""}
SERVER_CONTEXTPATH_KUMA="${SERVER_CONTEXTPATH#/}"

# Modify paths in index.html and referenced files
if [ -n "$SERVER_CONTEXTPATH" ]; then

    # Update paths in the index.html file
    sed -i.bak "s|href=\"/|href=\"${SERVER_CONTEXTPATH}/|g" /app/dist/index.html
    sed -i.bak "s|src=\"/|src=\"${SERVER_CONTEXTPATH}/|g" /app/dist/index.html
    sed -i.bak "/<head>/a <base href=\"${SERVER_CONTEXTPATH}/\">" /app/dist/index.html

    # Update paths in all JavaScript files in the assets directory
    for js_file in /app/dist/assets/*.js; do
        sed -i.bak "s|/socket.io|${SERVER_CONTEXTPATH}/socket.io|g" "$js_file"
        sed -i.bak "s|/api|${SERVER_CONTEXTPATH}/api|g" "$js_file"
        sed -i.bak "s|/icon.svg|${SERVER_CONTEXTPATH}/icon.svg|g" "$js_file"
        sed -i.bak "s|\"assets/|\"${SERVER_CONTEXTPATH_KUMA}/assets/|g" "$js_file"
        sed -i.bak "s|location.href=\"/status/|location.href=\"${SERVER_CONTEXTPATH}/status/|g" "$js_file"
        sed -i.bak "s|href:\"/status/\"|href:\"${SERVER_CONTEXTPATH}/status/\"|g" "$js_file"
        sed -i.bak "s|src:\s*\([^,]*\)|src: \"${SERVER_CONTEXTPATH}\" + \1|g" "$js_file"
        sed -i.bak "s|href:\"/manage-status-page\"|href:\"${SERVER_CONTEXTPATH}/manage-status-page\"|g" "$js_file"
        sed -i.bak "s|location.href=\"/page-not-found\"|location.href=\"${SERVER_CONTEXTPATH}/page-not-found\"|g" "$js_file"
    done

    for js_file in /app/dist/assets/*.js; do
        gzip -c "$js_file" > "$js_file.gz"
    done

    echo "SERVER_CONTEXTPATH is ${SERVER_CONTEXTPATH} and files are updated."
else
    echo "SERVER_CONTEXTPATH is set to: ${SERVER_CONTEXTPATH}"
fi

exec "$@"
