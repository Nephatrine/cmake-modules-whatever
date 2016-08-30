#
# Install Generated Binaries
#

include(GNUInstallDirs)

if(WHATEVER_TARGETS)
	foreach(WHATEVER_TARGET ${WHATEVER_TARGETS})
		install(TARGETS "${WHATEVER_TARGET}" EXPORT ${PROJECT_NAME}
			RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
			LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
			ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR})
	endforeach()
endif()

#
# Install Debug Information
#

if(MSVC)
	install(DIRECTORY "${PROJECT_BINARY_DIR}/Debug/"
		DESTINATION ${CMAKE_INSTALL_BINDIR}
		PATTERN "*.pdb"
		PATTERN "static" EXCLUDE
		CONFIGURATIONS Debug
		OPTIONAL)
	install(DIRECTORY "${PROJECT_BINARY_DIR}/RelWithDebInfo/"
		DESTINATION ${CMAKE_INSTALL_BINDIR}
		PATTERN "*.pdb"
		PATTERN "static" EXCLUDE
		CONFIGURATIONS RelWithDebInfo
		OPTIONAL)
	install(DIRECTORY "${PROJECT_BINARY_DIR}/Debug/"
		DESTINATION ${CMAKE_INSTALL_LIBDIR}
		PATTERN "*_static.pdb"
		CONFIGURATIONS Debug
		OPTIONAL)
	install(DIRECTORY "${PROJECT_BINARY_DIR}/RelWithDebInfo/"
		DESTINATION ${CMAKE_INSTALL_LIBDIR}
		PATTERN "*_static.pdb"
		CONFIGURATIONS RelWithDebInfo
		OPTIONAL)
endif()

#
# Install Documentation
#

install(FILES "${PROJECT_SOURCE_DIR}/LICENSE.md" "${PROJECT_SOURCE_DIR}/README.md"
	DESTINATION ${CMAKE_INSTALL_DOCDIR})

if(WHATEVER_DOCUMENTATION)
	foreach(WHATEVER_DOCUMENT ${WHATEVER_DOCUMENTATION})
		install(FILES "${PROJECT_SOURCE_DIR}/${WHATEVER_DOCUMENT}"
			DESTINATION ${CMAKE_INSTALL_DOCDIR})
	endforeach()
endif()

#
# Install Libraries
#

install(DIRECTORY "${PROJECT_SOURCE_DIR}/include/"
	DESTINATION "${CMAKE_INSTALL_INCLUDEDIR}/${PROJECT_NAME}"
	OPTIONAL
	PATTERN "internal" EXCLUDE)

install(DIRECTORY "${PROJECT_BINARY_DIR}/include/"
	DESTINATION "${CMAKE_INSTALL_INCLUDEDIR}/${PROJECT_NAME}"
	OPTIONAL
	PATTERN "internal" EXCLUDE)

#
# Install Export
#

install(EXPORT ${PROJECT_NAME}
	DESTINATION "${CMAKE_INSTALL_LIBDIR}/WhatEver")

