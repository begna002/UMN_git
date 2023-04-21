package org.example.microwave;

// Step down counter with roll-over at zero

public class Counter {

	private final byte steps;	// total number of steps
	
	private byte count;			// steps remaining to reach zero
	
	Counter(byte steps) {		// set total steps and none remaining
	
		this.steps = steps; 
		
		clear(); 
	};
	
	Counter(int steps) { this((byte)steps); };	// byte passed as int

	void set(byte start) { count = start; }		// set remaining steps 

	void clear() { set((byte)0); }	// mark no remaining steps 
	
	byte now() { return count; } 	// presently remaining steps
	
	byte steps() { return steps; }	// number of steps in this counter
	
	boolean tick() {	// step down 1; return false on roll over
		
		final boolean rollover = count == 0;
		
		if (rollover) count = steps;  
		
		--count;
		
		return !rollover;
	}
	
	public String toString() { return Byte.toString(count); };
}