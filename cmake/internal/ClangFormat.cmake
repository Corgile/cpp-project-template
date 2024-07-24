IF(${PROJECT_NAME}_ENABLE_CLANG_FORMAT)
  INCLUDE(${PROJECT_SOURCE_DIR}/cmake/internal/VARS.cmake)
  SET(CLANG_FORMAT_SEARCH_NAME clang-format)
  IF(CMAKE_CXX_COMPILER_ID STREQUAL "Clang")
    IF(CMAKE_CXX_COMPILER_VERSION MATCHES "^14.")
      SET(CLANG_FORMAT_SEARCH_NAME clang-format-14)
    ELSEIF(CMAKE_CXX_COMPILER_VERSION MATCHES "^15.")
      SET(CLANG_FORMAT_SEARCH_NAME clang-format-15)
    ELSEIF(CMAKE_CXX_COMPILER_VERSION MATCHES "^16.")
      SET(CLANG_FORMAT_SEARCH_NAME clang-format-16)
    ELSEIF(CMAKE_CXX_COMPILER_VERSION MATCHES "^17.")
      SET(CLANG_FORMAT_SEARCH_NAME clang-format-17)
    ELSE()
      SET(CLANG_FORMAT_SEARCH_NAME clang-format-14)
    ENDIF()
  ENDIF()

  FIND_PROGRAM(CLANG_FORMAT_BIN
               NAMES ${CLANG_FORMAT_SEARCH_NAME}
               HINTS ${CLANG_SEARCH_PATH})
  IF(${CLANG_FORMAT_BIN} STREQUAL "CLANG_FORMAT_BIN-NOTFOUND")
    MESSAGE(STATUS "${BR}启用了clang-format支持,但是找不到[${CLANG_FORMAT_SEARCH_NAME}]可执行文件${COLOR_OFF}")
  ELSE()
    VERBOSE_MESSAGE("clang-format： " ${CLANG_FORMAT_BIN})
  ENDIF()

  IF(${PROJECT_NAME}_BUILD_EXECUTABLE)
    ADD_CUSTOM_TARGET(run-clang-format COMMAND ${CLANG_FORMAT_BIN}
                      -i ${exe_sources} ${headers} ${test_sources}
                      WORKING_DIRECTORY ${PROJECT_SOURCE_DIR})
  ELSEIF(${PROJECT_NAME}_BUILD_HEADERS_ONLY)
    ADD_CUSTOM_TARGET(run-clang-format
                      COMMAND ${CLANG_FORMAT_BIN}
                      -i ${headers} ${test_sources}
                      WORKING_DIRECTORY ${PROJECT_SOURCE_DIR})
  ELSE()
    ADD_CUSTOM_TARGET(run-clang-format
                      COMMAND ${CLANG_FORMAT_BIN}
                      -i ${lib_sources} ${headers} ${test_sources}
                      WORKING_DIRECTORY ${PROJECT_SOURCE_DIR})
  ENDIF()
ENDIF()
