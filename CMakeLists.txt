cmake_minimum_required(VERSION 2.6.0 FATAL_ERROR)

set(PROJECT_NAME slim)
project(${PROJECT_NAME})

#Pretty colors
set(CMAKE_COLOR_MAKEFILE ON)
#Dont force verbose
set(CMAKE_VERBOSE_MAKEFILE ON)
#Include current dir
set(CMAKE_INCLUDE_CURRENT_DIR TRUE)

INCLUDE(CheckIncludeFile)
INCLUDE(CheckCCompilerFlag)
INCLUDE(CheckCXXCompilerFlag)
INCLUDE(CheckTypeSize)

# Version patch up to 9
# PAM now defaults if found and tested successfully.

set(SLIM_VERSION_MAJOR "1")
set(SLIM_VERSION_MINOR "3")
set(SLIM_VERSION_PATCH "9")
set(SLIM_VERSION "${SLIM_VERSION_MAJOR}.${SLIM_VERSION_MINOR}.${SLIM_VERSION_PATCH}")

set(CMAKE_INSTALL_PREFIX "/usr/local" CACHE PATH "Installation Directory")
set(PKGDATADIR "${CMAKE_INSTALL_PREFIX}/share/slim")
set(SYSCONFDIR "/etc")
set(LIBDIR "/lib")
set(MANDIR "${CMAKE_INSTALL_PREFIX}/share/man")

set(SLIM_DEFINITIONS)
if(${CMAKE_SYSTEM_NAME} MATCHES "NetBSD" OR
		${CMAKE_SYSTEM_NAME} MATCHES "OpenBSD" OR
		${CMAKE_SYSTEM_NAME} MATCHES "FreeBSD"
		)
	set(SLIM_DEFINITIONS ${SLIM_DEFINITIONS} "-DNEEDS_BASENAME")
else()
	set(SLIM_DEFINITIONS ${SLIM_DEFINITIONS} "-DHAVE_SHADOW")
endif()

set(SLIM_DEFINITIONS ${SLIM_DEFINITIONS} "-DPACKAGE=\"slim\"")
set(SLIM_DEFINITIONS ${SLIM_DEFINITIONS} "-DVERSION=\"${SLIM_VERSION}\"")
set(SLIM_DEFINITIONS ${SLIM_DEFINITIONS} "-DPKGDATADIR=\"${PKGDATADIR}\"")
set(SLIM_DEFINITIONS ${SLIM_DEFINITIONS} "-DSYSCONFDIR=\"${SYSCONFDIR}\"")

 
 # Flags
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -Wall -g -O2")
set(CMAKE_CPP_FLAGS "${CMAKE_CPP_FLAGS} -Wall -g -O2")
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wall -g -O2")

# source 
set(slim_srcs
  main.cpp
  app.cpp
  numlock.cpp
  switchuser.cpp
  png.c
  jpeg.c
  )

set(slimlock_srcs
  slimlock.cpp
  )

set(common_srcs
  cfg.cpp
  image.cpp
  log.cpp
  panel.cpp
  util.cpp
  )



if(USE_CONSOLEKIT)
  message("\t Adding Console Kit to slim")
  set(slim_srcs ${slim_srcs} Ck.cpp)
endif(USE_CONSOLEKIT)

add_executable(${PROJECT_NAME} ${slim_srcs})

#Set the custom CMake module directory where our include/lib finders are
set(CMAKE_MODULE_PATH "${CMAKE_SOURCE_DIR}/cmake/modules")

find_package(X11 REQUIRED)
find_package(Freetype REQUIRED)
find_package(JPEG REQUIRED)
find_package(PNG REQUIRED)
find_package(ZLIB REQUIRED)
find_package(PAM)

# Fontconfig
set(FONTCONFIG_DIR ${CMAKE_MODULE_PATH})
find_package(FONTCONFIG REQUIRED)
if(FONTCONFIG_FOUND)
	message("\tFontConfig Found")
	target_link_libraries(${PROJECT_NAME} ${FONTCONFIG_LIBRARY})
	include_directories(${FONTCONFIG_INCLUDE_DIR})
endif(FONTCONFIG_FOUND)

if(BUILD_SLIMLOCK)
  message("\tAdding slmlock and PAM to build")
  add_executable(slimlock ${slimlock_srcs})
  set(USE_PAM yes) 
endif(BUILD_SLIMLOCK)




if(PAM_FOUND)
  message("\tOK: PAM functions included")
  set(USE_PAM yes) 
else(PAM_FOUND)
  message("\tNOTE: PAM Not Found")
endif(PAM_FOUND)

if(USE_PAM)
  message("\tOK: Slimlock Possible")
  set(SLIM_DEFINITIONS ${SLIM_DEFINITIONS} "-DUSE_PAM")
  target_link_libraries(${PROJECT_NAME} ${PAM_LIBRARY})
  include_directories(${PAM_INCLUDE_DIR})
  set(common_srcs
    ${common_srcs}
    PAM.cpp
    )
  
  # slimlock conditional on PAM enabled   
  if(BUILD_SLIMLOCK)
    message("\tOK slimlock enabled")
    target_link_libraries(slimlock ${PAM_LIBRARY})
    else(BUILD_SLIMLOCK)
    message("\tNote slimlock NOT enabled")
  endif(BUILD_SLIMLOCK)
else(USE_PAM)
  message("\tWarning: PAM disabled")
endif(USE_PAM)    


# ConsoleKit
if(USE_CONSOLEKIT)
  find_package(CkConnector)
  message("\tNote ConsoleKit Enabled")
  if(CKCONNECTOR_FOUND)
    message("\tConsoleKit Found")
    # DBus check
    find_package(DBus REQUIRED)
    if(DBUS_FOUND)
      message("\tDBus Found")
      target_link_libraries(${PROJECT_NAME} ${DBUS_LIBRARIES})
      include_directories(${DBUS_ARCH_INCLUDE_DIR})
      include_directories(${DBUS_INCLUDE_DIR})
      set(SLIM_DEFINITIONS ${SLIM_DEFINITIONS} "-DUSE_CONSOLEKIT")
      target_link_libraries(${PROJECT_NAME} ${CKCONNECTOR_LIBRARIES})
      include_directories(${CKCONNECTOR_INCLUDE_DIR})
    else(DBUS_FOUND)
      message("\tDBus Not Found")
    endif(DBUS_FOUND)
  else(CKCONNECTOR_FOUND)
    message("\tOK ConsoleKit Not Found")
    message("\tOK ConsoleKit disabled")
  endif(CKCONNECTOR_FOUND)
else(USE_CONSOLEKIT)
  message("\tOK ConsoleKit disabled")
endif(USE_CONSOLEKIT)

# Build common library
set(BUILD_SHARED_LIBS ON CACHE BOOL "Build shared libraries")

if (BUILD_SHARED_LIBS)
	message(STATUS "Enable shared library building")
	add_library(libslim ${common_srcs})
else(BUILD_SHARED_LIBS)
	message(STATUS "Disable shared library building")
	add_library(libslim STATIC ${common_srcs})
endif(BUILD_SHARED_LIBS)

# system librarys
find_library(M_LIB m)
find_library(RT_LIB rt)
find_library(CRYPTO_LIB crypt)
find_package(Threads)

add_definitions(${SLIM_DEFINITIONS})

#Set up include dirs with all found packages
include_directories(
  ${X11_INCLUDE_DIR}
  ${X11_Xft_INCLUDE_PATH}
  ${X11_Xrender_INCLUDE_PATH}
  ${X11_Xrandr_INCLUDE_PATH}
  ${FREETYPE_INCLUDE_DIR_freetype2}
  ${X11_Xmu_INCLUDE_PATH}
  ${ZLIB_INCLUDE_DIR}
  ${JPEG_INCLUDE_DIR}
  ${PNG_INCLUDE_DIR}
  )

target_link_libraries(libslim
  ${JPEG_LIBRARIES}
  ${PNG_LIBRARIES}
  )

#Set up library with all found packages for slim
target_link_libraries(${PROJECT_NAME}
  ${M_LIB}
  ${RT_LIB}
  ${CRYPTO_LIB}
  ${X11_X11_LIB}
  ${X11_Xft_LIB}
  ${X11_Xrender_LIB}
  ${X11_Xrandr_LIB}
  ${X11_Xmu_LIB}
  ${FREETYPE_LIBRARY}
  ${JPEG_LIBRARIES}
  ${PNG_LIBRARIES}
  libslim
)

if(BUILD_SLIMLOCK)
  #Set up library with all found packages for slimlock
  target_link_libraries(slimlock
    ${M_LIB}
    ${RT_LIB}
    ${CRYPTO_LIB}
    ${X11_X11_LIB}
    ${X11_Xft_LIB}
    ${X11_Xrender_LIB}
    ${X11_Xrandr_LIB}
    ${X11_Xmu_LIB}
    ${X11_Xext_LIB}
    ${FREETYPE_LIBRARY}
    ${JPEG_LIBRARIES}
    ${PNG_LIBRARIES}
    ${CMAKE_THREAD_LIBS_INIT}
    libslim
    )
  message("\tOK slimlock application set for build")
else(BUILD_SLIMLOCK)
  message("\tOK slimlock not to be built")
endif(BUILD_SLIMLOCK)

## themes directory
subdirs(themes)

####### install
# slim
install(TARGETS slim RUNTIME DESTINATION bin)

if(BUILD_SLIMLOCK)
  install(TARGETS slimlock RUNTIME DESTINATION bin)
endif(BUILD_SLIMLOCK)

if (BUILD_SHARED_LIBS)
  set_target_properties(libslim PROPERTIES
    OUTPUT_NAME slim
    SOVERSION ${SLIM_VERSION})
  install(TARGETS libslim
    LIBRARY DESTINATION lib
    ARCHIVE DESTINATION lib
    )
endif (BUILD_SHARED_LIBS)

# man file
install(FILES slim.1 DESTINATION ${MANDIR}/man1/)
install(FILES slimlock.1 DESTINATION ${MANDIR}/man1/)
# configure
install(FILES slim.conf DESTINATION ${SYSCONFDIR})
# systemd service file: mostly harmless
# debian sysV style /etc/init.d/
if (${CMAKE_SYSTEM_NAME} MATCHES "Linux")
  install(FILES slim.service DESTINATION ${LIBDIR}/systemd/system)
  # deliberately keeping the init suffix so as
  # to avoid package installs.
  install(FILES slim.init DESTINATION ${SYSCONFDIR}/init.d/slim.init)
endif (${CMAKE_SYSTEM_NAME} MATCHES "Linux")

### CPack driven installer packages ###
###   this works with fakeroot      ###
### fakeroot cpack --config CPackConfig.cmake ###
include (InstallRequiredSystemLibraries)
set (CPACK_RESOURCE_FILE_LICENSE  
  "${CMAKE_CURRENT_SOURCE_DIR}/COPYING")
set (CPACK_PACKAGE_VERSION_MAJOR "${SLIM_VERSION_MAJOR}")
set (CPACK_PACKAGE_VERSION_MINOR "${SLIM_VERSION_MINOR}")
set (CPACK_PACKAGE_VERSION_PATCH "${SLIM_VERSION_PATCH}")
include (CPack)


