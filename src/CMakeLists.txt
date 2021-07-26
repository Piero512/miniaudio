cmake_minimum_required(VERSION 3.4)

project(miniaudio C)
set(COMMON_DEFS MA_ENABLE_ONLY_SPECIFIC_BACKENDS MA_NO_ENCODING MA_NO_DEVICE_IO MA_NO_GENERATION MA_NO_THREADING)
set(CMAKE_BUILD_TYPE "RELEASE")
if(APPLE)
    add_library(miniaudio STATIC  miniaudio.c)
    add_library(miniaudio_shared SHARED miniaudio.c)
else()
    add_library(miniaudio SHARED miniaudio.c)
endif()
set_target_properties(miniaudio PROPERTIES
FRAMEWORK TRUE
FRAMEWORK_VERSION C
PUBLIC_HEADER miniaudio.h
)
target_compile_definitions(miniaudio PRIVATE ${COMMON_DEFS})
if(APPLE)
    target_compile_definitions(miniaudio_shared PRIVATE ${COMMON_DEFS})
endif()
set(PROJECT_ROOT ${CMAKE_SOURCE_DIR}/..)
if(APPLE)
    install(TARGETS miniaudio DESTINATION ${PROJECT_ROOT}/macos/)
endif()
if(NOT APPLE AND UNIX) # Linux?
    install(TARGETS miniaudio DESTINATION ${PROJECT_ROOT}/linux/)
endif()
if(WIN32)
    install(TARGETS miniaudio DESTINATION ${PROJECT_ROOT}/windows/)
endif()
