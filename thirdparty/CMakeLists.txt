include(ExternalProject)

# Macroses
macro(set_cache_variable VAR_NAME VAR_DESCRIPTION)
    set(${VAR_NAME} ${${VAR_NAME}} CACHE INTERNAL ${VAR_DESCRIPTION})
    message(STATUS "Set ${VAR_NAME} to ${${VAR_NAME}}.")
endmacro()

# Options
set(CPR_CURL_PREBUILT_PATH "" CACHE STRING "Path to prebuilt CURL library")

# Variables
set(THIRDPARTY_DIR ${CMAKE_BINARY_DIR}/thirdparty)
set(THIRDPARTY_INSTALL_DIR ${CMAKE_BINARY_DIR}/thirdparty/install)

# Curl configuration
if(NOT ${CPR_CURL_PREBUILT_PATH} STREQUAL "")
    set( PC_CURL_LIBRARY_DIRS
        ${CMAKE_CURRENT_LIST_DIR}/${CPR_CURL_PREBUILT_PATH}/lib
        ${CPR_CURL_PREBUILT_PATH}/lib)
    set( PC_CURL_INCLUDE_DIRS
        ${CMAKE_CURRENT_LIST_DIR}/${CPR_CURL_PREBUILT_PATH}/include
        ${CPR_CURL_PREBUILT_PATH}/include)
endif()

find_package(CURL)
if(CPR_CURL_SYSTEM_ONLY AND NOT CURL_FOUND)
    message(FATAL_ERROR "Curl was not found")
elseif(NOT CURL_FOUND)
    message(STATUS "Curl was not found. Downloading from github...")
    set(CURL_PROJECT_NAME curl)
    set(CURL_INSTALL_DIR ${THIRDPARTY_INSTALL_DIR}/curl)
    set(CURL_LIBRARY_NAME "libcurl.dll")

    set(CURL_FOUND TRUE)
    set(CURL_LIBRARIES ${CURL_PROJECT_NAME})
    set(CURL_INCLUDE_DIRS ${CURL_INSTALL_DIR}/include)

    ExternalProject_Add(
        CurlDownload
        PREFIX ${THIRDPARTY_DIR}/${CURL_PROJECT_NAME}
        GIT_REPOSITORY "https://github.com/curl/curl.git"
        GIT_TAG "curl-7_65_3"
        CMAKE_ARGS
            "-DBUILD_TESTING=OFF"
            "-DBUILD_CURL_EXE=OFF"
            "-DCMAKE_INSTALL_PREFIX=${CURL_INSTALL_DIR}"
    )

    add_library(${CURL_PROJECT_NAME} STATIC IMPORTED GLOBAL)
    set_target_properties(${CURL_PROJECT_NAME} PROPERTIES IMPORTED_LOCATION ${CURL_INSTALL_DIR}/bin/${CURL_LIBRARY_NAME})
    add_dependencies(${CURL_PROJECT_NAME} CurlDownload)
    set(CPR_DEPENDENCIES ${CPR_DEPENDENCIES} ${CURL_INSTALL_DIR}/bin/${CURL_LIBRARY_NAME})

    # Group under the "external" project folder in IDEs such as Visual Studio
    set_property(TARGET ${CURL_PROJECT_NAME} PROPERTY FOLDER "thirdparty")
endif()
set_cache_variable(CURL_FOUND "Curl was found")
set_cache_variable(CURL_LIBRARIES "Curl libraries")
set_cache_variable(CURL_INCLUDE_DIRS "Curl libraries to include")
set_cache_variable(CPR_DEPENDENCIES "Curl dependencies")


# Setup tests environment
if(CPR_BUILD_TESTS)
    # GTest configuration
    message(STATUS)
    find_package(GTest)
    if(NOT GTEST_FOUND)
        message(STATUS "Gtest was not found. Downloading from github...")
        set(GTEST_PROJECT_NAME gtest)
        set(GTEST_INSTALL_DIR ${THIRDPARTY_INSTALL_DIR}/gtest)
        set(GTEST_LIBRARY_NAME "libgtest.a")

        set(GTEST_FOUND TRUE)
        set(GTEST_LIBRARIES ${GTEST_PROJECT_NAME})
        set(GTEST_INCLUDE_DIRS ${GTEST_INSTALL_DIR}/include)

        ExternalProject_Add(
            GtestDownload
            PREFIX ${THIRDPARTY_DIR}/${GTEST_PROJECT_NAME}
            GIT_REPOSITORY "https://github.com/google/googletest.git"
            GIT_TAG "release-1.8.1"
            CMAKE_ARGS
                "-DCMAKE_INSTALL_PREFIX=${GTEST_INSTALL_DIR}"
                "-DBUILD_SHARED_LIBS=OFF"
        )

        add_library(${GTEST_PROJECT_NAME} STATIC IMPORTED GLOBAL)
        set_target_properties(${GTEST_PROJECT_NAME} PROPERTIES IMPORTED_LOCATION ${GTEST_INSTALL_DIR}/lib/${GTEST_LIBRARY_NAME})
        add_dependencies(${GTEST_PROJECT_NAME} GtestDownload)

        #if(MSVC)
            # By default, GTest compiles on Windows in CRT static linkage mode. We use this
            # variable to force it into using the CRT in dynamic linkage (DLL), just as CPR
            # does.
            #set(gtest_force_shared_crt ON CACHE BOOL "Force gtest to use the shared c runtime")
        #endif()

        # Group under the "external" project folder in IDEs such as Visual Studio
        set_property(TARGET ${GTEST_PROJECT_NAME} PROPERTY FOLDER "thirdparty")
    endif()
    set_cache_variable(GTEST_FOUND "Set if libgtest was found or built")
    set_cache_variable(GTEST_LIBRARIES "Location of libgtest")
    set_cache_variable(GTEST_INCLUDE_DIRS "Location of gtest include files")

    # Mongoose configuration
    message(STATUS)
    find_package(Mongoose)
    if(NOT MONGOOSE_FOUND)
        message(STATUS "Mongoose was not found. Downloading from github...")
        set(MONGOOSE_PROJECT_NAME mongoose)
        set(MONGOOSE_INSTALL_DIR ${THIRDPARTY_INSTALL_DIR}/mongoose)
        set(MONGOOSE_LIBRARY_NAME "libmongoose.a")

        set(MONGOOSE_FOUND TRUE)
        set(MONGOOSE_LIBRARIES ${MONGOOSE_PROJECT_NAME})
        set(MONGOOSE_INCLUDE_DIRS ${MONGOOSE_INSTALL_DIR}/include)

        ExternalProject_Add(
            MongooseDownload
            PREFIX ${THIRDPARTY_DIR}/${MONGOOSE_PROJECT_NAME}
            GIT_REPOSITORY "https://github.com/whoshuu/mongoose.git"
            GIT_TAG "5.6"
            CONFIGURE_COMMAND ""
            BUILD_COMMAND ""
            INSTALL_COMMAND ${CMAKE_COMMAND} -E copy <SOURCE_DIR>/mongoose.h ${MONGOOSE_INSTALL_DIR}/include/mongoose.h
        )
        ExternalProject_Get_Property(MongooseDownload SOURCE_DIR)

        # Build Mongoose
        project(${MONGOOSE_PROJECT_NAME} C)
        add_library(${MONGOOSE_PROJECT_NAME} STATIC ${SOURCE_DIR}/mongoose.c)
        add_dependencies(${MONGOOSE_PROJECT_NAME} MongooseDownload)
        target_compile_definitions(${MONGOOSE_PROJECT_NAME} PUBLIC MONGOOSE_ENABLE_THREADS)
        if(MINGW OR WIN32)
            target_link_libraries(${MONGOOSE_PROJECT_NAME} ws2_32)
        endif()
        # Group under the "external" project folder in IDEs such as Visual Studio
        set_property(TARGET ${MONGOOSE_PROJECT_NAME} PROPERTY FOLDER "thirdparty")
    endif()
    set_cache_variable(MONGOOSE_FOUND "Set if libmongoose was found or built")
    set_cache_variable(MONGOOSE_LIBRARIES "Location of libmongoose")
    set_cache_variable(MONGOOSE_INCLUDE_DIRS "Location of mongoose include files")
endif()
