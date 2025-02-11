# Simple UDP Server for RaspberryPi Pico W

Simple implementation of UDP server for Raspberry Pi Pico W RP2040.

# How to build it

```
# cd udp_server_for_pico_w
# mkdir build
# cd build
# cmake .. -DWIFI_SSID="YOUR_SSID" -DWIFI_PASSWORD="YOUR_PASSWD"\
-DPICO_SDK_PATH=/path/to/pico-sdk [-DUDP_SERVER_BUFFER_SIZE=512\]
[-DUDP_SERVER_PORT=4444\]
[-DLWIP_MODE=background\]
[-DUSB_DEBUG=ON]
```

- LWIP_MODE accepts: background or poll. Default: background.
- USB_DEBUG enable usb serial for debugging. Default ON

After flashing your Pico W, it should connect to the local network and it will
given an IP. You can check the IP asigned to the UDP server with the command:
(first the Pico w unplugged)
```
#nmap -sn 192.168.1.*
```
Then repeat the command with Pico w plugged.
