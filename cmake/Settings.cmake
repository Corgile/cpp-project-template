INCLUDE(${PROJECT_SOURCE_DIR}/cmake/internal/Utils.cmake)
INCLUDE(${PROJECT_SOURCE_DIR}/cmake/internal/AnsiColor.cmake)
#
# Project settings
#
OPTION(${PROJECT_NAME}_VERBOSE_OUTPUT "启用详细输出." ON)
OPTION(${PROJECT_NAME}_ENABLE_LOG "启用日志." OFF)
IF(${PROJECT_NAME}_ENABLE_LOG)
  OPTION(${PROJECT_NAME}_CONSOLE_LOG "启用Console日志." OFF)
ENDIF()

OPTION(${PROJECT_NAME}_BUILD_EXECUTABLE "编译目标为 executable." OFF)
OPTION(${PROJECT_NAME}_BUILD_HEADERS_ONLY "编译目标为 header-only 库." OFF)

OPTION(${PROJECT_NAME}_USE_ALT_NAMES "允许为项目起别名." ON)
# Compiler options
OPTION(${PROJECT_NAME}_WARNINGS_AS_ERRORS "将编译器警告视为报错." ON)
# Unit testing
# Currently supporting: GoogleTest, Catch2.
OPTION(${PROJECT_NAME}_ENABLE_UNIT_TESTING "启用单元测试." ON)
OPTION(${PROJECT_NAME}_USE_GTEST "使用 GoogleTest 创建单元测试." ON)
OPTION(${PROJECT_NAME}_USE_GOOGLE_MOCK "使用 GoogleMock." OFF)
OPTION(${PROJECT_NAME}_USE_CATCH2 "使用 Catch2 创建单元测试." OFF)
# Static analyzers
# Currently supporting: Clang-Tidy, Cppcheck.
OPTION(${PROJECT_NAME}_ENABLE_CLANG_TIDY "启用 Clang-Tidy 检查." ON)
OPTION(${PROJECT_NAME}_ENABLE_CLANG_FORMAT "启用 Clang-Format." ON)
# Code coverage
OPTION(${PROJECT_NAME}_ENABLE_CODE_COVERAGE "启用 GCC 代码覆盖检测." OFF)
# Doxygen
OPTION(${PROJECT_NAME}_ENABLE_DOXYGEN "启用 Doxygen." OFF)
OPTION(${PROJECT_NAME}_GENERATE_EXPORT_HEADER "生成 export." OFF)
# LTO
OPTION(${PROJECT_NAME}_ENABLE_LTO "开启 Link Time Optimization (LTO)." ON)
# Ccache
OPTION(${PROJECT_NAME}_ENABLE_CCACHE "启用 Ccache 加速编译." ON)
# Generate compile_commands.json for clang based tools
SET(CMAKE_EXPORT_COMPILE_COMMANDS ON)
# Export all symbols when building a shared library
IF(BUILD_SHARED_LIBS)
  SET(CMAKE_WINDOWS_EXPORT_ALL_SYMBOLS OFF)
  SET(CMAKE_CXX_VISIBILITY_PRESET hidden)
  SET(CMAKE_VISIBILITY_INLINES_HIDDEN 1)
ENDIF()

INCLUDE(${PROJECT_SOURCE_DIR}/cmake/internal/LogLevel.cmake)
INCLUDE(${PROJECT_SOURCE_DIR}/cmake/internal/Sanitizer.cmake)
INCLUDE(${PROJECT_SOURCE_DIR}/cmake/internal/ClangTidy.cmake)
INCLUDE(${PROJECT_SOURCE_DIR}/cmake/internal/ClangFormat.cmake)
INCLUDE(${PROJECT_SOURCE_DIR}/cmake/internal/Doxygen.cmake)
INCLUDE(${PROJECT_SOURCE_DIR}/cmake/internal/Ccache.cmake)
INCLUDE(${PROJECT_SOURCE_DIR}/cmake/internal/LTO.cmake)