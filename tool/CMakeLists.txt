project(STM23F103C8T6 C CXX ASM)
cmake_minimum_required(VERSION 3.5.0)

include(stm32f103rbt6.cmake)

set(CMAKE_VERBOSE_M‌​AKEFILE ON)

add_definitions(-DSTM32F103x6)


file(GLOB_RECURSE USER_SOURCES Src/*.c)
file(GLOB_RECURSE HAL_SOURCES Drivers/STM32F1xx_HAL_Driver/Src/*.c)

add_library(CMSIS)

target_sources(CMSIS
        PUBLIC
        ${PROJECT_SOURCE_DIR}/Drivers/CMSIS/Device/ST/STM32F1xx/Source/Templates/system_stm32f1xx.c
        ${PROJECT_SOURCE_DIR}/Drivers/CMSIS/Device/ST/STM32F1xx/Source/Templates/gcc/startup_stm32f103xb.s)

include_directories(
        Drivers/CMSIS/Device/ST/STM32F1xx/Include
        Drivers/CMSIS/Include
        Drivers/STM32F1xx_HAL_Driver/Inc
        Inc)

add_executable(${PROJECT_NAME}.elf ${USER_SOURCES} ${HAL_SOURCES} ${LINKER_SCRIPT})

target_link_libraries(${PROJECT_NAME}.elf CMSIS)


set(HEX_FILE ${PROJECT_SOURCE_DIR}/build/${PROJECT_NAME}.hex)
set(BIN_FILE ${PROJECT_SOURCE_DIR}/build/${PROJECT_NAME}.bin)

add_custom_command(TARGET ${PROJECT_NAME}.elf POST_BUILD
        COMMAND ${CMAKE_OBJCOPY} -Oihex $<TARGET_FILE:${PROJECT_NAME}.elf> ${HEX_FILE}
        COMMAND ${CMAKE_OBJCOPY} -Obinary $<TARGET_FILE:${PROJECT_NAME}.elf> ${BIN_FILE}
        COMMENT Building ${HEX_FILE} \nBuilding ${BIN_FILE})
