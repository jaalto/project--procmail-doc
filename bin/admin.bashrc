# .......................................................................
#
#   $Id: admin.bashrc,v 1.8 2002/07/11 16:14:56 jaalto Exp $
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
#	SF_PM_DOC_ROOT=~/cvs-projects/pm-doc/doc/tips
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
    SF_PM_DOC_ROOT=${SF_PM_DOC_ROOT:-""}

    if [ "$SF_PM_DOCS_USER" = "" ]; then
       echo "$id: Identity SF_PM_DOCS_USER unknown."
    fi

    if [ "$SF_PM_DOCS_USER_NAME" = "" ]; then
       echo "$id: Identity SF_PM_DOCS_USER_NAME unknown."
    fi

    if [ "$SF_PM_DOCS_EMAIL" = "" ]; then
       echo "$id: Address SF_PM_DOCS_EMAIL unknown."
    fi
}


function sfpmdocdate ()
{
    date "+%Y.%m%d"
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

    if [ "$SF_PM_DOC_USER" = "" ]; then
	echo "$id: identity SF_PM_DOC_USER unknown, can't scp files."
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

    if [ "$input" = "" ]; then
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
	  --title  "$SF_PM_DOC_TITLE"                               \
	  --author "$SF_PM_DOC_USER_NAME"                           \
	  --email  "$SF_PM_DOC_EMAIL"                               \
	  --meta-keywords "$SF_PM_DOC_KWD"                          \
	  --meta-description "$SF_PM_DOC_DESC"                      \
	  --Out                                                     \
	  $input

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
    echo "$id: started."

    if [ "$SF_PM_DOC_ROOT" = "" ]; then
       echo "$id: Where is the project root? Define SF_PM_DOC_ROOT"
       return
    fi


    (
	cd $SF_PM_DOC_ROOT/doc/tips || return

	for file in *.txt;
	do
	    local size=$(sfpmdocfilesize $file)
	    local opt
	    if [ $size -gt 15000 ]; then
	       opt=--html-frame
	    fi

	    sfpmdochtml $file "$opt"

	 done
    )

    echo "$id: done."
}


function sfpmdoc_release ()
{
    local id="sfpmdoc_release"

    local dir=/tmp

    if [ ! -d $dir ]; then
	echo "$id: Can't make release. No directory [$dir]"
	return
    fi

    if [ ! -d "$SF_PM_DOC_ROOT" ]; then
	echo "$id: No SF_PM_DOC_ROOT [$SF_PM_DOC_ROOT]"
	return
    fi


    local opt=-9
    local cmd=gzip
    local ext1=.tar
    local ext2=.gz

    local base=procmail-doc
    local ver=$(sfpmdocdate)
    local tar="$base-$ver$ext1"
    local file="$base-$ver$ext1$ext2"

    if [ -f $dir/$file ]; then
	echo "$id: Removing old archive $dir/$file"
	rm $dir/$file
    fi


    (

	local todir=$base-$ver
        local tmp=$dir/$todir

	if [ -d $tmp ]; then
	    echo "$id: Removing old archive directory $tmp"
	    rm -rf $tmp
	fi

	cp -r $SF_PM_DOC_ROOT $dir/$todir

	cd $dir

	find $todir -type f                     \
	    \( -name "*[#~]*"                   \
	       -o -name ".*[#~]"                \
	       -o -name ".#*"                   \
	       -o -name "*elc"                  \
	       -o -name "*tar"                  \
	       -o -name "*gz"                   \
	       -o -name "*bz2"                  \
	       -o -name .cvsignore              \
	    \) -prune                           \
	    -o -type d \( -name CVS \) -prune   \
	    -o -type f -print                   \
	    | xargs tar cvf $dir/$tar

	echo "$id: Running $cmd $opt $dir/$tar"

	$cmd $opt $dir/$tar

	echo "$id: Made release $dir/$file"
	ls -l $dir/$file
    )
}

dummy=$(sfpmdocinit)			# Run initializer

export SF_PM_DOCS_HTML_TARGET
export SF_PM_DOCS_KWD
export SF_PM_DOCS_DESC
export SF_PM_DOCS_TITLE
export SF_PM_DOCS_ROOT



# End of file
