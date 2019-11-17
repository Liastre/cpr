find_package(Threads)
set(TEST_SERVER_LIBRARY test_server)
add_library(${TEST_SERVER_LIBRARY}
    server.cpp)
target_link_libraries(${TEST_SERVER_LIBRARY}
    ${MONGOOSE_LIBRARIES}
    ${CMAKE_THREAD_LIBS_INIT})

macro(add_cpr_test _TEST_NAME)
    set(TEST_PROJECT_NAME test_${_TEST_NAME})
    add_executable(${TEST_PROJECT_NAME}
        ${_TEST_NAME}_tests.cpp)
    target_link_libraries(${TEST_PROJECT_NAME}
        ${TEST_SERVER_LIBRARY}
        ${GTEST_LIBRARIES}
        ${CPR_LIBRARIES})
    add_test(NAME cpr_${TEST_PROJECT_NAME} COMMAND ${TEST_PROJECT_NAME})
    # Group under the "tests" project folder in IDEs such as Visual Studio.
    set_property(TARGET ${TEST_PROJECT_NAME} PROPERTY FOLDER "tests")
    if(WIN32)
        add_custom_command(TARGET ${TEST_PROJECT_NAME} POST_BUILD
            COMMAND ${CMAKE_COMMAND} -E copy
            ${CPR_DEPENDENCIES} $<TARGET_FILE_DIR:${TEST_PROJECT_NAME}>)
    endif()
endmacro()

include_directories(
    ${CURL_INCLUDE_DIRS}
    ${CMAKE_CURRENT_SOURCE_DIR}
    ${CPR_INCLUDE_DIRS}
    ${GTEST_INCLUDE_DIRS}
    ${MONGOOSE_INCLUDE_DIRS})

add_cpr_test(get)
add_cpr_test(post)
add_cpr_test(session)
add_cpr_test(async)
add_cpr_test(proxy)
add_cpr_test(head)
add_cpr_test(delete)
add_cpr_test(put)
add_cpr_test(callback)
add_cpr_test(raw_body)
add_cpr_test(options)
add_cpr_test(patch)
add_cpr_test(error)
add_cpr_test(alternating)
add_cpr_test(util)
