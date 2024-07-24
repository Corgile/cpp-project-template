if(${PROJECT_NAME}_ENABLE_CLANG_TIDY)
  # attempt to find the binary if user did not specify
  FIND_PROGRAM(CLANG_TIDY_BIN NAMES clang-tidy clang-tidy-14)

  IF("x${CLANG_TIDY_BIN}" STREQUAL "xCLANG_TIDY_BIN-NOTFOUND")
    MESSAGE(WARNING "${PROJECT_NAME}/main 未找到 clang-tidy 可执行文件.")
  ELSE()
    # Output compile_commands.json
    SET(CMAKE_EXPORT_COMPILE_COMMANDS 1)
    VERBOSE_MESSAGE("clang-tidy： ${CLANG_TIDY_BIN}")
  ENDIF()

  ADD_CUSTOM_TARGET(check-clang-tidy
                    ${PROJECT_SCRIPTS_DIR}/clang_tidy.py # run LLVM's clang-tidy script
                    -clang-tidy-binary ${CLANG_TIDY_BIN} # using our clang-tidy binary
                    -p ${CMAKE_BINARY_DIR} # using cmake's generated compile commands
  )
endif()
