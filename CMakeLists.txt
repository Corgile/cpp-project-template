CMAKE_MINIMUM_REQUIRED(VERSION 3.20)
# Project details
PROJECT("Project" VERSION 0.1.0 LANGUAGES CXX)
SET(CMAKE_CXX_STANDARD 20)
SET(PROJECT_SHORT_NAME "PP")
# Set project options
INCLUDE(cmake/Utils.cmake)
INCLUDE(cmake/Settings.cmake)
INCLUDE(cmake/Analyzers.cmake)
IF(NOT CMAKE_BUILD_TYPE)
  SET(CMAKE_BUILD_TYPE "Debug")
ENDIF()

IF(UNIX)
  # this will allow to use same _DEBUG macro available
  # in both Linux as well as Windows - MSCV environment.
  # Easy to put Debug specific code.
  ADD_COMPILE_OPTIONS("$<$<CONFIG:DEBUG>:-D_DEBUG>")
ENDIF(UNIX)

# Setup alternative names
IF(${PROJECT_NAME}_USE_ALT_NAMES)
  STRING(TOLOWER ${PROJECT_NAME} PROJECT_NAME_LOWERCASE)
  STRING(TOUPPER ${PROJECT_NAME} PROJECT_NAME_UPPERCASE)
ELSE()
  SET(PROJECT_NAME_LOWERCASE ${PROJECT_NAME})
  SET(PROJECT_NAME_UPPERCASE ${PROJECT_NAME})
ENDIF()

# Prevent building in the source directory
IF(PROJECT_SOURCE_DIR STREQUAL PROJECT_BINARY_DIR)
  MESSAGE(FATAL_ERROR "不支持在代码路径下生成编译目标")
ENDIF()
# Create library, setup header and source files
# Find all headers and implementation files
INCLUDE(cmake/SourcesAndHeaders.cmake)

IF(${PROJECT_NAME}_BUILD_EXECUTABLE)
  ADD_EXECUTABLE(${PROJECT_NAME} ${exe_sources})
  IF(${PROJECT_NAME}_VERBOSE_OUTPUT)
    VERBOSE_MESSAGE("添加源文件:")
    FOREACH(source IN LISTS exe_sources)
      VERBOSE_MESSAGE("* ${source}")
    ENDFOREACH()
  ENDIF()
  IF(${PROJECT_NAME}_ENABLE_UNIT_TESTING)
    ADD_LIBRARY(${PROJECT_NAME}_LIB ${headers} ${sources})
    IF(${PROJECT_NAME}_VERBOSE_OUTPUT)
      VERBOSE_MESSAGE("添加头文件:")
      FOREACH(header IN LISTS headers)
        VERBOSE_MESSAGE("* ${header}")
      ENDFOREACH()
    ENDIF()
  ENDIF()
ELSEIF(${PROJECT_NAME}_BUILD_HEADERS_ONLY)
  ADD_LIBRARY(${PROJECT_NAME} INTERFACE)
  IF(${PROJECT_NAME}_VERBOSE_OUTPUT)
    VERBOSE_MESSAGE("添加头文件:")
    FOREACH(header IN LIST headers)
      VERBOSE_MESSAGE("* ${header}")
    ENDFOREACH()
  ENDIF()
ELSE()
  ADD_LIBRARY(
      ${PROJECT_NAME}
      ${headers}
      ${sources}
  )
  IF(${PROJECT_NAME}_VERBOSE_OUTPUT)
    VERBOSE_MESSAGE("添加源文件:")
    FOREACH(source IN LISTS sources)
      VERBOSE_MESSAGE("* ${source}")
    ENDFOREACH()
    VERBOSE_MESSAGE("添加头文件:")
    FOREACH(header IN LISTS headers)
      VERBOSE_MESSAGE("* ${header}")
    ENDFOREACH()
  ENDIF()
ENDIF()

SET_TARGET_PROPERTIES(
    ${PROJECT_NAME}
    PROPERTIES
    ARCHIVE_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/lib/${CMAKE_BUILD_TYPE}"
    LIBRARY_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/lib/${CMAKE_BUILD_TYPE}"
    RUNTIME_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/bin/${CMAKE_BUILD_TYPE}"
)
IF(${PROJECT_NAME}_BUILD_EXECUTABLE AND ${PROJECT_NAME}_ENABLE_UNIT_TESTING)
  SET_TARGET_PROPERTIES(
      ${PROJECT_NAME}_LIB
      PROPERTIES
      ARCHIVE_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/lib/${CMAKE_BUILD_TYPE}"
      LIBRARY_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/lib/${CMAKE_BUILD_TYPE}"
      OUTPUT_NAME ${PROJECT_NAME}
  )
ENDIF()

VERBOSE_MESSAGE("已添加全部头文件和源文件.")

#
# Set the project standard and warnings
#

IF(${PROJECT_NAME}_BUILD_HEADERS_ONLY)
  TARGET_COMPILE_FEATURES(${PROJECT_NAME} INTERFACE cxx_std_17)
ELSE()
  TARGET_COMPILE_FEATURES(${PROJECT_NAME} PUBLIC cxx_std_17)

  IF(${PROJECT_NAME}_BUILD_EXECUTABLE AND ${PROJECT_NAME}_ENABLE_UNIT_TESTING)
    TARGET_COMPILE_FEATURES(${PROJECT_NAME}_LIB PUBLIC cxx_std_17)
  ENDIF()
ENDIF()
INCLUDE(cmake/CompilerWarnings.cmake)
SET_PROJECT_WARNINGS(${PROJECT_NAME})

VERBOSE_MESSAGE("添加 C++${CMAKE_CXX_STANDARD} 的编译警告选项.")

#
# Enable Doxygen
#

INCLUDE(cmake/Doxygen.cmake)

SET(CMAKE_MSVC_RUNTIME_LIBRARY "MultiThreaded$<$<CONFIG:Debug>:Debug>DLL")

VERBOSE_MESSAGE("已添加了所需的全部依赖.")
# Set the build/user include directories
# Allow usage of header files in the `source` directory, but only for utilities
IF(${PROJECT_NAME}_BUILD_HEADERS_ONLY)
  TARGET_INCLUDE_DIRECTORIES(
      ${PROJECT_NAME}
      INTERFACE
      $<INSTALL_INTERFACE:include>
      $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>
  )
ELSE()
  TARGET_INCLUDE_DIRECTORIES(
      ${PROJECT_NAME}
      PUBLIC
      $<INSTALL_INTERFACE:include>
      $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>
      PRIVATE
      ${CMAKE_CURRENT_SOURCE_DIR}/source
  )
  IF(${PROJECT_NAME}_BUILD_EXECUTABLE AND ${PROJECT_NAME}_ENABLE_UNIT_TESTING)
    TARGET_INCLUDE_DIRECTORIES(
        ${PROJECT_NAME}_LIB
        PUBLIC
        $<INSTALL_INTERFACE:include>
        $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>
        PRIVATE
        ${CMAKE_CURRENT_SOURCE_DIR}/source
    )
  ENDIF()
ENDIF()

VERBOSE_MESSAGE("完成 include 目录配置.")
# Provide alias to library for
IF(${PROJECT_NAME}_BUILD_EXECUTABLE)
  ADD_EXECUTABLE(${PROJECT_NAME}::${PROJECT_NAME} ALIAS ${PROJECT_NAME})
ELSE()
  ADD_LIBRARY(${PROJECT_NAME}::${PROJECT_NAME} ALIAS ${PROJECT_NAME})
ENDIF()

VERBOSE_MESSAGE("项目名: ${PROJECT_NAME}::${PROJECT_NAME}.")
# Format the project using the `clang-format` target (i.e: cmake --build build --target clang-format)
ADD_CLANG_FORMAT_TARGET()
# Install library for easy downstream inclusion
INCLUDE(GNUInstallDirs)
INSTALL(
    TARGETS
    ${PROJECT_NAME}
    EXPORT
    ${PROJECT_NAME}Targets
    LIBRARY DESTINATION
    ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION
    ${CMAKE_INSTALL_BINDIR}
    ARCHIVE DESTINATION
    ${CMAKE_INSTALL_LIBDIR}
    INCLUDES DESTINATION
    include
    PUBLIC_HEADER DESTINATION
    include
)

INSTALL(
    EXPORT
    ${PROJECT_NAME}Targets
    FILE
    ${PROJECT_NAME}Targets.cmake
    NAMESPACE
    ${PROJECT_NAME}::
    DESTINATION
    ${CMAKE_INSTALL_LIBDIR}/cmake/${PROJECT_NAME}
)

#
# Add version header
#

CONFIGURE_FILE(
    ${CMAKE_CURRENT_LIST_DIR}/cmake/version.hpp.in
    include/${PROJECT_NAME_LOWERCASE}/version.hpp
    @ONLY
)

INSTALL(
    FILES
    ${CMAKE_CURRENT_BINARY_DIR}/include/${PROJECT_NAME_LOWERCASE}/version.hpp
    DESTINATION
    include/${PROJECT_NAME_LOWERCASE}
)

#
# Install the `include` directory
#

INSTALL(
    DIRECTORY
    include/${PROJECT_NAME_LOWERCASE}
    DESTINATION
    include
)

VERBOSE_MESSAGE("构建 install 目标完成. 安装命令:
       `cmake --build <build_directory> --target install --config <build_config>`.")

#
# Quick `ConfigVersion.cmake` creation
#

INCLUDE(CMakePackageConfigHelpers)
WRITE_BASIC_PACKAGE_VERSION_FILE(
    ${PROJECT_NAME}ConfigVersion.cmake
    VERSION
    ${PROJECT_VERSION}
    COMPATIBILITY
    SameMajorVersion
)

CONFIGURE_PACKAGE_CONFIG_FILE(
    ${CMAKE_CURRENT_LIST_DIR}/cmake/${PROJECT_NAME}Config.cmake.in
    ${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}Config.cmake
    INSTALL_DESTINATION
    ${CMAKE_INSTALL_LIBDIR}/cmake/${PROJECT_NAME}
)

INSTALL(
    FILES
    ${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}Config.cmake
    ${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}ConfigVersion.cmake
    DESTINATION
    ${CMAKE_INSTALL_LIBDIR}/cmake/${PROJECT_NAME}
)

#
# Generate export header if specified
#

IF(${PROJECT_NAME}_GENERATE_EXPORT_HEADER)
  INCLUDE(GenerateExportHeader)
  GENERATE_EXPORT_HEADER(${PROJECT_NAME})
  INSTALL(
      FILES
      ${PROJECT_BINARY_DIR}/${PROJECT_NAME_LOWERCASE}_export.h
      DESTINATION
      include
  )

  MESSAGE(STATUS "已生成头文件 `${PROJECT_NAME_LOWERCASE}_export.h` 并完成安装.")
ENDIF()

#
# Unit testing setup
#

IF(${PROJECT_NAME}_ENABLE_UNIT_TESTING)
  ENABLE_TESTING()
  VERBOSE_MESSAGE("构建单元测试.")
  ADD_SUBDIRECTORY(test)
ENDIF()
