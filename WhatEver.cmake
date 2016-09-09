include(CheckCCompilerFlag)
include(CheckCXXCompilerFlag)
include(CheckFunctionExists)
include(CheckIncludeFile)
include(CMakeDependentOption)
include(GenerateExportHeader)
include(GNUInstallDirs)

find_program(IWYU_PROGRAM NAMES include-what-you-use iwyu)
find_program(RAGEL_PROGRAM NAMES ragel)
mark_as_advanced(IWYU_PROGRAM)
mark_as_advanced(RAGEL_PROGRAM)

cmake_dependent_option(BUILD_PACKAGE_NSIS "Create NSIS Installer (.EXE)" OFF WIN32 OFF)
cmake_dependent_option(BUILD_PACKAGE_WIX "Create WiX Installer (.MSI)" OFF WIN32 OFF)
cmake_dependent_option(BUILD_PACKAGE_DEB "Create Debian Package (.DEB)" OFF UNIX OFF)
cmake_dependent_option(BUILD_PACKAGE_RPM "Create Red Hat Package (.RPM)" OFF UNIX OFF)
cmake_dependent_option(MSVC_USE_RUNTIME "Use MSVC DLL Runtime" ON MSVC OFF)
cmake_dependent_option(USE_TOOL_IWYU "Use IWYU Static Analysis" OFF IWYU_PROGRAM OFF)

set(CMAKE_C_VISIBILITY_PRESET hidden)
set(CMAKE_CXX_VISIBILITY_PRESET hidden)
set(CMAKE_VISIBILITY_INLINES_HIDDEN 1)
set(CPACK_PACKAGE_INSTALL_DIRECTORY "WhatEver")
set(CPACK_PACKAGE_VERSION "${PROJECT_VERSION}")
set(CPACK_PACKAGE_VERSION_MAJOR "${PROJECT_VERSION_MAJOR}")
set(CPACK_PACKAGE_VERSION_MINOR "${PROJECT_VERSION_MINOR}")
set(CPACK_PACKAGE_VERSION_PATCH "${PROJECT_VERSION_PATCH}")

if(NOT WHATEVER_SET_LANGUAGE)
	get_property(WHATEVER_SET_LANGUAGE GLOBAL PROPERTY ENABLED_LANGUAGES)
endif()

if(NOT CMAKE_C_STANDARD)
	if(WHATEVER_SET_STD_C)
		set(CMAKE_C_STANDARD ${WHATEVER_SET_STD_C})
	else()
		set(CMAKE_C_STANDARD 99)
	endif()
endif()

if(NOT CMAKE_CXX_STANDARD)
	if(WHATEVER_SET_STD_CXX)
		set(CMAKE_CXX_STANDARD ${WHATEVER_SET_STD_CXX})
	else()
		set(CMAKE_CXX_STANDARD 11)
	endif()
endif()

if(MSVC)
	add_definitions(-D_CRT_SECURE_NO_WARNINGS)

	foreach(WHATEVER_FLAG_VARIABLE
			CMAKE_C_FLAGS CMAKE_CXX_FLAGS
			CMAKE_C_FLAGS_DEBUG CMAKE_CXX_FLAGS_DEBUG
			CMAKE_C_FLAGS_RELEASE CMAKE_CXX_FLAGS_RELEASE
			CMAKE_C_FLAGS_MINSIZEREL CMAKE_CXX_FLAGS_MINSIZEREL
			CMAKE_C_FLAGS_RELWITHDEBINFO CMAKE_CXX_FLAGS_RELWITHDEBINFO)
		string(REGEX REPLACE "/W3" "/W4" ${WHATEVER_FLAG_VARIABLE} "${${WHATEVER_FLAG_VARIABLE}}")
		if(NOT MSVC_USE_RUNTIME)
			string(REGEX REPLACE "/MDd" "/MTd" ${WHATEVER_FLAG_VARIABLE} "${${WHATEVER_FLAG_VARIABLE}}")
			string(REGEX REPLACE "/MD" "/MT" ${WHATEVER_FLAG_VARIABLE} "${${WHATEVER_FLAG_VARIABLE}}")
		endif()
	endforeach()

	set(CMAKE_C_STANDARD_REQUIRED OFF)
	set(CMAKE_CXX_STANDARD_REQUIRED OFF)
else()
	list(APPEND WHATEVER_CFLAGS -Wall)

	set(CMAKE_C_STANDARD_REQUIRED ON)
	set(CMAKE_CXX_STANDARD_REQUIRED ON)
endif()

if(WIN32)
	set(CPACK_GENERATOR "ZIP")
else()
	set(CPACK_GENERATOR "TGZ")
endif()

if(BUILD_PACKAGE_DEB)
	list(APPEND CPACK_GENERATOR "DEB")
	set(CPACK_DEB_COMPONENT_INSTALL ON)
endif()
if(BUILD_PACKAGE_NSIS)
	list(APPEND CPACK_GENERATOR "NSIS")
endif()
if(BUILD_PACKAGE_RPM)
	list(APPEND CPACK_GENERATOR "RPM")
	set(CPACK_RPM_COMPONENT_INSTALL ON)
endif()
if(BUILD_PACKAGE_WIX)
	list(APPEND CPACK_GENERATOR "WIX")
endif()

set(CPACK_ALL_INSTALL_TYPES Minimal Standard Full)
set(CPACK_COMPONENT_GROUP_BIN_DISPLAY_NAME "End-User")
set(CPACK_COMPONENT_GROUP_DEV_DISPLAY_NAME "Developer")

set(CPACK_COMPONENT_DLL_DISPLAY_NAME "Shared Runtime")
set(CPACK_COMPONENT_DLL_GROUP bin)
set(CPACK_COMPONENT_DLL_INSTALL_TYPES Minimal Standard Full)

set(CPACK_COMPONENT_DOC_DISPLAY_NAME "Documentation")
set(CPACK_COMPONENT_DOC_INSTALL_TYPES Standard Full)

set(CPACK_COMPONENT_EXE_DEPENDS dll)
set(CPACK_COMPONENT_EXE_DISPLAY_NAME "Executable(s)")
set(CPACK_COMPONENT_EXE_GROUP bin)
set(CPACK_COMPONENT_EXE_INSTALL_TYPES Minimal Standard Full)

set(CPACK_COMPONENT_INC_DEPENDS lic)
set(CPACK_COMPONENT_INC_DISPLAY_NAME "Header Files")
set(CPACK_COMPONENT_INC_GROUP dev)
set(CPACK_COMPONENT_INC_INSTALL_TYPES Standard Full)

set(CPACK_COMPONENT_LIB_DEPENDS lic)
set(CPACK_COMPONENT_LIB_DISPLAY_NAME "Static Library")
set(CPACK_COMPONENT_LIB_GROUP dev)
set(CPACK_COMPONENT_LIB_INSTALL_TYPES Full)

set(CPACK_COMPONENT_LIC_DISPLAY_NAME "License Info")
set(CPACK_COMPONENT_LIC_GROUP dev)
set(CPACK_COMPONENT_LIC_INSTALL_TYPES Standard Full)

set(CPACK_COMPONENT_PRJ_DEPENDS lib dll)
set(CPACK_COMPONENT_PRJ_DISPLAY_NAME "CMake Export")
set(CPACK_COMPONENT_PRJ_GROUP dev)
set(CPACK_COMPONENT_PRJ_INSTALL_TYPES Full)

set(CPACK_COMPONENT_SYS_DISPLAY_NAME "System Files")
set(CPACK_COMPONENT_SYS_GROUP bin)
set(CPACK_COMPONENT_SYS_INSTALL_TYPES Minimal Standard Full)

set(CMAKE_INSTALL_SYSTEM_RUNTIME_COMPONENT sys)
include(InstallRequiredSystemLibraries)

install(EXPORT ${PROJECT_NAME}
	FILE "${PROJECT_NAME}Config.cmake"
	DESTINATION "${CMAKE_INSTALL_LIBDIR}/cmake"
	COMPONENT prj)

export(PACKAGE ${PROJECT_NAME})

function(we_check_function header tryit)
	string(REGEX REPLACE "[^a-zA-Z0-9_]" "_" WHATEVER_VARIABLE ${header})
	string(TOUPPER "HAVE_${WHATEVER_VARIABLE}" WHATEVER_VARIABLE)
	
	if(NOT DEFINED ${WHATEVER_VARIABLE})
		check_include_file("${header}" ${WHATEVER_VARIABLE})
	endif()
	
	if(${WHATEVER_VARIABLE})
		string(REGEX REPLACE "[^a-zA-Z0-9_]" "_" WHATEVER_VARIABLE ${tryit})
		string(TOUPPER "HAVE_${WHATEVER_VARIABLE}" WHATEVER_VARIABLE)
		set(WHATEVER_EXTRA_INCLUDE_FILES ${CMAKE_EXTRA_INCLUDE_FILES})
		set(CMAKE_EXTRA_INCLUDE_FILES ${header})
		check_function_exists(${tryit} ${WHATEVER_VARIABLE})
		set(CMAKE_EXTRA_INCLUDE_FILES ${WHATEVER_EXTRA_INCLUDE_FILES})
	endif()
endfunction()

function(we_check_include header)
	string(REGEX REPLACE "[^a-zA-Z0-9_]" "_" WHATEVER_VARIABLE ${header})
	string(TOUPPER "HAVE_${WHATEVER_VARIABLE}" WHATEVER_VARIABLE)
	check_include_file("${header}" ${WHATEVER_VARIABLE})
endfunction()

function(we_request_compile_flag cflag)
	string(REGEX REPLACE "[^a-zA-Z0-9_]" "_" WHATEVER_VARIABLE "HAS_CFLAG${cflag}")
	
	if("CXX" IN_LIST WHATEVER_SET_LANGUAGE)
		check_cxx_compiler_flag(${cflag} ${WHATEVER_VARIABLE})
	else()
		check_c_compiler_flag(${cflag} ${WHATEVER_VARIABLE})
	endif()

	if(${WHATEVER_VARIABLE})
		set(WHATEVER_CFLAGS ${WHATEVER_CFLAGS} ${cflag}
			PARENT_SCOPE)
	endif()
endfunction()

function(we_request_link_flag ldflag)
	set(WHATEVER_REQUIRED_FLAGS ${CMAKE_REQUIRED_FLAGS})
	string(REGEX REPLACE "[^a-zA-Z0-9_]" "_" WHATEVER_VARIABLE "HAS_LFLAG${ldflag}")
	set(CMAKE_REQUIRED_FLAGS "${ldflag}")
	
	if("CXX" IN_LIST WHATEVER_SET_LANGUAGE)
		check_cxx_compiler_flag("" ${WHATEVER_VARIABLE})
	else()
		check_c_compiler_flag("" ${WHATEVER_VARIABLE})
	endif()
	
	if(${WHATEVER_VARIABLE})
		set(WHATEVER_LDFLAGS "${WHATEVER_LDFLAGS} ${ldflag}"
			PARENT_SCOPE)
	endif()
	
	set(CMAKE_REQUIRED_FLAGS ${WHATEVER_REQUIRED_FLAGS})
endfunction()

function(we_generate_configs dir_in dir_out)
	file(MAKE_DIRECTORY ${dir_out})
	file(GLOB WHATEVER_CONFIG_FILES "${dir_in}/*.in")
	
	foreach(WHATEVER_CONFIG_FILE ${WHATEVER_CONFIG_FILES})
		get_filename_component(WHATEVER_OUTFILE "${WHATEVER_CONFIG_FILE}" NAME_WE)
		configure_file("${WHATEVER_CONFIG_FILE}" "${dir_out}/${WHATEVER_OUTFILE}.h")
		set(WHATEVER_GENERATED_INT ${WHATEVER_GENERATED_INT} "${dir_out}/${WHATEVER_OUTFILE}.h")
	endforeach()

	file(GLOB WHATEVER_CONFIG_FILES "${dir_in}/*.rl")
	foreach(WHATEVER_CONFIG_FILE ${WHATEVER_CONFIG_FILES})
		get_filename_component(WHATEVER_OUTFILE "${WHATEVER_CONFIG_FILE}" NAME_WE)
		add_custom_command(OUTPUT "${dir_out}/${WHATEVER_OUTFILE}.h"
			COMMAND ${RAGEL_PROGRAM}
			ARGS -e -F1 -o"${dir_out}/${WHATEVER_OUTFILE}.h" ${WHATEVER_CONFIG_FILE}
			DEPENDS ${WHATEVER_CONFIG_FILE}
			COMMENT "[RAGEL] Processing ${WHATEVER_CONFIG_FILE}"
			WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR})
		set(WHATEVER_GENERATED_INT ${WHATEVER_GENERATED_INT} "${dir_out}/${WHATEVER_OUTFILE}.h")
	endforeach()

	set(WHATEVER_GENERATED ${WHATEVER_GENERATED} ${WHATEVER_GENERATED_INT}
		PARENT_SCOPE)
endfunction()

function(we_build_library WHATEVER_TARGET libname)
	set_target_properties(${WHATEVER_TARGET} PROPERTIES
		C_VISIBILITY_PRESET hidden
		CXX_VISIBILITY_PRESET hidden
		POSITION_INDEPENDENT_CODE ON)

	if(WHATEVER_CFLAGS)
		target_compile_options(${WHATEVER_TARGET} PRIVATE ${WHATEVER_CFLAGS})
	endif()

	if(WHATEVER_LDFLAGS)
		set_target_properties(${WHATEVER_TARGET} PROPERTIES
			LINK_FLAGS ${WHATEVER_LDFLAGS})
	endif()

	if(USE_TOOL_IWYU)
		set_target_properties(${WHATEVER_TARGET} PROPERTIES
			C_INCLUDE_WHAT_YOU_USE ${IWYU_PROGRAM}
			CXX_INCLUDE_WHAT_YOU_USE ${IWYU_PROGRAM})
	endif()

	export(TARGETS ${WHATEVER_TARGET}
		APPEND FILE "${PROJECT_NAME}Config.cmake")

	generate_export_header(${WHATEVER_TARGET}
		BASE_NAME ${libname}
		EXPORT_FILE_NAME "include/${libname}_api.h")
endfunction()

function(we_build_library_static target libname soversion sources)
	set(WHATEVER_TARGET "lib${libname}_s")
	set(${target} ${WHATEVER_TARGET}
		PARENT_SCOPE)

	set(WHATEVER_TARGETS_STATIC ${WHATEVER_TARGETS_STATIC} ${WHATEVER_TARGET}
		PARENT_SCOPE)
	set(WHATEVER_TARGETS_LIBRARY ${WHATEVER_TARGETS_LIBRARY} ${WHATEVER_TARGET}
		PARENT_SCOPE)
	set(WHATEVER_TARGETS ${WHATEVER_TARGETS} ${WHATEVER_TARGET}
		PARENT_SCOPE)

	add_library(${WHATEVER_TARGET} STATIC ${sources})
	
	if(${soversion} LESS 0)
		if(MSVC)
			set_target_properties(${WHATEVER_TARGET} PROPERTIES
				OUTPUT_NAME "${libname}_s")
		else()
			set_target_properties(${WHATEVER_TARGET} PROPERTIES
				OUTPUT_NAME ${libname})
		endif()
	else()
		if(MSVC)
			set_target_properties(${WHATEVER_TARGET} PROPERTIES
				OUTPUT_NAME "${libname}-${soversion}_s")
		else()
			set_target_properties(${WHATEVER_TARGET} PROPERTIES
				OUTPUT_NAME "${libname}-${soversion}")
		endif()
	endif()

	string(TOUPPER "${libname}_STATIC_DEFINE" WHATEVER_DEFINE_STATIC)
	target_compile_definitions(${WHATEVER_TARGET} PUBLIC ${WHATEVER_DEFINE_STATIC})

	we_build_library(${WHATEVER_TARGET} ${libname})

	install(TARGETS ${WHATEVER_TARGET}
		EXPORT ${PROJECT_NAME}
		COMPONENT lib
		RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
		LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
		ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR})
endfunction()

function(we_build_library_shared target libname soversion sources)
	set(WHATEVER_TARGET "lib${libname}")
	set(${target} ${WHATEVER_TARGET}
		PARENT_SCOPE)

	set(WHATEVER_TARGETS_SHARED ${WHATEVER_TARGETS_SHARED} ${WHATEVER_TARGET}
		PARENT_SCOPE)
	set(WHATEVER_TARGETS_LIBRARY ${WHATEVER_TARGETS_LIBRARY} ${WHATEVER_TARGET}
		PARENT_SCOPE)
	set(WHATEVER_TARGETS ${WHATEVER_TARGETS} ${WHATEVER_TARGET}
		PARENT_SCOPE)

	add_library(${WHATEVER_TARGET} SHARED ${sources})

	if(${soversion} LESS 0)
		set_target_properties(${WHATEVER_TARGET} PROPERTIES
			OUTPUT_NAME ${libname})
	else()
		if(WIN32)
			set_target_properties(${WHATEVER_TARGET} PROPERTIES
				OUTPUT_NAME "${libname}-${soversion}")
		else()
			set_target_properties(${WHATEVER_TARGET} PROPERTIES
				OUTPUT_NAME ${libname}
				SOVERSION ${soversion})
		endif()
	endif()

	target_compile_definitions(${WHATEVER_TARGET} PRIVATE "${WHATEVER_TARGET}_EXPORTS")

	we_build_library(${WHATEVER_TARGET} ${libname})

	install(TARGETS ${WHATEVER_TARGET}
		EXPORT ${PROJECT_NAME}
		COMPONENT dll
		RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
		LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
		ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR})
endfunction()

function(we_include_private targets dir_in)
	foreach(target ${targets})
		target_include_directories(${target} PRIVATE
			"${CMAKE_CURRENT_SOURCE_DIR}/${dir_in}"
			"${CMAKE_CURRENT_BINARY_DIR}/${dir_in}")
	endforeach()
endfunction()

function(we_include_public targets dir_in dir_out)
	foreach(target ${targets})
		target_include_directories(${target} PUBLIC
			$<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/${dir_in}>
			$<BUILD_INTERFACE:${CMAKE_CURRENT_BINARY_DIR}/${dir_in}>
			$<INSTALL_INTERFACE:${CMAKE_INSTALL_INCLUDEDIR}/${dir_out}>)
	endforeach()

	install(DIRECTORY
		"${CMAKE_CURRENT_SOURCE_DIR}/${dir_in}/"
		"${CMAKE_CURRENT_BINARY_DIR}/${dir_in}/"
		DESTINATION "${CMAKE_INSTALL_INCLUDEDIR}/${dir_out}"
		COMPONENT inc
		OPTIONAL
		PATTERN "internal" EXCLUDE)
endfunction()

function(we_external_include targets type includes)
	list(REMOVE_DUPLICATES includes)
	foreach(target ${targets})
		target_include_directories(${target} ${type} ${includes})
	endforeach()
endfunction()

function(we_external_defines targets type defines)
	list(REMOVE_DUPLICATES defines)
	foreach(target ${targets})
		target_compile_definitions(${target} ${type} ${defines})
	endforeach()
endfunction()

function(we_external_library targets type libs)
	list(REMOVE_DUPLICATES libs)
	foreach(target ${targets})
		target_link_libraries(${target} ${type} ${libs})
	endforeach()
endfunction()

function(we_mark_license docs)
	list(APPEND docs LICENSE.md)
	list(REMOVE_DUPLICATES docs)
	list(GET docs 0 first)

	foreach(doc ${docs})
		install(FILES "${CMAKE_CURRENT_SOURCE_DIR}/${doc}"
			DESTINATION ${CMAKE_INSTALL_DOCDIR}
			COMPONENT lic)
	endforeach()

	set(CPACK_RESOURCE_FILE_LICENSE "${CMAKE_CURRENT_SOURCE_DIR}/${first}"
		PARENT_SCOPE)
endfunction()

function(we_mark_docs docs)
	list(APPEND docs README.md)
	list(REMOVE_DUPLICATES docs)
	list(GET docs 0 first)

	foreach(doc ${docs})
		install(FILES "${CMAKE_CURRENT_SOURCE_DIR}/${doc}"
			DESTINATION ${CMAKE_INSTALL_DOCDIR}
			COMPONENT doc)
	endforeach()

	set(CPACK_PACKAGE_DESCRIPTION_FILE "${CMAKE_CURRENT_SOURCE_DIR}/${first}"
		PARENT_SCOPE)
endfunction()

function(we_package package vendor contact description)
	set(CPACK_PACKAGE_CONTACT "${contact}")
	set(CPACK_PACKAGE_DESCRIPTION_SUMMARY "${description}")
	set(CPACK_PACKAGE_NAME "${package}")
	set(CPACK_PACKAGE_VENDOR "${vendor}")
	include(CPack)
endfunction()

