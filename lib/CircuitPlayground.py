import time
import board
from digitalio import DigitalInOut, Direction, Pull
import random


import touchio
import neopixel

from adafruit_ble import BLERadio
from adafruit_ble.advertising.standard import ProvideServicesAdvertisement
from adafruit_ble.services.nordic import UARTService


ble = BLERadio()
uart = UARTService()
advertisement = ProvideServicesAdvertisement(uart)

switch = DigitalInOut(board.BUTTON_A)
switch.direction = Direction.INPUT
switch.pull = Pull.DOWN

debounce_interval = 0.3
last_button_press = time.monotonic()

###################################################################
## touch_A1 = touchio.TouchIn(board.A1)

np = neopixel.NeoPixel(board.NEOPIXEL, 1, brightness=0.1)
###################################################################

nb_of_bytes = 3
def process_bytes(in_bytes):
    print("Bytes received: " + str(in_bytes))
    np.fill((0,0,0))
    time.sleep(0.2)
    np.fill((in_bytes[0], in_bytes[1], in_bytes[2]))

def process_button_pressed(is_pressed):
    print("Button change event to: " + str(is_pressed))
    if is_pressed:
        np.fill((0,0,0))
        uart.write(bytearray([1]))
    else:
        5+1
        ##uart.write(bytearray([0]))

def detect_event():
    return(switch.value)



while True:
    ble.start_advertising(advertisement)
    # Wait for a connection
    while not ble.connected:
        pass

    button_is_pressed = False
    while ble.connected:
        in_bytes = ""

        #print("Time: " + str(time.monotonic()))

        #print("Bytes waiting: " + str(uart.in_waiting))

        # wait until nb_of_bytes are available on bluetooth
        if uart.in_waiting == nb_of_bytes:
            in_bytes = uart.read(nb_of_bytes)
            process_bytes(in_bytes)

        # call process_button_pressed if the button is pressed and enough
        # time has been passed. (debounce the button)
        if detect_event() and not button_is_pressed:
            if time.monotonic() - last_button_press > debounce_interval:
                button_is_pressed = True
                process_button_pressed(True)
        elif button_is_pressed:
            button_is_pressed = False
            last_button_press = time.monotonic()
            process_button_pressed(False)