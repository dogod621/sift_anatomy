cmake_minimum_required(VERSION 3.1)
cmake_policy(VERSION 3.1)

# Create Project
project(SIFT)
set_property(GLOBAL PROPERTY USE_FOLDERS ON)

# Setup sift_anatomy
file(GLOB sift_srcs	${CMAKE_CURRENT_SOURCE_DIR}/src/lib_*.cpp)
file(GLOB sift_hdrs	${CMAKE_CURRENT_SOURCE_DIR}/src/lib_*.h)

install(FILES ${sift_hdrs} DESTINATION include/)

OPTION(SIFT_BUILD_SHARED_LIBS "Build SIFT shared library." OFF)
OPTION(SIFT_BUILD_STATIC_LIBS "Build SIFT static library." ON)

set(SIFT_INCLUDE_DIR ${CMAKE_CURRENT_SOURCE_DIR}/src/ CACHE PATH "")

if(${SIFT_BUILD_SHARED_LIBS})
	add_library(sift SHARED ${sift_srcs} ${sift_hdrs})
	set_target_properties(sift PROPERTIES FOLDER "SIFT/LIB")
	install(TARGETS sift
			RUNTIME DESTINATION bin
			LIBRARY DESTINATION lib
			ARCHIVE DESTINATION lib)
endif()
if(${SIFT_BUILD_STATIC_LIBS})
	add_library(sift_static STATIC ${sift_srcs} ${sift_hdrs})
	set_target_properties(sift_static PROPERTIES FOLDER "SIFT/LIB")
	install(TARGETS sift_static
			RUNTIME DESTINATION bin
			LIBRARY DESTINATION lib
			ARCHIVE DESTINATION lib)
endif()
