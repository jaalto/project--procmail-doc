# .......................................................................
#
#   $Id: admin.bashrc,v 1.4 2002/01/01 11:26:04 jaalto Exp $
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
#	SF_PM_DOC_USER=<sourceforge-login-name>
#	SF_PM_DOC_USER_NAME="FirstName LastName"
#	SF_PM_DOC_EMAIL=<email address>
#	SF_PM_DOC_LOC=~/cvs-projects/pm-doc/doc/tips
#	SF_PM_DOC_HTML_TARGET=http://pm-doc.sourceforge.net/
#
#	source ~/cvs-projects/pm-doc/bin/admin.bashrc
#
# .......................................................................


function sfpmdocinit ()
{
    local id="sfpmdocinit"

    local url=http://pm-doc.sourceforge.net/

    SF_PM_DOC_HTML_TARGET=${SF_PM_DOC_HTML_TARGET:-$url}
    SF_PM_DOC_KWD=${SF_PM_DOC_KWD:-"procmail, sendmail, programming, faq"}
    SF_PM_DOC_DESC=${SF_PM_DOC_DESC:-"Procmail documentation"}
    SF_PM_DOC_TITLE=${SF_PM_DOC_TITLE:-"$SF_PM_DOC_DESC"}
    SF_PM_DOC_LOC=${SF_PM_DOC_LOC:-""}

    if [ "$SF_PM_DOCS_USER" == "" ]; then
       echo "$id: Identity \$SF_PM_DOCS_USER unknown."
    fi


    if [ "$SF_PM_DOCS_USER_NAME" == "" ]; then
       echo "$id: Identity \$SF_PM_DOCS_USER_NAME unknown."
    fi

    if [ "$SF_PM_DOCS_EMAIL" == "" ]; then
       echo "$id: Address \$SF_PM_DOCS_EMAIL unknown."
    fi
}


function Date ()
{
    date "+%Y.%M%d"
}

function sfpmdocfilesize ()
{
    #	put line into array ( .. )

    local line
    line=($(ls -l "$1"))

    #	Read 4th element from array
    #	-rw-r--r--    1 root     None         4989 Aug  5 23:37 file

    echo ${line[4]}
}

function sfpmdocscp ()
{
    local id="sfpmdocscp"

    #	To upload file to project, call from shell prompt
    #
    #	    bash$ sfpmdocscp <FILE>

    local sfuser=$SF_PM_DOC_USER
    local sfproject=p/pm/pm-doc

    if [ "$SF_PM_DOC_USER" == "" ]; then
	echo "$id: identity \$SF_PM_LIB_USER unknown, can't scp files."
	return
    fi

    scp $* $sfuser@shell.sourceforge.net:/home/groups/$sfproject/htdocs/
}

function sfpmdochtml ()
{
    local id="sfpmdochtml"

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


    local input="$1"

    if [ "$input" == "" ]; then
        echo "$id: usage FILE [html-options]"
        return
    fi

    local opt

    if [ "$2" != "" ]; then
	opt="$2"
    fi

    echo "$id: Htmlizing $input $opt"

    perl -S t2html.pl                                               \
	  $opt                                                      \
	  --button-top "$SF_PM_DOC_HTML_TARGET"                     \
	  --title  "$SF_PM_DOC_TITLE"                               \
	  --author "$SF_PM_DOC_USER_NAME"                           \
	  --email  "$SF_PM_DOC_EMAIL"                               \
	  --meta-keywords "$SF_PM_DOC_KWD"                          \
	  --meta-description "$SF_PM_DOC_DESC"                      \
	  --name-uniq                                               \
	  --Out                                                     \
	  $input;

	if [ -d "../../html/"  ]; then
	    mv *.html ../../html/
	elif [ -d "../html/"  ]; then
	    mv *.html ../html/
	else
	    echo "Can't move generated HTML to ../../html/"
	fi

}

function sfpmdochtmlall ()
{
    #	loop all *.txt files and generate HTML
    #	If filesize if bigger than 15K, generate Framed HTML page.

    local id="sfpmdochtmlall"
    local size
    local opt

    if [ "$SF_PM_DOC_LOC" = "" ]; then
       echo "$id: Where is the project root? Define SF_PM_DOC_LOC"
       return;
    fi


    (
	cd $SF_PM_DOC_LOC || return;

	for file in *.txt;
	do
	     size=$(sfpmdocfilesize $file);
	     if [ $size -gt 15000 ]; then
	       opt=--html-frame
	     fi;

	     sfpmdochtml $file "$opt"

	 done;
    )

    echo "$id: done."
}


dummy=$(sfpmdocinit);			# Run initializer

export SF_PM_DOCS_HTML_TARGET
export SF_PM_DOCS_KWD
export SF_PM_DOCS_DESC
export SF_PM_DOCS_TITLE
export SF_PM_DOCS_ROOT



# End of file
