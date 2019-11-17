macro(add_cpr_example _EXAMPLE_FILE_NAME)
    set(EXAMPLE_PROJECT_NAME example_${_EXAMPLE_FILE_NAME})
    add_executable(${EXAMPLE_PROJECT_NAME} ${_EXAMPLE_FILE_NAME}.cpp)
    target_link_libraries(${EXAMPLE_PROJECT_NAME}
        ${CPR_LIBRARIES})
    # Group under the "tests" project folder in IDEs such as Visual Studio.
    set_property(TARGET ${EXAMPLE_PROJECT_NAME} PROPERTY FOLDER "examples")
    if(WIN32)
        add_custom_command(TARGET ${EXAMPLE_PROJECT_NAME} POST_BUILD
            COMMAND ${CMAKE_COMMAND} -E copy
            ${CPR_DEPENDENCIES} $<TARGET_FILE_DIR:${EXAMPLE_PROJECT_NAME}>)
    endif()
endmacro()

# examples
add_cpr_example(request_headers)

