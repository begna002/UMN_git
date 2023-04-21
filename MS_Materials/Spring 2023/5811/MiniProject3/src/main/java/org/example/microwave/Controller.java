package org.example.microwave;

import java.util.stream.Collectors;

import java.util.stream.IntStream;

public class Controller {

	enum Mode {PROG, HOLD, COOK };		// possible modes in operation
	
	enum Prog {TIMER, PRESET, POWER};	// what is being programmed
		
	private Mode mode = Mode.PROG;		// current mode oven is in
	
	private Prog prog = Prog.TIMER;		// by default timer is programmed
		
	private final Timer timer;			// count-down timer for cooking
	
	private final Preset[] presets;		// pre-programmed for quick select
	
	private int powerLevel = 10;		// max power level
	
	private boolean doorOpen = true;	// fail-safe at start-up

	
	public Controller(int freq, Preset ...presets) {

		this.timer = new Timer((byte)freq); // timer at a certain tick frequency
				
		this.presets = presets;				// load pre-programmed quick settings
		
		this.reset();						// start with default configuration
	}
	
	private void reset() { 	// default configuration:
		runDevice(0);		// no cooking,
		mode = Mode.PROG;	// in programming mode,
		powerLevel = 10;	// power level at max,
		timer.clear(); 		// timer zeroed out
		prog = Prog.TIMER;	// ready to enter cook time
	}

	synchronized public void pressStart() {	// start button press
		
		if (doorOpen) throw new IllegalStateException("Cannot start oven with door open");
		
		else if (mode == Mode.COOK) throw new IllegalStateException("Already cooking");
		
		else mode = Mode.COOK;

	}
		
	 public void pressClear() { 	// stop/clear button press
		
		if (mode == Mode.COOK) mode = Mode.HOLD; 
		
		else reset(); 
	}

	private void checkProg() {	// check called when programming keys are pressed
		
		if (mode != Mode.PROG) 
			throw new IllegalStateException("Not in Programming mode");
	}
	
	// set the current programming mode
	private void setProg(Prog choice) { checkProg(); prog = choice; }
	
	// about to program power level
	synchronized public void pressPower() { setProg(Prog.POWER); }

	// about to select quick choices from pre-programmed list
	synchronized public void pressQuick() { setProg(Prog.PRESET); }

	// handles all digit presses
	synchronized public void pressDigit(int digit) {

		if (digit < 0 || digit > 9)
			throw new IllegalArgumentException(digit + " is not a valid digit");		

		final Prog entered = prog; 	// remember what we are programming

		setProg(Prog.TIMER);  		// go back to timer programming after this
		
		switch(entered) {
		
		case POWER: setPowerLevel(digit == 0 ? 10 : digit); break;
		
		case PRESET: timer.clear(); presetPressed(digit); break;
		
		case TIMER: timer.set((byte)digit); break;
		
		}
	}
	
	// handles preset selection
	synchronized public void presetPressed(int preset) {
		
		if (preset < 1 || preset > presets.length) {
			throw new IllegalArgumentException("Preset "  + preset + " out of range: 1.." + presets.length);
		} 
		
		else if (mode != Mode.PROG) {
			throw new IllegalStateException("Not in Programming mode");
		}
				
		Preset p = presets[preset - 1]; 

		timer.setString(p.getTimeToCook());
		
		setPowerLevel(p.getPowerLevel());
	}

	synchronized public void openDoor() { stopCooking(); setOpen(true); }
	
	public void closeDoor() {setOpen(false); }

	private void stopCooking() { if (mode == Mode.COOK) mode = Mode.HOLD; }
	
	private void setOpen(boolean open) {	// handles door state
		
		if (doorOpen == open) 
			throw new IllegalStateException("Door is already " + (open ? "open": "closed"));		
	
		doorOpen = open;

		assert !(doorOpen && mode == Mode.COOK);	// safety check should not fail
	}
	
	private void setPowerLevel(int powerLevel) { // handles power level setting
		
		if (powerLevel < 1 && powerLevel > 10) 
			throw new IllegalArgumentException("power level out of range");		
		
		else this.powerLevel = powerLevel; 
	}
	
	synchronized public void tick() {	// the heart beat routine
		
		if (mode != Mode.COOK) return; // do nothing if not cooking
		
		// power the cooking element if time is still ticking else done
		if (timer.tick()) runDevice(powerLevel); else reset();

	}
		
	private int percentEnergized = 0; 	// current operating power level as a percentage
	
	private void runDevice(int level) { /* code to power magnetron at 10Xlevel % */ 

		assert level == 0 || mode == Mode.COOK; 	// safety check should not fail
		
		if (percentEnergized != 10*level)
			System.err.println("Device power set to " + (percentEnergized = 10*level) +"%" );
	}

	
	public Preset preset(int i) { return presets[i]; }
	
	public int getPowerLevel() { return powerLevel; }
	
	public boolean isDoorOpen() { return doorOpen; }

	public int ticksRemaining() { return timer.now(); } // time left
		
	public int getTickRateInHz() { return timer.frequency(); }	// clock rate
	
	public String toString() {	// descriptive output
		return  "<<" + mode 
				+ (mode == Mode.PROG ? " " + prog : "") + ">> [" 
				+ timer
				+ "] Power level set to " + powerLevel
				+ ", door is " + (doorOpen ? "open" : "closed")
				+ "\nPresets: "
				+ IntStream
					.range(0, presets.length)
					.mapToObj(i -> String.format("[%d]%s", 1+i, presets[i]))
					.collect(Collectors.joining(" | "));
	}
}