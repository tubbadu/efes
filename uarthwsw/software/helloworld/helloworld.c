/*
 * "Hello World" example.
 *
 * This example prints 'Hello from Nios II' to the STDOUT stream. It runs on
 * the Nios II 'standard', 'full_featured', 'fast', and 'low_cost' example
 * designs. It runs with or without the MicroC/OS-II RTOS and requires a STDOUT
 * device in your system's hardware.
 * The memory footprint of this hosted application is ~69 kbytes by default
 * using the standard reference design.
 *
 * For a reduced footprint version of this template, and an explanation of how
 * to reduce the memory footprint for a given application, see the
 * "small_hello_world" template.
 *
 */

#include <stdio.h>
#include "system.h"
#include "sys/alt_timestamp.h"
#include "altera_avalon_pio_regs.h"


#define PROJECT_4_v3

#ifdef PROJECT_1


int main()
{
	printf("Exercise 1");
	return 0;
}


#endif



#ifdef PROJECT_2


int main()
{
	int gpio,nticks=10000;
	alt_timestamp_start();
	printf("hello");
	for( ; ; ){

		gpio=IORD_ALTERA_AVALON_PIO_DATA(NIOS_HEADER_CONN_BASE);


		/*if(gpio & 1 == 1){
			IOWR_ALTERA_AVALON_PIO_DATA(NIOS_HEADER_CONN_BASE,gpio&(!0b01)); // write 0
		}
		else
		{
			IOWR_ALTERA_AVALON_PIO_DATA(NIOS_HEADER_CONN_BASE,gpio|0b01); // write one
		}*/
		IOWR_ALTERA_AVALON_PIO_DATA(NIOS_HEADER_CONN_BASE,gpio^(0b01));
		int starting_timestamp=alt_timestamp();

		while(alt_timestamp()-starting_timestamp < nticks) { /* Do nothing */ }

	}

  return 0;
}


#endif


#ifdef PROJECT_4

#define BAUD_RATE 1200
#define NBIT 8
#define NSTOPBIT 1

#define NOPARITY 0
#define EVENPARITY 1
#define ODDPARITY 2
#define PARITY NOPARITY




//#define READ_BIT() IORD_ALTERA_AVALON_PIO_DATA(NIOS_UARTRX_BASE) & 0b1;// IOWR_ALTERA_AVALON_PIO_DATA(NIOS_HEADER_CONN_BASE,1); IOWR_ALTERA_AVALON_PIO_DATA(NIOS_HEADER_CONN_BASE,0)


#define READ_BIT() (IORD_ALTERA_AVALON_PIO_DATA(NIOS_UARTRX_BASE) & 0b1)

#define PULSE() IOWR_ALTERA_AVALON_PIO_DATA(NIOS_HEADER_CONN_BASE,1); IOWR_ALTERA_AVALON_PIO_DATA(NIOS_HEADER_CONN_BASE,0)

#define WAIT_CLOCK_CYCLES(nticks) while(alt_timestamp()-starting_timestamp < nticks) { /* Do nothing */ }; starting_timestamp = alt_timestamp()

#define READ_AND_APPEND_BIT(var) var = var<<1; var = var | READ_BIT()

int main()
{

	IOWR_ALTERA_AVALON_PIO_DATA(NIOS_HEADER_CONN_BASE,0);
	printf("Project #4: UART decoder.\n");
	
	uint ticks_per_second = alt_timestamp_freq();
	uint ticks_per_bit = ticks_per_second / BAUD_RATE;
	uint ticks_per_half_bit = ticks_per_bit / 2;
	uint starting_timestamp;
	//uint total_bit = 1 + NBIT + (PARITY != 0 ? 1 : 0) + NSTOPBIT;

#if (PARITY != NOPARITY)
	int parity = 0;
#endif

	uint stop_bits = ~0; // all ones: this way, at the end if it still is all ones it means it's correct
	int rx_value[NBIT]; // is this a char or an int?

	printf("Initialization completed: starting now waiting waiting loop.\n");

	// starting bit: transition high to low
	alt_timestamp_start(); // this is counting clock cycles
	//starting_timestamp = alt_timestamp();
	for(;;){
		stop_bits = ~0; // all ones: this way, at the end if it still is all ones it means it's correct
		//rx_value = 0;

		while(READ_BIT()) { /* do nothing */ }
		//PULSE();

		starting_timestamp = alt_timestamp();
		// starting HIGH to LOW transition happened!

		// start timer


		// wait for half a bit time and check if the starting bit is still LOW: if not, an error occourred
		WAIT_CLOCK_CYCLES(ticks_per_half_bit);
		if(READ_BIT()) {
			// an error occurred! print an error and terminate
			printf("ERROR: starting bit changed value in half a bit time! Exiting...\n");
			return 1;
		}
		PULSE();

		// now wait for one bit time and read the next value
		//WAIT_CLOCK_CYCLES(ticks_per_bit);
		// rx_value += READ_BIT(); // append bit
		// rx_value = rx_value | READ_BIT(); // append bit - alternate way: which one is faster?
		// rx_value<<1; // shift left

	//for(uint i=1; !(i & (1<<NBIT)); (i<<1)){ // check
	for(int i=NBIT-1; i>=0; i--){ // alternate way: which one is faster?
			// repeat NBIT times
			WAIT_CLOCK_CYCLES(ticks_per_bit);
			//READ_AND_APPEND_BIT(rx_value);
			rx_value[i] = READ_BIT();
			PULSE();
	}
	#if (PARITY == ODDPARITY || PARITY == EVENPARITY)
		WAIT_CLOCK_CYCLES(ticks_per_bit);
		parity = READ_BIT();
		// we will check for the correctness of the parity at the end of the communication
	#endif

		// read stop bits
		for(uint i=0; i<NSTOPBIT; i++){
			// repeat NSTOPBIT times
			WAIT_CLOCK_CYCLES(ticks_per_bit);
			READ_AND_APPEND_BIT(stop_bits);
			PULSE();
		}

		// communication ended
		// now check for parity and for stop bits
	#if (PARITY != NOPARITY)
		// check parity
		// parity will be toggled for each '1'
		// so for example, if the message is "000000001" and parity bit is '1', at the end it will be '0':
		// TLDR: at the end, parity=='0' means EVENPARITY, parity=='1' means ODDPARITY
		for(uint i=0; i<NBIT; i++){
			parity ^= (rx_value[i]) & 0b1; // toggle the 0th bit if the rx_value[i] is '1'
		}


		#if (PARITY == EVENPARITY)
			// parity should be '0'
			if(parity){
				printf("ERROR: even parity is wrong! Exiting...\n");
				return 1;
			}
		#endif

		#if (PARITY == ODDPARITY)
			// parity should be '1'
			if(!parity){
				printf("ERROR: odd parity is wrong! Exiting...\n");
				return 1;
			}
		#endif
	#endif

		// check now for stop_bits
		if(stop_bits != (~0)){
			printf("ERROR: stop bits are different from all ones! Exiting...\n %u", stop_bits);
			return 1;
		}

		// if we're here it means that it all went well. Let's print on JTAG_UART the value read, and then start reading the next value

		printf("received value: ");
		for(uint i=0; i<NBIT; i++){ // alternate way: which one is faster?
			printf("%d", rx_value[i]);
		}

		printf("\n");
	}

	return 0;
}


#endif

#ifdef PROJECT_4_v2

#define BAUD_RATE 9600
#define NBIT 8
#define NSTOPBIT 1

#define NOPARITY 0
#define EVENPARITY 1
#define ODDPARITY 2
#define PARITY NOPARITY




//#define READ_BIT() IORD_ALTERA_AVALON_PIO_DATA(NIOS_UARTRX_BASE) & 0b1;// IOWR_ALTERA_AVALON_PIO_DATA(NIOS_HEADER_CONN_BASE,1); IOWR_ALTERA_AVALON_PIO_DATA(NIOS_HEADER_CONN_BASE,0)


#define READ_BIT() (IORD_ALTERA_AVALON_PIO_DATA(NIOS_UARTRX_BASE) & 0b1)

#define PULSE() IOWR_ALTERA_AVALON_PIO_DATA(NIOS_HEADER_CONN_BASE,1);
	//starting_timestamp = alt_timestamp(); \
	while(alt_timestamp() - starting_timestamp < ticks_per_pulse){}; \
	IOWR_ALTERA_AVALON_PIO_DATA(NIOS_HEADER_CONN_BASE,0)

#define WAIT_CLOCK_CYCLES(nticks) while(alt_timestamp()-starting_timestamp < nticks) { /* Do nothing */ }; starting_timestamp = alt_timestamp()

#define READ_AND_APPEND_BIT(var) var = var<<1; var = var | READ_BIT()

int main()
{

	IOWR_ALTERA_AVALON_PIO_DATA(NIOS_HEADER_CONN_BASE,0);
	printf("Project #4: UART decoder.\n");

	uint ticks_per_second = alt_timestamp_freq();
	uint ticks_per_bit = ticks_per_second / BAUD_RATE;
	uint ticks_per_half_bit = ticks_per_bit / 2;
	uint ticks_per_pulse = ticks_per_bit / 8;
	uint timestamp, timestamp_tmp, starting_timestamp;
	//uint total_bit = 1 + NBIT + (PARITY != 0 ? 1 : 0) + NSTOPBIT;

#if (PARITY != NOPARITY)
	int parity = 0;
#endif

	uint stop_bits, start_bit_check;
	int rx_value[NBIT]; // is this a char or an int?

	printf("Initialization completed: starting now waiting waiting loop.\n");

	alt_timestamp_start(); // this is counting clock cycles
	for(;;){
		stop_bits = ~0; // all ones: this way, at the end if it still is all ones it means it's correct

		while(READ_BIT()) { /* do nothing */ }
		timestamp = alt_timestamp();
		PULSE();
		do{
			timestamp_tmp = alt_timestamp();
		} while(timestamp_tmp-timestamp < ticks_per_half_bit);
		timestamp = timestamp_tmp;
		start_bit_check = READ_BIT();
		PULSE();

		for(int i=NBIT-1; i>=0; i--){
			// repeat NBIT times
			do{
				timestamp_tmp = alt_timestamp();
			} while(timestamp_tmp-timestamp < ticks_per_bit);
			timestamp = timestamp_tmp;
			rx_value[i] = READ_BIT();
			PULSE();
		}

	#if (PARITY == ODDPARITY || PARITY == EVENPARITY)
		do{
			timestamp_tmp = alt_timestamp();
		} while(timestamp_tmp-timestamp < ticks_per_bit);
		timestamp = timestamp_tmp;
		parity = READ_BIT();
		PULSE();
	#endif

		// read stop bits
		for(uint i=0; i<NSTOPBIT; i++){
			// repeat NSTOPBIT times
			do{
				timestamp_tmp = alt_timestamp();
			} while(timestamp_tmp-timestamp < ticks_per_bit);
			timestamp = timestamp_tmp;
			READ_AND_APPEND_BIT(stop_bits);
			PULSE();
		}

		// communication ended
		// now check for start bit, parity and for stop bits
		if(start_bit_check){
			printf("ERROR: start bit is HIGH, but it should be LOW!");
			continue;
		}
		if(stop_bits != (~0)){
			printf("ERROR: stop bits are different from all ones! %u != %u", stop_bits, (~0));
			continue;
		}
	#if (PARITY != NOPARITY)
		// check parity
		// parity will be toggled for each '1'
		// so for example, if the message is "000000001" and parity bit is '1', at the end it will be '0':
		// TLDR: at the end, parity=='0' means EVENPARITY, parity=='1' means ODDPARITY
		for(uint i=0; i<NBIT; i++){
			parity ^= (rx_value[i]) & 0b1; // toggle the 0th bit if the rx_value[i] is '1'
		}


	#if (PARITY == EVENPARITY)
		// parity should be '0'
		if(parity){
			printf("ERROR: even parity is wrong! \n");
			continue;
		}
	#endif

	#if (PARITY == ODDPARITY)
		// parity should be '1'
		if(!parity){
			printf("ERROR: odd parity is wrong! \n");
			continue;
		}
	#endif
	#endif

		printf("received value: ");
		for(uint i=0; i<NBIT; i++){ // alternate way: which one is faster?
			printf("%d", rx_value[i]);
		}
		printf("\n");
	}

	return 0;
}


#endif

#ifdef PROJECT_4_v3

#define BAUD_RATE 19200
#define NBIT 8
#define NSTOPBIT 1

#define NOPARITY 0
#define EVENPARITY 1
#define ODDPARITY 2
#define PARITY NOPARITY




//#define READ_BIT() IORD_ALTERA_AVALON_PIO_DATA(NIOS_UARTRX_BASE) & 0b1;// IOWR_ALTERA_AVALON_PIO_DATA(NIOS_HEADER_CONN_BASE,1); IOWR_ALTERA_AVALON_PIO_DATA(NIOS_HEADER_CONN_BASE,0)


#define READ_BIT() (IORD_ALTERA_AVALON_PIO_DATA(NIOS_UARTRX_BASE) & 0b1)

#define PULSE() IOWR_ALTERA_AVALON_PIO_DATA(NIOS_HEADER_CONN_BASE,0b1); \
	IOWR_ALTERA_AVALON_PIO_DATA(NIOS_HEADER_CONN_BASE,0b0);

#define WAIT_CLOCK_CYCLES(nticks) while(alt_timestamp()-starting_timestamp < nticks) { /* Do nothing */ }; starting_timestamp = alt_timestamp()

#define READ_AND_APPEND_BIT(var) var = var<<1; var = var | READ_BIT()

int main()
{
	alt_timestamp_start(); // this is counting clock cycles

	printf("Project #4: UART decoder.\n");

	unsigned int ticks_per_second = alt_timestamp_freq();
	unsigned int ticks_per_bit = ticks_per_second / BAUD_RATE;
	unsigned int ticks_per_half_bit = ticks_per_bit / 2;
	unsigned int next_timestamp, starting_timestamp;
	// unsigned long int ticks_per_pulse = ticks_per_bit / 100;
	//uint total_bit = 1 + NBIT + (PARITY != 0 ? 1 : 0) + NSTOPBIT;

#if (PARITY != NOPARITY)
	int parity = 0;
#endif

	uint stop_bits, start_bit_check;
	int rx_value[NBIT]; // is this a char or an int?

	printf("Initialization completed: starting now waiting waiting loop.\n");


	for(;;){
		stop_bits = ~0; // all ones: this way, at the end if it still is all ones it means it's correct

		while(READ_BIT())
			{next_timestamp = alt_timestamp() + ticks_per_half_bit;}
		//PULSE();
		while(alt_timestamp() < next_timestamp){};
		next_timestamp += ticks_per_bit;
		start_bit_check = READ_BIT();
		PULSE();

		for(int i=NBIT-1; i>=0; i--){
			// repeat NBIT times
			while(alt_timestamp() < next_timestamp){};
			next_timestamp += ticks_per_bit;
			rx_value[i] = READ_BIT();
			PULSE();
		}

	#if (PARITY == ODDPARITY || PARITY == EVENPARITY)
		while(alt_timestamp() < next_timestamp){};
		next_timestamp += ticks_per_bit;
		parity = READ_BIT();
		PULSE();
	#endif

		// read stop bits
		for(uint i=0; i<NSTOPBIT; i++){
			// repeat NSTOPBIT times
			while(alt_timestamp() < next_timestamp){};
			next_timestamp += ticks_per_bit;
			READ_AND_APPEND_BIT(stop_bits);
			PULSE();
		}

		// communication ended
		// now check for start bit, parity and for stop bits
		if(start_bit_check){
			printf("ERROR: start bit is HIGH, but it should be LOW!\n");
			continue;
		}
		if(stop_bits != (~0)){
			printf("ERROR: stop bits are different from all ones! %u != %u\n", stop_bits, (~0));
			continue;
		}
	#if (PARITY != NOPARITY)
		// check parity
		// parity will be toggled for each '1'
		// so for example, if the message is "000000001" and parity bit is '1', at the end it will be '0':
		// TLDR: at the end, parity=='0' means EVENPARITY, parity=='1' means ODDPARITY
		for(uint i=0; i<NBIT; i++){
			parity ^= (rx_value[i]) & 0b1; // toggle the 0th bit if the rx_value[i] is '1'
		}


	#if (PARITY == EVENPARITY)
		// parity should be '0'
		if(parity){
			printf("ERROR: even parity is wrong! \n");
			continue;
		}
	#endif

	#if (PARITY == ODDPARITY)
		// parity should be '1'
		if(!parity){
			printf("ERROR: odd parity is wrong! \n");
			continue;
		}
	#endif
	#endif

		printf("received value: ");
		for(uint i=0; i<NBIT; i++){ // alternate way: which one is faster?
			printf("%d", rx_value[i]);
		}
		printf("\n");
	}

	return 0;
}


#endif
