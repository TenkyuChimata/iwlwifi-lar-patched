#!/usr/bin/env bash
set -Eeuo pipefail

readonly API_URL="${ARCH_LINUX_PACKAGE_API:-https://archlinux.org/packages/core/x86_64/linux/json/}"
readonly OUTPUT_FILE="${GITHUB_OUTPUT:-/dev/null}"

die() {
    echo "ERROR: $*" >&2
    exit 1
}

kernel_base_version() {
    printf '%s\n' "$1" | sed -E 's/\.arch[0-9]+.*$//'
}

echo "Querying Arch Linux package API: ${API_URL}"

package_json="$(
    curl \
        --fail \
        --silent \
        --show-error \
        --location \
        --retry 5 \
        --retry-delay 3 \
        --retry-all-errors \
        "${API_URL}"
)"

api_pkgver="$(jq -er '.pkgver | tostring' <<<"${package_json}")"
api_pkgrel="$(jq -er '.pkgrel | tostring' <<<"${package_json}")"
new_kernelpkgver="${api_pkgver}-${api_pkgrel}"

old_kernelpkgver="$(
    sed -nE \
        's/^_kernelpkgver="?([^"]+)"?$/\1/p' \
        PKGBUILD
)"

[[ -n "${old_kernelpkgver}" ]] ||
    die "Could not read _kernelpkgver from PKGBUILD"

old_pkgrel="$(
    sed -nE \
        's/^pkgrel=([0-9]+)$/\1/p' \
        PKGBUILD
)"

[[ -n "${old_pkgrel}" ]] ||
    die "Could not read pkgrel from PKGBUILD"

echo "Current package kernel: ${old_kernelpkgver}"
echo "Latest Arch kernel:    ${new_kernelpkgver}"

comparison="$(vercmp "${new_kernelpkgver}" "${old_kernelpkgver}")"

if (( comparison <= 0 )); then
    echo "No newer Arch kernel package found."

    {
        echo "changed=false"
        echo "kernelpkgver=${old_kernelpkgver}"
    } >>"${OUTPUT_FILE}"

    exit 0
fi

old_kernver="$(kernel_base_version "${old_kernelpkgver}")"
new_kernver="$(kernel_base_version "${new_kernelpkgver}")"

if [[ "${new_kernver}" == "${old_kernver}" ]]; then
    new_pkgrel="$((old_pkgrel + 1))"
else
    new_pkgrel=1
fi

sed -i -E \
    "s/^_kernelpkgver=.*/_kernelpkgver=${new_kernelpkgver}/" \
    PKGBUILD

sed -i -E \
    "s/^pkgrel=.*/pkgrel=${new_pkgrel}/" \
    PKGBUILD

echo "Updated PKGBUILD:"
echo "  _kernelpkgver=${new_kernelpkgver}"
echo "  pkgver=${new_kernver}"
echo "  pkgrel=${new_pkgrel}"

{
    echo "changed=true"
    echo "kernelpkgver=${new_kernelpkgver}"
    echo "kernver=${new_kernver}"
    echo "pkgrel=${new_pkgrel}"
} >>"${OUTPUT_FILE}"