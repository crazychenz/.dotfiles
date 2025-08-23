#!/bin/bash

# Goal: Download latest of a thing and attempt to get the version.
# Goal: Only acquire statically linked things.

DOWNLOADS=bundle/downloads/
BINDIR=bundle/.local/bin/
CFGDIR=bundle/.config/
mkdir -p ${DOWNLOADS}
mkdir -p ${BINDIR}
mkdir -p ${CFGDIR}

github_latest_release_version() {
  REPO=$1
  basename $(curl -s -o /dev/null -w "%{redirect_url}" "https://github.com/${REPO}/releases/latest")
}

github_download_version() {
  REPO=$1
  VERSION=$2
  FNAME=$3

  SOURCE_PREFIX=$(echo "${REPO}" | sed 's#/#%2F#g')

  if [ -e "${DOWNLOADS}${FNAME}" ]; then
    echo "${FNAME} already downloaded. Skipping"
  else
    VERSIONED_URL=https://github.com/${REPO}/releases/download/${VERSION}
    echo "Downloading: ${VERSIONED_URL}/${FNAME}"
    curl -o ${DOWNLOADS}${FNAME} -L "${VERSIONED_URL}/${FNAME}"
  fi

  SOURCE_FNAME=$(echo "${REPO}" | sed 's#/#%2F#g')-${VERSION}.tar.gz
  if [ -e "${DOWNLOADS}${SOURCE_FNAME}" ]; then
    echo "${SOURCE_FNAME} already downloaded. Skipping"
  else
    curl -o ${DOWNLOADS}${SOURCE_FNAME} -L "https://github.com/${REPO}/archive/refs/tags/${VERSION}.tar.gz"
  fi
}

dependency_check() {
  if [ -z "$(which $2)" ]; then
    echo "You need $2 in \$PATH to use $1."
    exit 1
  fi
}

dependency_check $0 curl
dependency_check $0 tar
dependency_check $0 gzip
dependency_check $0 unzip
dependency_check $0 git


### dive - docker layer viewer
REPO=wagoodman/dive
VERSION=$(github_latest_release_version ${REPO})
FNAME=dive_$(echo -n ${VERSION} | cut -c2-)_linux_amd64.tar.gz
github_download_version ${REPO} ${VERSION} ${FNAME}
echo Installing: ${FNAME}
tar -xf ${DOWNLOADS}${FNAME} -C ${BINDIR} dive


### edit - retro microsoft dos editor
REPO=microsoft/edit
VERSION=$(github_latest_release_version ${REPO})
FNAME=edit-$(echo -n ${VERSION} | cut -c2-)-x86_64-linux-gnu.tar.zst
github_download_version ${REPO} ${VERSION} ${FNAME}
echo Installing: ${FNAME}
tar -xf ${DOWNLOADS}${FNAME} -C ${BINDIR} edit


### fq - file query (like jq for binaries)
REPO=wader/fq
VERSION=$(github_latest_release_version ${REPO})
FNAME=fq_$(echo -n ${VERSION} | cut -c2-)_linux_amd64.tar.gz
github_download_version ${REPO} ${VERSION} ${FNAME}
echo Installing: ${FNAME}
tar -xf ${DOWNLOADS}${FNAME} -C ${BINDIR} fq


### gping - ping visualizer
REPO=orf/gping
VERSION=$(github_latest_release_version ${REPO})
FNAME=gping-Linux-musl-x86_64.tar.gz
github_download_version ${REPO} ${VERSION} ${FNAME}
echo Installing: ${FNAME}
tar -xf ${DOWNLOADS}${FNAME} -C ${BINDIR} gping


### isd - systemctl tui
REPO=kainctl/isd
VERSION=$(github_latest_release_version ${REPO})
FNAME=isd.x86_64-linux.AppImage
github_download_version ${REPO} ${VERSION} ${FNAME}
echo Installing: ${FNAME}
cp ${DOWNLOADS}${FNAME} ${BINDIR}isd && chmod +x ${BINDIR}isd


### lazyjournal - journalctl tui
REPO=Lifailon/lazyjournal
VERSION=$(github_latest_release_version ${REPO})
FNAME=lazyjournal-$(echo -n ${VERSION} | cut -c2-)-linux-amd64
github_download_version ${REPO} ${VERSION} ${FNAME}
echo Installing: ${FNAME}
cp ${DOWNLOADS}${FNAME} ${BINDIR}lazyjournal && chmod +x ${BINDIR}lazyjournal


### mdtt - markdown table editor
REPO=szktkfm/mdtt
VERSION=$(github_latest_release_version ${REPO})
FNAME=mdtt_Linux_x86_64.tar.gz
github_download_version ${REPO} ${VERSION} ${FNAME}
echo Installing: ${FNAME}
tar -xf ${DOWNLOADS}${FNAME} -C ${BINDIR} mdtt


### miller - cli data processer
REPO=johnkerl/miller
VERSION=$(github_latest_release_version ${REPO})
FNAME=miller-$(echo -n ${VERSION} | cut -c2-)-linux-amd64.tar.gz
github_download_version ${REPO} ${VERSION} ${FNAME}
echo Installing: ${FNAME}
tar -xf ${DOWNLOADS}${FNAME} -C ${BINDIR} --strip-components=1 miller-$(echo -n ${VERSION} | cut -c2-)-linux-amd64/mlr


### monolith - website downloader
REPO=Y2Z/monolith
VERSION=$(github_latest_release_version ${REPO})
FNAME=monolith-gnu-linux-x86_64
github_download_version ${REPO} ${VERSION} ${FNAME}
echo Installing: ${FNAME}
cp ${DOWNLOADS}${FNAME} ${BINDIR}monolith && chmod +x ${BINDIR}monolith


### otree - JSON/YAML/TOML tree viewer
REPO=fioncat/otree
VERSION=$(github_latest_release_version ${REPO})
FNAME=otree-x86_64-unknown-linux-musl.tar.gz
github_download_version ${REPO} ${VERSION} ${FNAME}
echo Installing: ${FNAME}
tar -xf ${DOWNLOADS}${FNAME} -C ${BINDIR} otree


### rainfrog - postgre management
REPO=achristmascarl/rainfrog
VERSION=$(github_latest_release_version ${REPO})
FNAME=rainfrog-${VERSION}-x86_64-unknown-linux-musl.tar.gz
github_download_version ${REPO} ${VERSION} ${FNAME}
echo Installing: ${FNAME}
tar -xf ${DOWNLOADS}${FNAME} -C ${BINDIR} rainfrog


### rclone - rsync for cloud protocols
REPO=rclone/rclone
VERSION=$(github_latest_release_version ${REPO})
FNAME=rclone-${VERSION}-linux-amd64.zip
github_download_version ${REPO} ${VERSION} ${FNAME}
echo Installing: ${FNAME}
unzip -o -j ${DOWNLOADS}${FNAME} rclone-${VERSION}-linux-amd64/rclone -d ${BINDIR}


### so - StackOverflow TUI
REPO=samtay/so
VERSION=$(github_latest_release_version ${REPO})
FNAME=so-x86_64-unknown-linux-musl.tar.gz
github_download_version ${REPO} ${VERSION} ${FNAME}
echo Installing: ${FNAME}
tar -xf ${DOWNLOADS}${FNAME} -C ${BINDIR} so


### termshark - wireshark tui
REPO=gcla/termshark
VERSION=$(github_latest_release_version ${REPO})
FNAME=termshark_$(echo -n ${VERSION} | cut -c2-)_linux_x64.tar.gz
github_download_version ${REPO} ${VERSION} ${FNAME}
echo Installing: ${FNAME}
tar -xf ${DOWNLOADS}${FNAME} -C ${BINDIR} --strip-components=1 termshark_$(echo -n ${VERSION} | cut -c2-)_linux_x64/termshark


### wtf - tui dashboard
REPO=wtfutil/wtf
VERSION=$(github_latest_release_version ${REPO})
FNAME=wtf_$(echo -n ${VERSION} | cut -c2-)_linux_amd64.tar.gz
github_download_version ${REPO} ${VERSION} ${FNAME}
echo Installing: ${FNAME}
tar -xf ${DOWNLOADS}${FNAME} -C ${BINDIR} --strip-components=1 wtf_$(echo -n ${VERSION} | cut -c2-)_linux_amd64/wtfutil


### tui-journal
REPO=AmmarAbouZor/tui-journal
VERSION=$(github_latest_release_version ${REPO})
FNAME=tjournal-linux-gnu.tar.gz
github_download_version ${REPO} ${VERSION} ${FNAME}
echo Installing: ${FNAME}
tar -xf ${DOWNLOADS}${FNAME} -C ${BINDIR} ./tjournal


### typioca - type speed tool
REPO=bloznelis/typioca
VERSION=$(github_latest_release_version ${REPO})
FNAME=typioca-linux-amd64
github_download_version ${REPO} ${VERSION} ${FNAME}
echo Installing: ${FNAME}
cp ${DOWNLOADS}${FNAME} ${BINDIR}typioca && chmod +x ${BINDIR}typioca
























