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
# pipx install --upgrade opentype-feature-freezer
###

title='Cascadia Mono NF'
orig=CascadiaMonoNF
name=VascadiaMod
arch=$name.tgz
ss=ss01,ss19,ss20

for font in $orig*.otf; do
    src=$font
    dst=${font/$orig/$name}

    pyftfeatfreeze -f $ss -R "$title/$name" $src $dst
done

eval tar -acvf $arch $name*
