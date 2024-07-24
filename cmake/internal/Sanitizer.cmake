# 处理sanitize选项
SET(sanitizer_name ${${PROJECT_NAME}_SANITIZER})
IF(x${sanitizer_name} STREQUAL "x")
  IF(x${CMAKE_BUILD_TYPE} STREQUAL "xDebug")
    MESSAGE(STATUS "${COLOR_ERROR}Use -DSANITIZE=<option> to specify one of following:
  'address', 'memory', 'thread', 'undefined', but current is: ${sanitizer_name}${COLOR_OFF}")
  ENDIF()
ELSE()
  MESSAGE(STATUS "${BC}Sanitizer： ${sanitizer_name}${COLOR_OFF}")
  ADD_COMPILE_OPTIONS(-fsanitize=${sanitizer_name})
  ADD_LINK_OPTIONS(-fsanitize=${sanitizer_name})
ENDIF()
