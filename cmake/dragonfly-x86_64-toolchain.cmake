if(DEFINED ENV{DRAGONFLY_SYSROOT} AND NOT "$ENV{DRAGONFLY_SYSROOT}" STREQUAL "")
  set(_dragonfly_sysroot "$ENV{DRAGONFLY_SYSROOT}")
else()
  set(_dragonfly_sysroot "/mnt/t2")
endif()

set(CMAKE_SYSTEM_NAME DragonFly CACHE STRING "" FORCE)
set(CMAKE_SYSROOT "${_dragonfly_sysroot}" CACHE PATH "" FORCE)
set(CMAKE_FIND_ROOT_PATH "${_dragonfly_sysroot}" CACHE PATH "" FORCE)

# Search host programs on Linux, but root all libraries, headers, and package
# discovery under the DragonFly sysroot.
set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER CACHE STRING "" FORCE)
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY CACHE STRING "" FORCE)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY CACHE STRING "" FORCE)
set(CMAKE_FIND_ROOT_PATH_MODE_PACKAGE ONLY CACHE STRING "" FORCE)

set(
  CMAKE_PREFIX_PATH
  "${_dragonfly_sysroot}/usr/local;${_dragonfly_sysroot}/usr;${_dragonfly_sysroot}/opt/gcc-8.3.0"
  CACHE STRING "" FORCE
)

unset(_dragonfly_sysroot)
