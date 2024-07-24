IF(${PROJECT_NAME}_ENABLE_CLANG_TIDY)
  INCLUDE(${PROJECT_SOURCE_DIR}/cmake/internal/VARS.cmake)
  SET(CLANG_TIDY_SEARCH_NAME clang-tidy)
  IF(CMAKE_CXX_COMPILER_ID STREQUAL "Clang")
    # 如果你用了Clang, 那么tidy和format的版本要和clang的版本一致
    # 否则有些 format/tidy 规则会出现兼容问题
    IF(CMAKE_CXX_COMPILER_VERSION MATCHES "^14.")
      SET(CLANG_TIDY_SEARCH_NAME clang-tidy-14)
    ELSEIF(CMAKE_CXX_COMPILER_VERSION MATCHES "^15.")
      SET(CLANG_TIDY_SEARCH_NAME clang-tidy-15)
    ELSEIF(CMAKE_CXX_COMPILER_VERSION MATCHES "^16.")
      SET(CLANG_TIDY_SEARCH_NAME clang-tidy-16)
    ELSEIF(CMAKE_CXX_COMPILER_VERSION MATCHES "^17.")
      SET(CLANG_TIDY_SEARCH_NAME clang-tidy-17)
    ELSE()
      SET(CLANG_TIDY_SEARCH_NAME clang-tidy-14)
    ENDIF()
  ENDIF()
  # attempt to find the binary if user did not specify
  FIND_PROGRAM(CLANG_TIDY_BIN
               NAMES ${CLANG_TIDY_SEARCH_NAME}
               HINTS ${CLANG_SEARCH_PATH})
  IF(${CLANG_TIDY_BIN} STREQUAL "CLANG_TIDY_BIN-NOTFOUND")
    MESSAGE(STATUS "${BR}启用了clang-tidy支持,但是找不到[${CLANG_TIDY_SEARCH_NAME}]可执行文件${COLOR_OFF}")
  ELSE()
    VERBOSE_MESSAGE("clang-tidy： " ${CLANG_TIDY_BIN})
    SET(CMAKE_CXX_CLANG_TIDY ${CLANG_TIDY_BIN} -extra-arg=-Wno-unknown-warning-option)
  ENDIF()
endif()
