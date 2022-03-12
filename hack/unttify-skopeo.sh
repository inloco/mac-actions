#!/bin/sh
set -ex

LINK=$(which skopeo)
REAL=$(dirname "${LINK}")/$(readlink "${LINK}")

WRAPER=$(mktemp)
chmod +x "${WRAPER}"

cat << EOF > "${WRAPER}"
#!/bin/sh
unttify '${REAL}' "\${@}"
EOF

unlink "${LINK}"
mv "${WRAPER}" "${LINK}"
