Description

    Preface

        $Id: README.txt,v 1.2 2001/08/09 17:26:07 jaalto Exp $

        This is README.txt which documents project pm-doc at
        http://pm-doc.sourceforge.net/

    Page index.html

        This is the main entry page of http://pm-doc.sourceforge.net/

    Directory tips/

        Directory dontains Procmail tips page in pure text
        format. The HTML is generated using Perl script *t2html.pl* which
        you must fetch from
        http://www.cpan.org/modules/by-authors/id/J/JA/JARIAALTO/

        File `bin/admin.bashrc'  contains bash functions to generate
        HTML documentation and to keep the sourceforge project pages
        up to date.

        To generate local HTML documentation, install Perl, put t2html.pl
        along your path and run:

            bash$ env SF_PM_DOC_HTML_TARGET=http://localhost/dir pmdochtmlall

        Copy the generated HTML files from directory html/*html to
        your Web server's http://localhost/dir. If you do not use web
        server, use edit following tag in each files to match your file:/
        or other URL

             <BASE HREF="" ..>

End
