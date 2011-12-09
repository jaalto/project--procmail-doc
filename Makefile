#!/usr/bin/make -f
#
#   Copyright information
#
#	Copyright (C) 2001-2010 Jari Aalto
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
#	GNU General Public License for more details at
#	<http://www.gnu.org/licenses/>.

ifneq (,)
This makefile requires GNU Make.
endif

OBJDIR = doc

all: doc

check:
	# Check broken URL links in documentation
	cd doc && \
	nice -n 10 perl -S t2html \
	--quiet \
	--link-check \
	--link-check-single \
	--link-cache \
	$$HOME/link-check.cache $$(pwd)/index.txt

clean:
	$(MAKE) -C $(OBJDIR) clean

distclean:
	$(MAKE) -C $(OBJDIR) distclean

realclean:
	$(MAKE) -C $(OBJDIR) realclean

doc:
	$(MAKE) -C $(OBJDIR) doc

link-check:
	$(MAKE) -C $(OBJDIR) link-check

install: all
	$(MAKE) -C $(OBJDIR) install

.PHONY: clean distclean realclean install doc

# End of file
