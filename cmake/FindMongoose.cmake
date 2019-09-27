# Created by Vasily Lobaskin (Liastre).
# Redistribution and use of this file is allowed according to the terms of the MIT license.

#.rst:
# FindMongoose
# -------
#
# Search of the Mongoose library.
#
# The following variables will be defined:
#
#   MONGOOSE_FOUND         - true if library found
#   MONGOOSE_INCLUDE_DIRS  - path to library headers
#   MONGOOSE_LIBRARIES     - path to library itself

#===================================
#=========== VARIABLES =============
#===================================
# search paths
set(MONGOOSE_PATHS
    /usr
    /usr/local
    /usr/openwin
    /usr/openwin/share
    )
set(MONGOOSE_MAIN_HEADER Mongoose/mongoose.h)

#===================================
#========= SEARCH HEADERS ==========
#===================================
find_path(MONGOOSE_INCLUDE_DIR
    NAMES
        ${MONGOOSE_MAIN_HEADER}
    HINTS
        ${MONGOOSE_LOCATION}
        $ENV{MONGOOSE_LOCATION}
    PATHS
        "$ENV{PROGRAMFILES}/Mongoose"
        ${MONGOOSE_PATHS}
    PATH_SUFFIXES
        include
    DOC
        "Mongoose headers"
    )

#===================================
#======== SEARCH LIBRARIES =========
#===================================
find_library(MONGOOSE_LIBRARY
    NAMES
        mongoose
    HINTS
        ${MONGOOSE_LOCATION}
        $ENV{MONGOOSE_LOCATION}
    PATHS
        "$ENV{PROGRAMFILES}/Mongoose"
        ${MONGOOSE_PATHS}
    PATH_SUFFIXES
        lib
        lib64
        lib-msvc110
        lib-vc2012
        # OS X
        lib/${CMAKE_LIBRARY_ARCHITECTURE}
    DOC
        "Mongoose library"
    )

#===================================
#========= PARSE VERSION ===========
#===================================
# function to parse header
function(parseversion FILENAME VARNAME)
    set(PATTERN "^#define ${VARNAME}.*$")
    file(STRINGS "${MONGOOSE_INCLUDE_DIR}/${FILENAME}" TMP REGEX ${PATTERN})
    string(REGEX MATCHALL "[0-9\.]+" TMP "${TMP}")
    set(${VARNAME} ${TMP} PARENT_SCOPE)
endfunction()

# get version
if(MONGOOSE_INCLUDE_DIR)
    if(EXISTS "${MONGOOSE_INCLUDE_DIR}/${MONGOOSE_MAIN_HEADER}")
        parseversion(${MONGOOSE_MAIN_HEADER} MG_VERSION)
    endif()

    if(MG_VERSION)
        set(MONGOOSE_VERSION "${MG_VERSION}")
    endif()
endif()

#===================================
#========== SET UP OUTPUT ==========
#===================================
include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(MONGOOSE
    REQUIRED_VARS
        MONGOOSE_LIBRARY
        MONGOOSE_INCLUDE_DIR
    VERSION_VAR
        MONGOOSE_VERSION
    )
mark_as_advanced(
    MONGOOSE_INCLUDE_DIR
    MONGOOSE_LIBRARY
    )

if(MONGOOSE_FOUND)
    set(MONGOOSE_INCLUDE_DIRS ${MONGOOSE_INCLUDE_DIR})
    set(MONGOOSE_LIBRARIES ${MONGOOSE_LIBRARY})
endif()
