Description

    Preface

        $Id: README.txt,v 1.5 2002/07/24 20:08:14 jaalto Exp $

        This is README.txt of Procmail Documentation Project at
        http://pm-doc.sourceforge.net/

        Welcome! Procmail needs more experienced users and people that help
        each others, so please join in if you have any procmail code
        examples, tips, documentation or compiling instructions to share.
        The ideal would be if you joined the sourceforge and could access
        the CVS server directly, but if you do not have time for that,
        please at least contact

            <jari.aalto@poboxes.com>

        And send any of your favourite procmail related material and it
        will be integrated to the project. Even your sample procmailrc
        would a great help for beginners.

        Let's help people to get to know the world of procmail.

    Page index.html

        This is the main entry page of http://pm-doc.sourceforge.net/

    Directory tips/

        Directory contains procmail tips page in pure text format. The HTML
        is generated using Perl text-to-html program *t2html.pl* which is
        hosted project at <http://perl-text2html.sourceforge.net>. If you
        would like to generate HTML from original text files, see
        admin.bashrc and how to call the perl program.

    Directory bin/

        File `bin/admin.bashrc' contains bash functions to generate
        HTML documentation and to keep this sourceforge project's pages
        up to date.

        To re-generate local HTML documentation, install Perl, put
        t2html.pl along your path and run:

            bash$ source bin/admin.bashrc
            bash$ pmdochtmlall

    Directory html/

        Ready compiled HTML files can be found from this directory.
        Copy them to your favourite location or include this path
        to your web server's configuration.

        For Apache add this to conf/httpd.conf:

            Alias /procmail/pm-doc/ "/the/path/to/pm-doc/html"

            <Directory "/the/path/to/pm-doc/html">
                Options Indexes MultiViews
                AllowOverride None
                Order allow,deny
                Allow from all
            </Directory>

        For Tomcat (Apache Java server) add:

            <Context path           = "/procmail/pm-doc/"
                     docBase        = "/the/path/to/pm-doc/html"
                     debug          = "0"
                     reloadable     = "false"
                     crossContext   = "false">
            </Context>

End
