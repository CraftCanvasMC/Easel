#!/usr/bin/env bash

# requires curl & jq

# upstreamCommit <baseHash>
# param: bashHash - the commit hash to use for comparing commits (baseHash...HEAD)

(
set -e
PS1="$"

canvas=$(curl -H "Accept: application/vnd.github.v3+json" https://api.github.com/repos/CraftCanvasMC/Canvas/compare/$1...ver/1.20.4 | jq -r '.commits[] | "CraftCanvasMC/Canvas@\(.sha[:7]) \(.commit.message | split("\r\n")[0] | split("\n")[0])"')

updated=""
logsuffix=""
if [ ! -z "$canvas" ]; then
    logsuffix="$logsuffix\n\nCanvas Changes:\n$canvas"
    updated="Canvas"
fi
disclaimer="Upstream has released updates that appear to apply and compile correctly"

log="${UP_LOG_PREFIX}Updated Upstream ($updated)\n\n${disclaimer}${logsuffix}"

echo -e "$log" | git commit -F -

) || exit 1
