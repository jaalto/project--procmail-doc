# .......................................................................
#
#   $Id: admin.bashrc,v 1.1 2001/08/09 17:30:02 jaalto Exp $
#
#   These bash functions will help uploading files to Sourceforge project.
#   You need:
#
#	Unix        (Unix)  http://www.fsf.org/directory/bash.html
#		    (Win32) http://www.cygwin.com/
#	Perl 5.4+   (Unix)  http://www.perl.org
#		    (Win32) http://www.ativestate.com
#	t2html.pl   Perl program to convert text -> HTML
#		    http://www.cpan.org/modules/by-authors/id/J/JA/JARIAALTO/
#
#   This file is of interest only for the Admin or Co-Developer of
#   project:
#
#	http://sourceforge.net/projects/pm-doc
#	http://pm-doc.sourceforge.net/
#
#   Include this file to your $HOME/.bashrc and make the necessary
#   modifications
#
#	SF_PM_DOC_USER=<sf-user-name>
#	SF_PM_DOC_USER_NAME="FirstName LastName"
#	SF_PM_DOC_EMAIL=<email address>
#	SF_PM_DOC_LOC=~/cvs-projects/pm-doc/doc/tips
#	SF_PM_DOC_HTML_TARGET=http://pm-doc.sourceforge.net/
#
#	source ~/cvs-projects/pm-doc/bin/admin.bashrc
#
# .......................................................................

function sfpmdocfilesize ()
{
    ls -la $1 | awk '{print $5}'
}

function sfpmdocscp ()
{

    #	To upload file to project, call from shell prompt
    #
    #	    bash$ sfpmdocscp <FILE>

    sfuser=$SF_PM_DOC_USER
    sfproject=p/pm/pm-doc

    scp $* $sfuser@shell.sourceforge.net:/home/groups/$sfproject/htdocs/
}

function sfpmdochtml ()
{
    #	To generate HTML documentation located in /doc directory, call
    #
    #	    bash$ sfpmdochtml <FILE.txt>
    #
    #	To generate Frame based documentation
    #
    #	     bash$ sfpmdochtml <FILE.txt> --html-frame
    #
    #	For simple page, like README.txt
    #
    #	     bash$ sfpmdochtml <FILE.txt> --as-is


    cvs_location=~/sforge/devel/pm-doc/doc    # Where is the project

    if [ "$2" != "" ]; then
	opt="$2"
    fi

    echo "Option: $opt"

    SF_PM_DOC_HTML_TARGET=${SF_PM_DOC_HTML_TARGET:-http://pm-doc.sourceforge.net/}
    SF_PM_DOC_KWD=${SF_PM_DOC_KWD:-"procmail, sendmail, programming, faq"}
    SF_PM_DOC_DESC=${SF_PM_DOC_DESC:-"Procmail documentation"}
    SF_PM_DOC_TITLE=${SF_PM_DOC_TITLE:-"$SF_PM_DOC_DESC"}

    (                                                                   \
	cd $SF_PM_DOC_LOC ;                                             \
           perl -S t2html.pl                                            \
              $opt                                                      \
	      --base   $SF_PM_DOC_HTML_TARGET                           \
              --Butp   $SF_PM_DOC_HTML_TARGET                           \
              --title  "$SF_PM_DOC_TITLE"                               \
              --author "$SF_PM_DOC_USER_NAME"                           \
              --email  "$SF_PM_DOC_EMAIL"                               \
              --meta-keywords "SF_PM_DOC_KWD"                           \
              --meta-description "$SF_PM_DOC_DESC"                      \
              --name-uniq                                               \
              --Out                                                     \
              $1;                                                       \
	      mv *.html ../../html/                                     \
    )

}

function sfpmdochtmlall ()
{
    #	loop all *.txt files and generate HTML
    #	If filesize if bigger than 15K, generate Framed HTML page.

    (
	cd $SF_PM_DOC_LOC ;
	echo "Source dir:" $(pwd);
	for file in *.txt;
	do
	     size=$(sfpmdocfilesize $file);
	     if [ $size -gt 15000 ]; then
	       opt=--html-frame;
	     fi;
	     echo "Htmlizing $file $opt $size";
	     sfpmdochtml $file $opt;
	 done;
    )


}


# End of file
