#!/usr/bin/env zsh
###
# This script generates an archive with "baked in" stylistic sets
# for the best compatibility.
###
# opentype-feature-freezer is necessary, installed automatically via uv
###
# https://github.com/microsoft/cascadia-code
# calt,ss01 - handwritten italic
# ss02 - lua not equals ~=
# ss03 - serbian locale
# ss19 - slashed zero 0
# ss20 - graphical control characters
###
# VARIANT is a find wildcard, so use it wisely
# e.g. VARIANT='*MonoPL*.otf', VARIANT='*Code*.ttf', VARIANT='*'
# Font variants:
# Code - ligatures, no extras
# Mono - no ligatures, no extras
#   PL - powerline symbols (CodePL, MonoPL)
#   NF - powerline + NerdFont symbols (CodeNF, MonoNF)
# .ttf - truetype fonts
# .otf - opentype fonts
###

VERSION=2407.24

NAME=Vascadia
WDIR=$HOME/vascadia

SS=calt,ss01,ss19,ss20
VARIANT='*Mono*.otf'

SRC=CascadiaCode-$VERSION.zip
URL=https://github.com/microsoft/cascadia-code/releases/download/v$VERSION/$SRC

function prep {
    [[ -r $SRC ]] || wget $URL
    unzip $SRC 'otf/**'
    uv venv
    uv pip install opentype-feature-freezer
}

function convert {
    mkdir -p $NAME
    while read -r src; do
        dst=$NAME/$(basename ${src//Cascadia/$NAME})

        uv run pyftfeatfreeze -f $SS -R Cascadia/$NAME $src $dst
    done
}

function cleanup {
    typeset source=$NAME
    typeset archive=$source-$VERSION.zip
    zip -rv $archive $source
    rm -rv $source otf
}

function main {
    set -ex
    mkdir -p $WDIR
    cd $WDIR
    prep
    convert < <(find otf -type f -name $VARIANT)
    cleanup
}

main $@
