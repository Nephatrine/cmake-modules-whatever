#
# Python Script Support
#

if(NOT DEFINED WHATEVER_PYTHON_VERSION)
	set(WHATEVER_PYTHON_VERSION 2.7)
endif()

find_package(PythonInterp ${WHATEVER_PYTHON_VERSION} REQUIRED)

#
# Internal Scripts
#

set(WE_TOOLS "${CMAKE_CURRENT_LIST_DIR}/Tools")

function(we_download_unicode_file VAR UNIDATA_VERSION)
	foreach(UNIDATA_IN ${ARGN})
		get_filename_component(UNIDATA_FILE ${UNIDATA_IN} NAME)
		get_filename_component(UNIDATA_NAME ${UNIDATA_FILE} NAME_WE)
		get_filename_component(UNIDATA_TYPE ${UNIDATA_FILE} EXT)
		set(UNIDATA_OUT "${UNIDATA_NAME}-${UNIDATA_VERSION}${UNIDATA_TYPE}")

		if(NOT "${UNIDATA_FILE}" STREQUAL "${UNIDATA_IN}")
			message(AUTHOR_WARNING "we_download_unicode_file: does not take a path - ignoring")
		endif()

		list(APPEND UNIDATA_GEN ${UNIDATA_OUT})

		add_custom_command(OUTPUT ${UNIDATA_OUT}
			COMMAND ${PYTHON_EXECUTABLE}
			ARGS "${WE_TOOLS}/we_download_unicode_file.py" ${UNIDATA_FILE} ${UNIDATA_VERSION}
			COMMENT "[PYTHON] Downloading ${UNIDATA_OUT}"
			WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR})
	endforeach()

	set(${VAR} ${${VAR}} ${UNIDATA_GEN}
		PARENT_SCOPE)
endfunction()

#
# External Scripts
#

function(we_run_script_python VAR SCRIPT_IN)
	get_filename_component(SCRIPT_FILE ${SCRIPT_IN} NAME)
	
	if("${SCRIPT_FILE}" STREQUAL "${SCRIPT_IN}")
		if(EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/config/scripts" AND
				IS_DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}/config/scripts")
			set(SCRIPT_PATH "${CMAKE_CURRENT_SOURCE_DIR}/config/scripts")
		elseif(EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/config" AND
				IS_DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}/config")
			set(SCRIPT_PATH "${CMAKE_CURRENT_SOURCE_DIR}/config")
		else()
			set(SCRIPT_PATH "${CMAKE_CURRENT_SOURCE_DIR}")
		endif()
		set(SCRIPT_FILE "${SCRIPT_PATH}/${SCRIPT_FILE}")
	endif()
	list(APPEND FUNC_ARGS ${SCRIPT_FILE})
	list(APPEND FUNC_DEPS ${SCRIPT_FILE})

	set(FUNC_MODE ARGOUT)
	foreach(FUNC_V ${ARGN})
		if("${FUNC_V}" STREQUAL "ARGS")
			set(FUNC_MODE ARGS)
		elseif("${FUNC_V}" STREQUAL "DEPENDS")
			set(FUNC_MODE DEPS)
		elseif("${FUNC_V}" STREQUAL "OUTPUT")
			set(FUNC_MODE OUTS)
		elseif("${FUNC_MODE}" STREQUAL "ARGOUT")
			get_filename_component(FUNC_DIR ${FUNC_V} DIRECTORY)
			list(APPEND FUNC_DIRS ${FUNC_DIR})
			list(APPEND FUNC_ARGS ${FUNC_V})
			list(APPEND FUNC_OUTS ${FUNC_V})
			set(FUNC_MODE ARGS)
		elseif("${FUNC_MODE}" STREQUAL "ARGS")
			list(APPEND FUNC_ARGS ${FUNC_V})
		elseif("${FUNC_MODE}" STREQUAL "DEPS")
			if(EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/${FUNC_V}")
				list(APPEND FUNC_DEPS "${CMAKE_CURRENT_SOURCE_DIR}/${FUNC_V}")
			else()
				list(APPEND FUNC_DEPS ${FUNC_V})
			endif()
		elseif("${FUNC_MODE}" STREQUAL "OUTS")
			get_filename_component(FUNC_DIR ${FUNC_V} DIRECTORY)
			list(APPEND FUNC_DIRS ${FUNC_DIR})
			list(APPEND FUNC_OUTS ${FUNC_V})
		endif()
	endforeach()

	set(${VAR} ${${VAR}} ${FUNC_OUTS}
		PARENT_SCOPE)

	if(DEFINED FUNC_DIRS)
		list(REMOVE_DUPLICATES FUNC_DIRS)
		foreach(FUNC_DIR ${FUNC_DIRS})
			file(MAKE_DIRECTORY ${FUNC_DIR})
		endforeach()
	endif()

	add_custom_command(OUTPUT ${FUNC_OUTS}
		COMMAND ${PYTHON_EXECUTABLE}
		ARGS ${FUNC_ARGS}
		DEPENDS ${FUNC_DEPS}
		COMMENT "[PYTHON] Running ${SCRIPT_FILE}"
		WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR})
endfunction()

