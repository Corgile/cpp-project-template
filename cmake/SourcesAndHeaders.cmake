set(lib_sources
		source/tmp.cpp
)

set(exe_sources
		source/main.cpp
		${lib_sources}
)

set(headers
		include/project/tmp.hpp
)
FILE(GLOB test_sources
		 ${PROJECT_SOURCE_DIR}/test/*/*.cpp
)
