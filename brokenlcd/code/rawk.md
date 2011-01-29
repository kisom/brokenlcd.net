rawk
----

in keeping with my involvement with [surfraw](http://surfraw.alioth.debian.org)
and drawn heavily from the 
[suckless webframework](http://nibble.develsec.org/projects/sw.html)

sw worked very well for the most part, except that it choked on one of my
sites. i decided to look into updating the code and doing some bugfixes.
there were a few features i wanted added, so i threw those in and ended
up just doing it my own way.

the default css, and header and footer templates are taken from sw, as is the 
menu style, so credit is due there.

some of the things i wanted out of rawk:
    * the generated html should be as clean as possible (something i liked 
    about sw)
    * where possible, the user should be able to quickly customise the site
        * header / footer templates
        * stylesheet
