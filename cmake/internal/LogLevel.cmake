SET(LOG_LEVEL ${${PROJECT_NAME}_LOG_LEVEL})
SET(SN ${PROJECT_SHORT_NAME})
SET(CONSOLE_ENABLED ${${PROJECT_NAME}_ENABLE_CONSOLE_LOG})

# >>> Delete this ↓↓↓
IF(${PROJECT_NAME}_ENABLE_LOG)
  MESSAGE(WARNING "注意: 选项 \${PROJECT_NAME}_ENABLE_LOG 启用后， CMake只定义一些宏。具体采用什么日志库你需要自行添加依赖。删除此IF分支")
  SET(LOG_LEVEL INFO)
ENDIF()
# <<< Delete this ↑↑↑

IF(${PROJECT_NAME}_ENABLE_LOG)
  MESSAGE(STATUS "${BR}日志等级: ${LOG_LEVEL}${COLOR_OFF}")
  SET(NEXT_LEVEL OFF)
  ADD_COMPILE_DEFINITIONS(${SN}_ENABLE_LOG)
  IF(${PROJECT_NAME}_ENABLE_CONSOLE_LOG)
    ADD_COMPILE_DEFINITIONS(${SN}_ENABLE_CONSOLE_LOG)
  ENDIF()

  IF(${LOG_LEVEL} STREQUAL "TRACE")
    MESSAGE("    + ${BB}定义宏: ${BY}${SN}_LOG_TRACE${COLOR_OFF}")
    ADD_COMPILE_DEFINITIONS(${SN}_LOG_TRACE)
    SET(NEXT_LEVEL ON)
  ENDIF()
  IF(NEXT_LEVEL OR ${LOG_LEVEL} STREQUAL "DEBUG")
    MESSAGE("    + ${B}定义宏: ${BY}${SN}_LOG_DEBUG${COLOR_OFF}")
    ADD_COMPILE_DEFINITIONS(${SN}_LOG_DEBUG)
    SET(NEXT_LEVEL ON)
  ENDIF()
  IF(NEXT_LEVEL OR ${LOG_LEVEL} STREQUAL "INFO")
    MESSAGE("    + ${B}定义宏: ${BY}${SN}_LOG_INFO${COLOR_OFF}")
    ADD_COMPILE_DEFINITIONS(${SN}_LOG_INFO)
    SET(NEXT_LEVEL ON)
  ENDIF()
  IF(NEXT_LEVEL OR ${LOG_LEVEL} STREQUAL "WARN")
    MESSAGE("    + ${B}定义宏: ${BY}${SN}_LOG_WARN${COLOR_OFF}")
    ADD_COMPILE_DEFINITIONS(${SN}_LOG_WARN)
    SET(NEXT_LEVEL ON)
  ENDIF()
  IF(NEXT_LEVEL OR ${LOG_LEVEL} STREQUAL "ERROR")
    MESSAGE("    + ${B}定义宏: ${BY}${SN}_LOG_ERROR${COLOR_OFF}")
    ADD_COMPILE_DEFINITIONS(${SN}_LOG_ERROR)
    SET(NEXT_LEVEL ON)
  ENDIF()
  IF(NEXT_LEVEL OR ${LOG_LEVEL} STREQUAL "FATAL")
    MESSAGE("    + ${B}定义宏: ${BY}${SN}_LOG_FATAL${COLOR_OFF}")
    ADD_COMPILE_DEFINITIONS(${SN}_LOG_FATAL)
  ENDIF()
  MESSAGE(STATUS "${BB}Console日志: ${BN}${CONSOLE_ENABLED}${COLOR_OFF}")
  IF(${PROJECT_NAME}_ENABLE_CONSOLE_LOG)
    ADD_COMPILE_DEFINITIONS(${SN}_CONSOLE_LOG)
  ENDIF()

ENDIF()
