package com.cambiasso.main;

import java.util.ArrayList;
import java.util.List;
import java.util.Locale;

import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.nodes.Element;
import org.jsoup.select.Elements;

public class Utils {
	
	static Locale locale = new Locale.Builder().setLanguage("es").setRegion("UY").build();
	static List<FXPrice> fxPrices;

	public static Locale getLocale() {
		return locale;
	}
	
	public static List<FXPrice> getFxPrices() {

		fxPrices = new ArrayList<FXPrice>();

		String url = "http://www.bancorepublica.com.uy/c/portal/render_portlet?p_l_id=123137&p_p_id=ExchangeLarge_WAR_ExchangeRate5121_INSTANCE_P2Af&p_p_lifecycle=0&p_p_state=normal&p_p_mode=view&p_p_col_id=column-2&p_p_col_pos=0&amp;p_p_col_count=1&currentURL=%2Fweb%2Fguest%2Finstitucional%2Fcotizaciones";
		
		try 
		{
			Document doc = Jsoup.connect(url)
					.userAgent("Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/52.0.2743.116 Safari/537.36")
					.followRedirects(true)
					.get();

			String currency = "Dólar";
			float buyPrice = 0;
			float sellPrice = 0;
			
			// BuyPrice
			Elements elements = doc.select(":matches("+currency+"$) + td");
			for (Element e : elements)
			{
				buyPrice = Float.parseFloat(e.text());
			}
			
			// SellPrice
			elements = doc.select(":matches("+currency+"$) + td + td");
			for (Element e : elements)
			{
				sellPrice = Float.parseFloat(e.text());
			}
			
			FXPrice fxPrice = new FXPrice (currency, buyPrice, sellPrice);
			fxPrices.add(fxPrice);

		} catch (Exception e) {
			System.out.println("Error : "+e.toString());
	    }

		return fxPrices;
	}

}
