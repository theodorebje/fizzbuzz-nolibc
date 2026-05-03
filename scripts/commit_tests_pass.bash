#!/usr/bin/env bash
watchexec --clear --shell bash -- 'make test && if ! git diff --quiet; then git commit -a; else echo "No uncommitted changes to commit."; fi'
