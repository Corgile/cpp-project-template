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
MESSAGE(WARNING "你可能需要修改此文件中配置的默认 source、header和lib文件的搜索方式")