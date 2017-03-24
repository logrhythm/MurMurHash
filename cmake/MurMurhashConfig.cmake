#.rst:
# FindMurMurHash
# -------
#
# Find libMurMurhash, An implementation of the MurMurHash3 function in C++. 
# MurmurHash3 was originally written by Austin Appleby and has been released into the public domain.
#
# Result variables
# ^^^^^^^^^^^^^^^^
#
# This module will set the following variables in your project:
#
# ``MURMURHASH_INCLUDE_DIRS``
#   where to find MurmurHash.h
# ``MURMURHASH_LIBRARIES``
#   the libraries to link against to use libMurMurHash.
#   that includes libgMurMurHash library files.
# ``MURMURHASH_FOUND``
#   If false, do not try to use MurMurHash.

include(FindPackageHandleStandardArgs)

find_path(MURMURHASH_INCLUDE_DIR ${PROJECT_SRC}/MurMurhash.h)
find_library(MURMURHASH_LIBRARY
            NAMES libMurMurHash MurMurhash)

find_package_handle_standard_args(MURMURHASH  DEFAULT_MSG
            MURMURHASH_INCLUDE_DIR MURMURHASH_LIBRARY)

mark_as_advanced(MURMURHASH_INCLUDE_DIR MURMURHASH_LIBRARY)

set(MURMURHASH_LIBRARIES ${MURMURHASH_LIBRARY})
set(MURMURHASH_INCLUDE_DIRS ${MURMURHASH_INCLUDE_DIR})