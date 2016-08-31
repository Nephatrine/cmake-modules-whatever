#
# General Options
#

include(CheckCCompilerFlag)
include(CheckCXXCompilerFlag)

cmake_dependent_option(USE_MSVC_RUNTIME "Use MSVC DLL Runtime Library (/MD)" ON MSVC OFF)
get_property(WHATEVER_LANGUAGE GLOBAL PROPERTY ENABLED_LANGUAGES)

set(CMAKE_C_VISIBILITY_PRESET hidden)
set(CMAKE_CXX_VISIBILITY_PRESET hidden)
set(CMAKE_VISIBILITY_INLINES_HIDDEN 1)

if(NOT CMAKE_C_STANDARD)
	set(CMAKE_C_STANDARD "99")
endif()

if(NOT CMAKE_CXX_STANDARD)
	set(CMAKE_CXX_STANDARD "14")
endif()

#
# Compiler-Specific Logic
#

if(MSVC)
	add_definitions(-D_CRT_SECURE_NO_WARNINGS)

	if(NOT USE_MSVC_RUNTIME)
		foreach(flag CMAKE_C_FLAGS CMAKE_CXX_FLAGS
				CMAKE_C_FLAGS_DEBUG CMAKE_CXX_FLAGS_DEBUG
				CMAKE_C_FLAGS_RELEASE CMAKE_CXX_FLAGS_RELEASE
				CMAKE_C_FLAGS_MINSIZEREL CMAKE_CXX_FLAGS_MINSIZEREL
				CMAKE_C_FLAGS_RELWITHDEBINFO CMAKE_CXX_FLAGS_RELWITHDEBINFO)
			string(REGEX REPLACE "/MDd" "/MTd" ${flag} "${${flag}}")
			string(REGEX REPLACE "/MD" "/MT" ${flag} "${${flag}}")
		endforeach()
	endif()

	set(CMAKE_C_STANDARD_REQUIRED OFF)
	set(CMAKE_CXX_STANDARD_REQUIRED OFF)

	if(WHATEVER_REQ_VSFLAG)
		foreach(WHATEVER_REQUEST ${WHATEVER_REQ_VSFLAG})
			list(APPEND WHATEVER_CFLAGS "${WHATEVER_REQUEST}")
			list(APPEND WHATEVER_CXXFLAGS "${WHATEVER_REQUEST}")
		endforeach()
	endif()
else()
	set(CMAKE_C_STANDARD_REQUIRED ON)
	set(CMAKE_CXX_STANDARD_REQUIRED ON)

	if(WHATEVER_REQ_CFLAG)
		foreach(WHATEVER_REQUEST ${WHATEVER_REQ_CFLAG})
			string(REGEX REPLACE "[^a-zA-Z0-9_]" "_" WHATEVER_VAR ${WHATEVER_REQUEST})
			string(CONCAT WHATEVER_VAR "_CFLAG" ${WHATEVER_VAR})
			check_c_compiler_flag("${WHATEVER_REQUEST}" ${WHATEVER_VAR})
			if(${${WHATEVER_VAR}})
				list(APPEND WHATEVER_CFLAGS "${WHATEVER_REQUEST}")
				list(APPEND WHATEVER_CXXFLAGS "${WHATEVER_REQUEST}")
			endif()
		endforeach()
	endif()

	if(WHATEVER_REQ_CXXFLAG)
		foreach(WHATEVER_REQUEST ${WHATEVER_REQ_CXXFLAG})
			string(REGEX REPLACE "[^a-zA-Z0-9_]" "_" WHATEVER_VAR ${WHATEVER_REQUEST})
			string(CONCAT WHATEVER_VAR "_CXXFLAG" ${WHATEVER_VAR})
			check_cxx_compiler_flag("${WHATEVER_REQUEST}" ${WHATEVER_VAR})
			if(${${WHATEVER_VAR}})
				list(APPEND WHATEVER_CXXFLAGS "${WHATEVER_REQUEST}")
			endif()
		endforeach()
	endif()

	if(WHATEVER_REQ_LDFLAG)
		set(OLD_CMAKE_REQUIRED_FLAGS ${CMAKE_REQUIRED_FLAGS})
		foreach(WHATEVER_REQUEST ${WHATEVER_REQ_LDFLAG})
			string(REGEX REPLACE "[^a-zA-Z0-9_]" "_" WHATEVER_VAR ${WHATEVER_REQUEST})
			string(CONCAT WHATEVER_VAR "_LDFLAG" ${WHATEVER_VAR})
			set(CMAKE_REQUIRED_FLAGS "${WHATEVER_REQUEST}")
			if("CXX" IN_LIST WHATEVER_LANGUAGE)
				check_cxx_compiler_flag("" ${WHATEVER_VAR})
			else()
				check_c_compiler_flag("" ${WHATEVER_VAR})
			endif()
			if(${${WHATEVER_VAR}})
				set(WHATEVER_LDFLAGS "${WHATEVER_LDFLAGS} ${WHATEVER_REQUEST}")
			endif()
		endforeach()
		set(CMAKE_REQUIRED_FLAGS ${OLD_CMAKE_REQUIRED_FLAGS})
	endif()
endif()

