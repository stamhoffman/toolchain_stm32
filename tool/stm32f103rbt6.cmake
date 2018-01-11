include(CMakeForceCompiler)

set(CMAKE_SYSTEM_NAME Generic)
set(CMAKE_SYSTEM_PROCESSOR cortex-m3)

# Find the cross compiler
find_program(ARM_CC arm-none-eabi-gcc
            ${TOOLCHAIN_DIR}/bin)
find_program(ARM_CXX arm-none-eabi-g++
            ${TOOLCHAIN_DIR}/bin)
find_program(ARM_OBJCOPY arm-none-eabi-objcopy
            ${TOOLCHAIN_DIR}/bin)
find_program(ARM_SIZE_TOOL arm-none-eabi-size
            ${TOOLCHAIN_DIR}/bin)
find_program(ARM_AS arm-none-eabi-as
            ${TOOLCHAIN_DIR}/bin)


CMAKE_FORCE_C_COMPILER(${ARM_CC} GNU)
CMAKE_FORCE_CXX_COMPILER(${ARM_CXX} GNU)

set(COMMON_FLAGS
        "-fno-common -ffunction-sections -fdata-sections")

set(CMAKE_ASM_FLAGS
        ${CMAKE_ASM_FLAGS} "-mcpu=cortex-m3 -mthumb")

if (CMAKE_SYSTEM_PROCESSOR STREQUAL cortex-m3)
    set(CMAKE_C_FLAGS ${CMAKE_C_FLAGS}
            "-mcpu=cortex-m3 -mthumb -mthumb-interwork -msoft-float")
else ()
    message(WARNING
                    Processor not recognised in toolchain file,
                    compiler flags not configured.)
endif ()

set(LINKER_SCRIPT ${PROJECT_SOURCE_DIR}/STM32F103C8Tx_FLASH.ld)

set(CMAKE_EXE_LINKER_FLAGS "-Wl,-gc-sections -T ${LINKER_SCRIPT}")

# fix long strings (CMake appends semicolons)
string(REGEX REPLACE ";" " " CMAKE_C_FLAGS "${CMAKE_C_FLAGS}")
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS}" CACHE STRING "")
set(BUILD_SHARED_LIBS OFF)
