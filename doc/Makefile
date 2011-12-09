#!/usr/bin/make -f
#
#   Copyright information
#
#	Copyright (C) 2001-2012 Jari Aalto
#
#   License
#
#	This program is free software; you can redistribute it and/or modify
#	it under the terms of the GNU General Public License as published by
#	the Free Software Foundation; either version 2 of the License, or
#	(at your option) any later version.
#
#	This program is distributed in the hope that it will be useful,
#	but WITHOUT ANY WARRANTY; without even the implied warranty of
#	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
#	GNU General Public License for more details.
#
#	You should have received a copy of the GNU General Public License
#	along with this program. If not, see <http://www.gnu.org/licenses/>.

ifneq (,)
This makefile requires GNU Make.
endif

PACKAGE		= procmail-doc
DESTDIR		=
prefix		= /usr
exec_prefix	= $(prefix)
man_prefix	= $(prefix)/share
mandir		= $(man_prefix)/man
bindir		= $(exec_prefix)/bin
sharedir	= $(prefix)/share

BINDIR		= $(DESTDIR)$(bindir)
DOCDIR		= $(DESTDIR)$(sharedir)/doc/$(PACKAGE)
SHAREDIR	= $(DESTDIR)$(prefix)/share/$(PACKAGE)

# 1 = regular, 5 = conf, 6 = games, 8 = daemons
MANDIR		= $(DESTDIR)$(mandir)
MANDIR1		= $(MANDIR)/man1

INSTALL		= /usr/bin/install
INSTALL_DATA	= $(INSTALL) -m 644
INSTALL_DIR	= $(INSTALL) -m 755 -d

SRCS		= index.txt
OBJS		= index.html

INSTALL_OBJS_DOC_HTML	= $(OBJS) *.css
INSTALL_OBJS_DOC_TXT	= $(SRCS)
INSTALL_OBJS_DOC	= ../README ChangeLog

all: doc

# Delete files fromt he build process.
clean:
	# clean
	-rm -f *[#~] *.\#* $(OBJS) *.log
	rm -rf tmp/

#  Delete files that are created by configuring or building the program.
#  Leave only the files that were in the distribution.
distclean: clean

#  Delete almost everything that can be reconstructed.
realclean: clean

#  This replaces 'realclean' in new GNU standards.
maintainer-clean: realclean

doc: index.html

link-check:
	perl -S t2html \
	--quiet \
	--link-check-single \
	--link-cache ~/tmp/link.cache \
	$$(pwd)/index.txt \
	| tee link.log

index.html: index.txt
	perl -S t2html \
	--auto-detect \
	--disclaimer-file disclaimer.txt \
	--out $<

install-doc: doc
	# install-doc
	$(INSTALL_DIR) $(DOCDIR)/html $(DOCDIR)/txt

	tar -cf - $(INSTALL_OBJS_DOC) | tar -C $(DOCDIR) -xf -
	tar -cf - $(INSTALL_OBJS_DOC_HTML) | tar -C $(DOCDIR)/html -xf -
	tar -cf - $(INSTALL_OBJS_DOC_TXT) | tar -C $(DOCDIR)/txt -xf -

install-test:
	-rm -rf tmp
	make DESTDIR=tmp install

install: install-doc

.PHONY: clean distclean realclean install install-doc

# End of file
