# UART-FSM
Universal Asynchronous Receive/Transmit Finite State Machine 

This is an 8-bit transmitter and receiver using a baud tick generator. The speed of the baud tick generator can be customized but the default is 10 clock cycles. The 8-bit data waiting to be transmitted is packed into 10 bits with a start and end bit of 0 and 1 respectively. This 10 bit value is sent over to the receiver 1 bit at a time at the rate of the baud tick. Received values are entered into a buffer, and then the transmitted data is shown on a 7-segment display of a DE10-Lite FPGA once all data is received.   

Transmitted data is hardcoded to 12 and 90 which can be toggled using the second switch from the right. The right switch is used as a reset and the top button is used as the clock, pressing the button results in a negative clock edge and no press results in a positive clock edge.  

<img width="272" height="204" alt="UART1" src="https://github.com/user-attachments/assets/72d8d43e-89d7-46a4-add5-e813e53115ee" />
<img width="272" height="204" alt="UART2" src="https://github.com/user-attachments/assets/65bdb71a-7b6f-4352-8097-6dcce1af182e" />

Starting from the right, the first LED represents the state of the transmitter where a light on means busy and a light off means ready. The second LED represents the state of the receiver where a light on means ready and a light off means busy. The third LED represents the current bit being transmitted where a light on means 1 and a light off mean 0.
