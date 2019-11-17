message(STATUS "")
message(STATUS "Building CPR library:")
message(STATUS "Using CURL_INCLUDE_DIRS: ${CURL_INCLUDE_DIRS}")
message(STATUS "Using CPR_LIBRARIES: ${CPR_LIBRARIES}")


set(CPR_SOURCES
    # Source files
    auth.cpp
    cookies.cpp
    cprtypes.cpp
    digest.cpp
    error.cpp
    multipart.cpp
    parameters.cpp
    payload.cpp
    proxies.cpp
    session.cpp
    timeout.cpp
    util.cpp
    ssl_options.cpp

    # Header files (useful in IDEs)
    "${CPR_INCLUDE_DIRS}/cpr/api.h"
    "${CPR_INCLUDE_DIRS}/cpr/auth.h"
    "${CPR_INCLUDE_DIRS}/cpr/body.h"
    "${CPR_INCLUDE_DIRS}/cpr/cookies.h"
    "${CPR_INCLUDE_DIRS}/cpr/cpr.h"
    "${CPR_INCLUDE_DIRS}/cpr/cprtypes.h"
    "${CPR_INCLUDE_DIRS}/cpr/curlholder.h"
    "${CPR_INCLUDE_DIRS}/cpr/defines.h"
    "${CPR_INCLUDE_DIRS}/cpr/digest.h"
    "${CPR_INCLUDE_DIRS}/cpr/error.h"
    "${CPR_INCLUDE_DIRS}/cpr/max_redirects.h"
    "${CPR_INCLUDE_DIRS}/cpr/multipart.h"
    "${CPR_INCLUDE_DIRS}/cpr/parameters.h"
    "${CPR_INCLUDE_DIRS}/cpr/payload.h"
    "${CPR_INCLUDE_DIRS}/cpr/proxies.h"
    "${CPR_INCLUDE_DIRS}/cpr/response.h"
    "${CPR_INCLUDE_DIRS}/cpr/session.h"
    "${CPR_INCLUDE_DIRS}/cpr/timeout.h"
    "${CPR_INCLUDE_DIRS}/cpr/util.h"
    "${CPR_INCLUDE_DIRS}/cpr/ssl_options.h")

if(${CPR_BUILD_STATIC})
    add_library(${CPR_LIBRARIES} STATIC ${CPR_SOURCES})
else()
    add_library(${CPR_LIBRARIES} SHARED ${CPR_SOURCES})
endif()

target_link_libraries(${CPR_LIBRARIES} ${CURL_LIBRARIES})

if(NOT (CMAKE_VERSION VERSION_LESS 3.0))
    target_include_directories(${CPR_LIBRARIES}
        PUBLIC
        ${CPR_INCLUDE_DIRS}
        ${CURL_INCLUDE_DIRS})
else()
    include_directories(
        ${CPR_INCLUDE_DIRS}
        ${CURL_INCLUDE_DIRS})
endif()
