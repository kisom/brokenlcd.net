about this site
===============

the source for this site consists of a tree of plaintext files (written in 
vim) containing a somewhat-simplified markdown; each file represents a 
separate page.

**[rawk](http://rawk.brokenlcd.net)** is used to walk through the source tree, 
building the header, footer, and menu bar. **rawk** uses 
**[smu](http://s01.de/~tox/index.cgi/proj_smu)** as its markdown handler.

generating the html, pushing the built version, and cleaning the directory 
are all handled by a posix makefile. it takes about 4 seconds to build an
8M source tree (mostly in non-markdown files with 21 markdown source files
taking up about 51K) on [ono-sendai](./machines/machines.html).

the source for the site is available on 
**[github](https://github.com/kisom/brokenlcd.net)**.

