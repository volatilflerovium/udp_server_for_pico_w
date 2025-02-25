
if(NOT WIN32)
	#https://stackoverflow.com/questions/18968979/how-to-make-colorized-message-with-cmake
	string(ASCII 27 Esc)
	set(ColourReset "${Esc}[m")
	set(Yellow      "${Esc}[32m")
endif()


function(message_yellow MSG)
	message("${Yellow}${MSG}${ColourReset}")
endfunction()


if(PICO_BOARD STREQUAL "pico_w")
	if(DEFINED ENV{WIFI_SSID} AND (NOT WIFI_SSID))
		set(WIFI_SSID $ENV{WIFI_SSID})
		message("Using WIFI_SSID from environment ('${WIFI_SSID}')")
	endif()

	if(DEFINED ENV{WIFI_PASSWORD} AND (NOT WIFI_PASSWORD))
		set(WIFI_PASSWORD $ENV{WIFI_PASSWORD})
		message("Using WIFI_PASSWORD from environment")
	endif()

	set(WIFI_SSID "${WIFI_SSID}" CACHE INTERNAL "WiFi SSID")
	set(WIFI_PASSWORD "${WIFI_PASSWORD}" CACHE INTERNAL "WiFi password")

	if("${WIFI_SSID}" STREQUAL "")
    	message(FATAL_ERROR "UDP Server needs WIFI_SSID but it's not defined")
	elseif ("${WIFI_PASSWORD}" STREQUAL "")
    	message(FATAL_ERROR  "UDP Server needs WIFI_PASSWORD but it's not defined")
	endif()

	set(DEFAULT_BUFFER_SIZE 512)
	set(DEFAULT_PORT 4444)
	if(NOT(UDP_SERVER_BUFFER_SIZE))
		set(_BUFFER_SIZE ${DEFAULT_BUFFER_SIZE})
	else()
		set(_BUFFER_SIZE ${UDP_SERVER_BUFFER_SIZE})
	endif()

	if(NOT(UDP_SERVER_PORT))
		set(_UDP_PORT ${DEFAULT_PORT})
	else()
		set(_UDP_PORT ${UDP_SERVER_PORT})
	endif()	

	message_yellow("Default server buffer size ${DEFAULT_BUFFER_SIZE}. Use -DUDP_SERVER_BUFFER_SIZE to set a custom size")
	message_yellow("Default server port ${DEFAULT_PORT}. Use -DUDP_SERVER_PORT to set a custom port")

	message(STATUS "Server buffer size: ${_BUFFER_SIZE}")
	message(STATUS "Server port: ${_UDP_PORT}")

	set(_DONT_EDIT_MESSAGE "Please do not edit this file.\n Use -DUDP_SERVER_BUFFER_SIZE and -DUDP_SERVER_PORT options when running cmake")

endif()

function(generate_server_definition_file TEMPLATE_PATH DEST)
	configure_file("${TEMPLATE_PATH}/cmake/IncludeDefinitionTemplate.cmake.in" "${DEST}/server_config.h" @ONLY)
endfunction()


