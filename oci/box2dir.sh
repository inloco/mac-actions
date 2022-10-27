#!/bin/sh
set -ex

function realpath {
	printf '%s\n' "$(cd -P -- "$(dirname -- "${1}")" && pwd -P)/$(basename -- "${1}")"
}

BOXPATH="$(realpath "${1}")"
BOXMODIFIED="$(date -ur "$(stat -f '%m' "${BOXPATH}")" '+%Y-%m-%dT%H:%M:%SZ')"

TMPDIR="$(mktemp -d)"
TMPTGZ="${TMPDIR}/.tgz"

echo 'Directory Transport Version: 1.1' > "${TMPDIR}/version"

split -b "$((4 * 1024 * 1024 * 1024))" "${BOXPATH}"
for PART in ./x*
do
  tgzarmorer "${PART}" > "${TMPTGZ}"

  rm -fv "${PART}"

  PARTSHA256="$(shasum -a 256 "${TMPTGZ}" | awk '{ print $1 }')"

  mv -fv "${TMPTGZ}" "${TMPDIR}/${PARTSHA256}"

  PARTSHA256S+=("${PARTSHA256}")
done

CONFIGPATH="${TMPDIR}/config.json"
cat << EOF > "${CONFIGPATH}"
{
  "architecture": "amd64",
  "os": "vmware_fusion",
  "os.version": "12",
  "rootfs": {
    "type": "layers",
    "diff_ids": [
$(
  for PARTSHA256 in "${PARTSHA256S[@]}"
  do
    ((++I))

    EOL="$([ "${I}" = "${#PARTSHA256S[@]}" ] || echo ',')"
    echo '      "sha256:'"${PARTSHA256}"'"'"${EOL}"
  done
)
    ]
  }
}
EOF
CONFIGSIZE="$(stat -f '%z' "${CONFIGPATH}")"
CONFIGSHA256="$(shasum -a 256 "${CONFIGPATH}" | awk '{ print $1 }')"
mv -fv "${CONFIGPATH}" "${TMPDIR}/${CONFIGSHA256}"

GITDES="$(git describe --always --dirty --tags)"
GITREV="$(git rev-parse HEAD)"
cat << EOF > "${TMPDIR}/manifest.json"
{
  "schemaVersion": 2,
  "mediaType": "application/vnd.oci.image.manifest.v1+json",
  "config": {
    "mediaType": "application/vnd.oci.image.config.v1+json",
    "digest": "sha256:${CONFIGSHA256}",
    "size": ${CONFIGSIZE}
  },
  "layers": [
$(
  for PARTSHA256 in "${PARTSHA256S[@]}"
  do
    ((++I))

    EOL="$([ "${I}" = "${#PARTSHA256S[@]}" ] || echo ',')"
    echo '    {'
    echo '      "mediaType": "application/vnd.oci.image.layer.v1.tar+gzip",'
    echo '      "digest": "sha256:'"${PARTSHA256}"'",'
    echo '      "size": '"$(stat -f '%z' "${TMPDIR}/${PARTSHA256}")"
    echo '    }'"${EOL}"
  done
)
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

rm -Rfv ./build
mv -fv "${TMPDIR}" ./build
