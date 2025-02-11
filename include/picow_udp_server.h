/*********************************************************************
* UDP Server Interface                         				            *
*                                                                    *
* Version: 1.0                                                       *
* Date:    08-02-2025                                                *
* Author:  Dan Machado                                               *
*                                                                    *
* Based on TCP server pico w example                                 *
**********************************************************************/
#ifndef _UDP_SERVER_H
#define _UDP_SERVER_H

#include <stdio.h>
#include "pico/stdlib.h"

//===================================================================

bool init_network();

void stop_network();

//-------------------------------------------------------------------

void server_stop();

/*
* Start up the server and set the callback function that will handle
* the messages sent to the server by clients.
*
* @param RECV_CBK function pointer that takes two parameters:
*                 a pointer to the internal buffer and the size
*                 of the data received.
*/
bool start_udp_server(void (*RECV_CBK)(const uint8_t*, const uint16_t));

/*
* if you are using pico_cyw43_arch_poll (built with LWIP_MODE=poll), 
* then you must poll periodically from your main loop (not from a timer) 
* to check for Wi-Fi driver or lwIP work that needs to be done.
*/
void server_poll();

bool send_data(const void* buffer, const uint16_t buffer_size);

void send_ok();

void handshake();

//-------------------------------------------------------------------

#define send_msg(...) {\
	static char debug_buffer[512];\
	memset(debug_buffer, 0, 512);\
	uint16_t n=snprintf((void*)debug_buffer, 511, __VA_ARGS__);\
	send_data((void*)debug_buffer, n);\
}

//-------------------------------------------------------------------

#ifdef USB_DEBUG
#define usb_dbg(...) {\
	static char debug_buffer[256];\
	memset(debug_buffer, 0, 256);\
	snprintf((void*)debug_buffer, 255, __VA_ARGS__);\
	printf(debug_buffer);\
}
#else
	#define usb_dbg(...) {};
#endif

//===================================================================

#endif

