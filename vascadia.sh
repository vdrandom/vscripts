#!/usr/bin/env zsh
###
# https://github.com/microsoft/cascadia-code
# ss01 - handwritten italic
# ss02 - lua not equals ~=
# ss03 - serbian locale
# ss19 - slashed zero 0
# ss20 - graphical control characters
###
# opentype-feature-freezer is necessary, install with pipx or pip
# pip install --upgrade opentype-feature-freezer
###
# This script generates an archive with "baked in" stylistic sets
# for the best compatibility.
###

VERSION=2407.24

NAME=Vascadia
WDIR=$HOME/vascadia

SS=ss01,ss02,ss19,ss20

SRC=CascadiaCode-$VERSION.zip
URL=https://github.com/microsoft/cascadia-code/releases/download/v$VERSION/$SRC

function prep {
    typeset archive=$WDIR/$SRC
    mkdir -p $WDIR
    [[ -r $archive ]] || wget -P $WDIR $URL
    unzip $archive 'otf/**' -d $WDIR
}

function venv {
    typeset venv_dir=$WDIR/.venv
    python3 -m venv $venv_dir
    source $venv_dir/bin/activate
    pip install --upgrade pip opentype-feature-freezer
}

function convert {
    typeset dst_dir=$WDIR/$NAME
    mkdir -p $dst_dir
    while read -r src; do
        # an ugly hack to replace C with V, don't judge me
        dst=V${src##*/C}

        pyftfeatfreeze -f $SS -R Cascadia/$NAME $src $dst_dir/$dst
    done
}

function cleanup {
    typeset source=$WDIR/$NAME
    typeset archive=$source-$VERSION.zip
    zip -rv $archive $source
    rm -rv $source $WDIR/otf
}

function main {
    set -ex
    prep
    venv
    convert < <(find $WDIR/otf -type f -name '*.otf')
    cleanup
}

main $@
