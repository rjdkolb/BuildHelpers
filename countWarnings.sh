#!/bin/bash

#
# countWarnings.sh - displays a table of statistics of the pending number of warnings when building the OpenJDK.
#
# Copyright (c) 2012, Martijn Verburg <martijn.verburg@gmail.com>, Mani Sarkar <sadhak001@gmail.com>. All rights reserved.
# 
# DO NOT ALTER OR REMOVE COPYRIGHT NOTICES OR THIS FILE HEADER.
#
# This code is free software; you can redistribute it and/or modify it
# under the terms of the GNU General Public License version 2 only, as
# published by the Free Software Foundation.  Oracle designates this
# particular file as subject to the "Classpath" exception as provided
# by Oracle in the LICENSE file that accompanied this code.
#
# This code is distributed in the hope that it will be useful, but WITHOUT
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
# FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
# version 2 for more details (a copy is included in the LICENSE file that
# accompanied this code).
#
# You should have received a copy of the GNU General Public License version
# 2 along with this work; if not, write to the Free Software Foundation,
# Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301 USA.
#
gawk '
 
BEGIN {
  injavac = 0
  ncompiles = 0
  zerowarn = 0
  totalwarn = 0
  print "files warnings dir"
}
 
/^# Java sources/ { }
 
/^# Running javac:/ {
  injavac = 1
  ncompiles += 1
  nfiles = $4
  nwarn = 0
  dir = $7
  gsub(/^.*jdk\//, "", dir)
}
 
/^[0-9][0-9]* warning/ { # match "1 warning" and "n warnings"
  if (injavac) {
    nwarn = $1
  }
}
 
/^# javac finished/ {
  injavac = 0
  printf " %4d  %5d   %s\n", nfiles, nwarn, dir
  if (nwarn == 0) {
    zerowarn += 1
  }
  totalwarn += nwarn
}
 
END {
  print ""
  printf "ncompiles=%d zerowarn=%d totalwarn=%d\n",
    ncompiles, zerowarn, totalwarn
}
 
' "$@"
