#!/bin/bash

cd mouseless && stow --target="$(realpath ~)" *
