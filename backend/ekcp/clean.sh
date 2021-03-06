#!/bin/bash

. ./defaults.sh
. ../../include/common.sh

if [ -d "$BUILD_DIR" ]; then
      . .envrc
      curl -X DELETE http://"$EKCP_HOST"/"${CLUSTER_NAME}"
      popd || exit
      rm -rf "$BUILD_DIR"
fi

if [ -n "$FORCE_DELETE" ]; then
      curl -X DELETE http://"$EKCP_HOST"/"${CLUSTER_NAME}"
fi
