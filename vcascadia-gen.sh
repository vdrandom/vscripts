#!/usr/bin/env zsh
###
# https://github.com/microsoft/cascadia-code
# ss01 - handwritten italic
# ss02 - lua not equal ~= - does not work :(
# ss03 - serbian locale
# ss19 - slashed zero 0
# ss20 - graphical control characters
###

arch=vcascadia.tgz

nsrc=CascadiaCodePL.ttf
ndst=normal.ttf
nss=ss19,ss20

isrc=CascadiaCodePLItalic.ttf
idst=italic.ttf
iss=ss01,$nss

rm -fv $arch $ndst $idst

pip install --upgrade opentype-feature-freezer
pyftfeatfreeze -f $nss -R 'Cascadia Code PL/vcascadia' $nsrc $ndst
pyftfeatfreeze -f $iss -R 'Cascadia Code PL/vcascadia' $isrc $idst

tar -acvf $arch $ndst $idst
