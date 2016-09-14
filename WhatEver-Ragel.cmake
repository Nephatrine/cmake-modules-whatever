#
# Ragel File Configuration
#

find_package(Ragel REQUIRED)

#
# CMake File Configuration
#

function(we_configure_files_ragel VAR)
	foreach(CONFIG_ARG ${ARGN})
		list(APPEND CONFIG_ARGS ${CONFIG_ARG})
	endforeach()

	if(EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/config" AND
			IS_DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}/config")
		set(CONFIG_IN "${CMAKE_CURRENT_SOURCE_DIR}/config")
	else()
		set(CONFIG_IN ${CMAKE_CURRENT_SOURCE_DIR})
	endif()

	file(GLOB_RECURSE CONFIG_FILES RELATIVE ${CONFIG_IN} *.rl)
	foreach(CONFIG_FILE ${CONFIG_FILES})
		get_filename_component(CONFIG_NAME ${CONFIG_FILE} NAME)
		get_filename_component(CONFIG_PATH ${CONFIG_FILE} DIRECTORY)
		string(REGEX REPLACE "\\.[^.]*$" "" CONFIG_NAME ${CONFIG_NAME})
		set(CONFIG_OUT "${CMAKE_CURRENT_BINARY_DIR}/${CONFIG_PATH}/${CONFIG_NAME}")

		file(MAKE_DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}/${CONFIG_PATH}")
		add_custom_command(OUTPUT ${CONFIG_OUT}
			COMMAND ${RAGEL_EXECUTABLE}
			ARGS ${CONFIG_ARGS} "-o${CONFIG_OUT}" "${CONFIG_IN}/${CONFIG_FILE}"
			DEPENDS "${CONFIG_IN}/${CONFIG_FILE}"
			COMMENT "[RAGEL] Processing ${CONFIG_FILE}"
			WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR})
		
		list(APPEND CONFIG_LIST ${CONFIG_OUT})
	endforeach()

	set(${VAR} ${${VAR}} ${CONFIG_LIST}
		PARENT_SCOPE)
endfunction()

