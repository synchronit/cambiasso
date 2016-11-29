package com.cambiasso.main;

public class FXPrice {

	String currency;
	float  buy;
	float  sell;

	private FXPrice() {}
	
	public FXPrice(String currency, float buy, float sell) {
		this.currency = currency;
		this.buy = buy;
		this.sell = sell;
	}
	
	public String getCurrency() {
		return currency;
	}
	public float getBuy() {
		return buy;
	}
	public float getSell() {
		return sell;
	}
	
}
