Description

    Preface

        $Id: README.txt,v 1.4 2002/01/02 00:08:50 jaalto Exp $

        This is README.txt which documents project pm-doc at
        http://pm-doc.sourceforge.net/

        Welcome to the procmail documentation project. Procmail needs more
        experienced users and people that help each others, so please
        join in if you have any procmail code examples, tips, documentation
        or compiling instructions to share. The ideal would be if you
        joined the sourceforge and could access the CVS server directly,
        but if you do not have time for that, please at least contact

            <jari.aalto@poboxes.com>

        And send any of your favourite procmail related material and it
        will be integrated to the project. Even your sample procmailrc
        would a great help for beginners.

        Let's help people to get to know the world of procmail.

    Page index.html

        This is the main entry page of http://pm-doc.sourceforge.net/

    Directory tips/

        Directory contains Procmail tips page in pure text
        format. The HTML is generated using Perl script *t2html.pl* which
        you must fetch from
        http://www.cpan.org/modules/by-authors/id/J/JA/JARIAALTO/

    bin/ directory

        File `bin/admin.bashrc'  contains bash functions to generate
        HTML documentation and to keep the sourceforge project pages
        up to date.

        To generate local HTML documentation, install Perl, put t2html.pl
        along your path and run:

            bash$ source bin/admin.bashrc
            bash$ pmdochtmlall

        Copy the generated HTML files from directory html/*html to your Web
        server's location.

End
