#!/bin/sh
set -ex

function realpath {
	printf '%s\n' "$(cd -P -- "$(dirname -- "${1}")" && pwd -P)/$(basename -- "${1}")"
}

BOXPATH="$(realpath "${1}")"
BOXSIZE="$(stat -f '%z' "${BOXPATH}")"
BOXMODIFIED="$(date -ur "$(stat -f '%m' "${BOXPATH}")" '+%Y-%m-%dT%H:%M:%SZ')"
BOXSHA256="$(shasum -a 256 "${BOXPATH}" | awk '{ print $1 }')"

TMPDIR="$(mktemp -d)"

echo 'Directory Transport Version: 1.1' > "${TMPDIR}/version"

ln -s "${BOXPATH}" "${TMPDIR}/${BOXSHA256}"

CONFIGPATH="${TMPDIR}/config.json"
cat << EOF > "${CONFIGPATH}"
{
  "architecture": "amd64",
  "os": "vmware_fusion",
  "os.version": "12",
  "rootfs": {
    "type": "layers",
    "diff_ids": [
      "sha256:${BOXSHA256}"
    ]
  }
}
EOF
CONFIGSIZE="$(stat -f '%z' "${CONFIGPATH}")"
CONFIGSHA256="$(shasum -a 256 "${CONFIGPATH}" | awk '{ print $1 }')"
mv "${CONFIGPATH}" "${TMPDIR}/${CONFIGSHA256}"

GITDES="$(git describe --always --dirty --tags)"
GITREV="$(git rev-parse HEAD)"
cat << EOF > "${TMPDIR}/manifest.json"
{
  "schemaVersion": 2,
  "config": {
    "mediaType": "application/vnd.oci.image.config.v1+json",
    "digest": "sha256:${CONFIGSHA256}",
    "size": ${CONFIGSIZE}
  },
  "layers": [
    {
      "mediaType": "application/vnd.oci.image.layer.v1.tar+gzip",
      "digest": "sha256:${BOXSHA256}",
      "size": ${BOXSIZE},
      "annotations": {
        "org.opencontainers.image.title": "package.box"
      }
    }
  ],
  "annotations": {
    "com.github.package.type": "vagrant_box",
    "org.opencontainers.image.authors": "@t0rr3sp3dr0",
    "org.opencontainers.image.created": "${BOXMODIFIED}",
    "org.opencontainers.image.description": "macOS GitHub Actions Self-Hosted Runner Vagrant Box built with Packer",
    "org.opencontainers.image.revision": "${GITREV}",
    "org.opencontainers.image.source": "https://github.com/inloco/mactions/tree/${GITREV}",
    "org.opencontainers.image.title": "mactions",
    "org.opencontainers.image.url": "https://github.com/inloco/mactions",
    "org.opencontainers.image.vendor": "incognia",
    "org.opencontainers.image.version": "${GITDES}"
  }
}
EOF

rm -fR ./build
mv "${TMPDIR}" ./build
