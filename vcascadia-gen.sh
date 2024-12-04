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

name=VascadiaMod
arch=$name.tgz
ss=ss01,ss19,ss20

for font in CascadiaMonoNF*.otf; do
    src=$font
    dst=${font/CascadiaMonoNF/$name}

    pyftfeatfreeze -f $ss -R "Cascadia Code PL/$name" $src $dst
done

eval tar -acvf $arch $name*
