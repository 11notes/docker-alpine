#!/bin/ash
  if [ -z "${1}" ]; then
    set -- ash
  fi

  exec "$@"