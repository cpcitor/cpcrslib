# Where this comes from

History was imported from https://storage.googleapis.com/google-code-archive-source/v2/code.google.com/cpcrslib/repo.svndump.gz following [» How to recover a Google Code SVN Project and migrate to Github dominikdorn.com](https://dominikdorn.com/2016/05/how-to-recover-a-google-code-svn-project-and-migrate-to-github/).

    zcat repo.svndump.gz | svnadmin load /tmp/testgc/
    svnserve --foreground -d &
	git svn --stdlayout clone svn://localhost/tmp/testgc/
    cd testgc

This history was pushed to https://github.com/cpcitor/cpcrslib-raw-history

Irrelevant subdirs were removed and their content moved up with this:

	git filter-branch -f --tree-filter 'ls -1b */* && mv */* . -v || echo "Nothing to do" ; rm -rvf *cpc*username* ' HEAD

Binary files were spotted with:

    find * -type f -not -iname "*.s" -not -iname "*.c" -not -iname "*.h" -not -iname "*.bat" -not -iname LICENSE -not -iname "*.txt" -not -iname "*.asm" | egrep -o '\.[^\.]*$' | sort | uniq

    .bin
    .exp
    .lib
    .lst
    .md
    .pu
    .rel

And history cleaned with:

	git filter-branch -f --tree-filter 'find * -type f -not -iname "*.s" -not -iname "*.c" -not -iname "*.h" -not -iname "*.bat" -not -iname LICENSE -not -iname "*.txt" -not -iname "*.asm" -print0 | xargs -0 rm -vf ' HEAD
