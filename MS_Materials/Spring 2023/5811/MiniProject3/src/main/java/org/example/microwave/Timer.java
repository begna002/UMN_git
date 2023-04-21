package org.example.microwave;

import java.util.stream.IntStream;

class Timer {
	
	final Counter[] counters;	// tickers to track time

	Timer(byte freq) {	// A timer at a given clock frequency 

		// Just an array of counters with different numbers of steps,
		// initialized using Java streams for demonstration purposes
		//
		counters = IntStream // Hz, 01s, 10s, 01m, 10m
					.of(freq, 10, 6, 10, 6) 
					.mapToObj(Counter::new)
					.toArray(Counter[]::new);

	}

	 void set(byte key) { 		// set clock; assumes key is a decimal digit 
		
		counters[0].set(key);	// set clock tick counter to new digit

		for (int i = counters.length; --i > 0; )	// shift all digits

			counters[i].set(counters[i-1].now());
		
		counters[0].clear(); 	// clear clock tick counter
	}

	// set remaining time mm:ss+(ticks) to 00:00+(00)
	void clear() { for (Counter c : counters) c.clear(); } 
	
	boolean tick() {	// count down 1 clock tick; return false if timer expires
		
		for (Counter c : counters) if (c.tick()) return true; 
		
		this.clear(); 

		return false; 
	}
		
	int now() {			// clock ticks remaining till expiry
		
		int ticks = 0;
		
		for (int i = counters.length; i-- > 0; ticks += counters[i].now())
			ticks *= counters[i].steps();
		
		return ticks;
	}

	void setString(String t) { 		// set timer from mm:ss
		
		for (char d : t.toCharArray())
			if (d != ':')
				this.set(Byte.parseByte(String.valueOf(d)));
	}

	byte frequency() { return counters[0].steps(); }	// ticks per second	
	
	public String toString() { 		// show timer as mm:ss
		String r = "";
				
		for (int i = counters.length; --i > 0; r += counters[i])
			if (i == 2) r += ":";

		return r;
	}
}