cmake_minimum_required(VERSION 3.12)

set(PICO_BOARD pico_w)

#include build functions from Pico SDK

if(NOT(PICO_SDK_PATH))
	message(FATAL_ERROR "Set a valid path for pico-sdk -DPICO_SDK_PATH")
endif()	

include("${PICO_SDK_PATH}/external/pico_sdk_import.cmake")

# Set name of project (as PROJECT_NAME) and C/C++ Standards

project(serial C CXX ASM)

set(CMAKE_C_STANDARD 11)

set(CMAKE_CXX_STANDARD 17)

# Creates a pico-sdk subdirectory in our project for the libraries
pico_sdk_init()

##====================================================================

include(${CMAKE_CURRENT_SOURCE_DIR}/cmake/utilities.cmake)

message_yellow("Use -DLWIP_MODE with options: background or poll. Default: background")
message_yellow("Use -DUSB_DEBUG=ON to enable debug using usb serial port. Default: off")

option(USB_DEBUG "Enable debug via usb serial port" OFF)

if(NOT(LWIP_MODE))
	set(LWIP_MODE "background")
endif()

message(STATUS "LWIP mode: ${LWIP_MODE}")

set(APP udp_server_poll)
set(LWIP_LIB pico_cyw43_arch_lwip_poll)

if("${LWIP_MODE}" STREQUAL "background")
	set(APP udp_server_background)
	set(LWIP_LIB pico_cyw43_arch_lwip_threadsafe_background)
endif()

if(USB_DEBUG)
	message_yellow("Debug enabled via usb serial port")
endif()

generate_server_definition_file("${CMAKE_CURRENT_SOURCE_DIR}" "${CMAKE_CURRENT_SOURCE_DIR}/include/udp_server")

#--------------------------------------------------------------------

add_executable(
	"${APP}"
	main.c
	src/picow_udp_server.c
)

target_compile_definitions(
	"${APP}"
	PRIVATE
	WIFI_SSID=\"${WIFI_SSID}\"
	WIFI_PASSWORD=\"${WIFI_PASSWORD}\"
)

target_include_directories(
	"${APP}"
	PRIVATE
	${CMAKE_CURRENT_LIST_DIR}/include
	${CMAKE_CURRENT_LIST_DIR}/include/udp_server
)

target_link_libraries(
	"${APP}"
	pico_stdlib
	${LWIP_LIB}
)

if(USB_DEBUG)
	target_compile_definitions(
		"${APP}"
		PRIVATE
		USB_DEBUG
	)
	pico_enable_stdio_usb("${APP}" ENABLED) 
endif()

pico_add_extra_outputs("${APP}")


