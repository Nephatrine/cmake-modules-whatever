#
# CMake File Configuration
#

function(we_configure_files_cmake VAR)
	if(EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/config" AND
			IS_DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}/config")
		set(CONFIG_IN "${CMAKE_CURRENT_SOURCE_DIR}/config")
	else()
		set(CONFIG_IN ${CMAKE_CURRENT_SOURCE_DIR})
	endif()

	file(GLOB_RECURSE CONFIG_FILES RELATIVE ${CONFIG_IN} *.in)
	foreach(CONFIG_FILE ${CONFIG_FILES})
		get_filename_component(CONFIG_NAME ${CONFIG_FILE} NAME)
		get_filename_component(CONFIG_PATH ${CONFIG_FILE} DIRECTORY)
		string(REGEX REPLACE "\\.[^.]*$" "" CONFIG_NAME ${CONFIG_NAME})
		set(CONFIG_OUT "${CMAKE_CURRENT_BINARY_DIR}/${CONFIG_PATH}/${CONFIG_NAME}")

		file(MAKE_DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}/${CONFIG_PATH}")
		configure_file("${CONFIG_IN}/${CONFIG_FILE}" ${CONFIG_OUT})
		list(APPEND CONFIG_LIST ${CONFIG_OUT})
	endforeach()

	set(${VAR} ${${VAR}} ${CONFIG_LIST}
		PARENT_SCOPE)
endfunction()

