/*********************************************************************
*																	 *
* Version: 1.0													     *
* Date:	08-02-2025												     *
* Author:  Dan Machado											     *
*																	 *
* Based on TCP server pico w example								 *
**********************************************************************/
#include <string.h>
#include <stdlib.h>

#include "udp_server/picow_udp_server.h"

void clientMsg(const uint8_t* buffer, const uint16_t buffer_size)
{
	(void) buffer;
	(void) buffer_size;
	send_msg("Server received message size: %d\n", buffer_size);
}

//===================================================================

int main() 
{
	stdio_init_all();

	if(!init_network()){
		return 1;
	}

	bool server_up=start_udp_server(clientMsg);

	while(server_up){
		server_poll();
		sleep_ms(1000);
		usb_dbg("ok: %d\n");
	}
	
	stop_network();

	return 0;
}
