cmake_minimum_required(VERSION 3.4)

project(miniaudio C)
set(COMMON_DEFS MA_ENABLE_ONLY_SPECIFIC_BACKENDS MA_NO_ENCODING MA_NO_DEVICE_IO MA_NO_GENERATION MA_NO_THREADING)
add_library(miniaudio SHARED miniaudio.c)
target_compile_definitions(miniaudio PRIVATE ${COMMON_DEFS})
