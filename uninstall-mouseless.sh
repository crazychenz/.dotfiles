#!/bin/bash

cd mouseless && stow -D --target="$(realpath ~)" *
