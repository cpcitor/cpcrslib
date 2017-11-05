# Where this comes from

History was imported from https://sourceforge.net/projects/cpcrslib/

with

    git clone https://git.code.sf.net/p/cpcrslib/code cpcrslib-code
    cd cpcrslib-code/

Generated or binary files were spotted with:

    find * -type f -not -iname "*.s" -not -iname "*.c" -not -iname "*.h" -not -iname "*.bat" -not -iname LICENSE -not -iname "*.txt" | egrep -o '\.[^\.]*$' | sort | uniq

    .asm
    .bin
    .dsk
    .exp
    .lib
    .pu
    .rel

And history cleaned with:

	git filter-branch -f --tree-filter 'find * -type f -not -iname "*.s" -not -iname "*.c" -not -iname "*.h" -not -iname "*.bat" -not -iname LICENSE -not -iname "*.txt" -print0 | xargs -0 rm -vf ' HEAD
