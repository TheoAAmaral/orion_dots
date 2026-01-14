#!/bin/bash
if [[ -z "$NVIM" ]]; then
  fastfetch
  echo -e "\n"
  tput sgr0
fi
