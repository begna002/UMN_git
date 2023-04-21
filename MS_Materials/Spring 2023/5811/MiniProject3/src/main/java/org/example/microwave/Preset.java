package org.example.microwave;

public class Preset {
	private String name;			// soup, casserole, pizza, etc..
	private String timeToCook;		// mm:ss
	private int powerLevel;			// 1...10
	
	public Preset(String name, String mm_ss, int powerLevel) {
		super();
		this.name = name;
		this.timeToCook = mm_ss;
		this.powerLevel = powerLevel;
	}

	public String getName() {
		return name;
	}

	@Override
	public String toString() {
		return  name + ": " + timeToCook + " @ " + powerLevel + "0%";
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getTimeToCook() {
		return timeToCook;
	}

	public void setTimeToCook(String mm_ss) {
		this.timeToCook = mm_ss;
	}

	public int getPowerLevel() {
		return powerLevel;
	}

	public void setPowerLevel(int powerLevel) {
		this.powerLevel = powerLevel;
	}	
}