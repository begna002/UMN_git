package org.example.microwave;

import java.util.Scanner;

public class Microwave {

	public static final int hertz = 10; // clock rate
	
	public static final Preset[] preProg = { // quick selections
			new Preset("Bread", "1:30", 5),
			new Preset("Soup",  "2:00", 7),
			new Preset("Pizza", "3:00", 10)
		};
	
	public static void main(String[] args) {

		// controller with given clock rate and presets
		final Controller unit = new Controller(hertz, preProg);
			
		// Instantiate a thread for simulating clock ticks at given frequency
		final Thread ticker = new Thread() {
			public void run() {
				try {
					for(;; sleep(1000/hertz)) unit.tick();
				} catch(InterruptedException ex) {}
			}
		};
		
		ticker.run();	// spawn off thread to run concurrently with the main thread
		
		// read-eval-print-loop
		REPL: for(Scanner input = new Scanner(System.in); ; System.out.println()) { 
			
			System.out.println(unit);
			
			System.out.print("[0]...[9]  [C]lose  [O]pen  [P]ower  p[R]eset  [S]tart  s[T]op  e[X]it  [?]: ");
			
			try {
				char choice  = Character.toUpperCase(input.next().charAt(0));
				
				switch (choice) {
				case 'C' : unit.closeDoor();   break;
				case 'O' : unit.openDoor();    break;
				case 'P' : unit.pressPower();  break;
				case 'R' : unit.pressQuick();  break;
				case 'S' : unit.pressStart();  break;
				case 'T' : unit.pressClear();  break;
				case 'X' : ticker.interrupt(); input.close(); break REPL;
				case '?' : break;
				default  : unit.pressDigit(Character.getNumericValue(choice)); // assume digit :
				}
				
			} catch (Exception e) {
				System.err.println("Error: " + e.getMessage());
			}
		}	
	}
}