#!/bin/sh

git submodule init binaries 2>/dev/null
git submodule update --remote binaries
