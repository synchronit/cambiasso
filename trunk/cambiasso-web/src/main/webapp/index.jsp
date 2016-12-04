<!DOCTYPE html>
<%@ page import="com.cambiasso.main.*,java.util.Locale,java.util.List,java.util.Collections,java.util.Map,java.util.Set,java.util.SortedSet" %>
<%@ taglib  uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
 
<html  xmlns="http://www.w3.org/1999/xhtml" lang="en" xml:lang="en">
<head>

		<link href='http://fonts.googleapis.com/css?family=Cookie' rel='stylesheet' type='text/css'>

        <script src="js/jquery-1.11.3.min.js"></script>

<style>
/* Removes Chrome blue border */
*:focus {
	outline: none;
}

#converter {
    text-align: center;
}

#title {
	display: block;
	margin-left: auto;
	margin-right: auto;
	margin-top: 3%;
	margin-bottom: 5%;
}

select {
	display: block;
	margin-left: auto;
	margin-right: auto;
	margin-bottom: 5px;
   background: transparent;
   padding: 5px 5px 5px 5px;
   font-size: 1.5em;
   border: 0px;
   -webkit-appearance: none;
   -moz-appearance: none;
   appearance: none;
   -webkit-border-radius: 10px;
   -moz-border-radius: 10px;
   border-radius: 10px;

} 

#savings {
	margin-top: 2%;
	display: none;
	font: 400 30px/0.8 'Cookie', Helvetica, sans-serif;
	text-shadow: 4px 4px 3px rgba(0,0,0,0.1); 
    -ms-transform: rotate(-10deg); /* IE 9 */
    -webkit-transform: rotate(-10deg); /* Safari */
    transform: rotate(-10deg);}

select:hover {
	border: 1px solid grey;
   -webkit-box-shadow: 2px 2px 7px grey; 
}

/*target Internet Explorer 9 and Internet Explorer 10:*/
@media screen and (min-width:0\0) { 
    select {
        background:none;
        padding: 5px;
    }
}
.amount {
	display: block;
	margin-left: auto;
	margin-right: auto;
}
#fromCurrency {
	float: left;
	width: 50%;
}
#toCurrency {
	float: left;
	width: 50%;
}

.button {
	background-color: #3c948b;
    border: none;
    color: white;
    padding: 15px 32px;
    text-align: center;
    text-decoration: none;
    display: inline-block;
    margin: 4px 2px;
    cursor: pointer;
	font-size: 1.5em;
	-webkit-border-radius: 5px;
	-moz-border-radius: 5px;
	border-radius: 5px;
}
.button:hover {
    background-color: #33b0a3;
}

.currencyQuantity {
	display: block;
	margin-left: auto;
	margin-right: auto;
    border: 0px;
    font-size: 3em;
    text-align: center;
}

.currencyQuantity :hover {
    border: 1px;
}

</style>

<script>
	function synchronize(select)
	{
		if (select.id == "convertCurrency")
			synchronizeConvertInto();
		else
			synchronizeIntoConvert();

		refreshResult();
	}

	function synchronizeConvertInto()
	{
		if ( $("#convertCurrency").val() == "Convertir USD")
			 $("#intoCurrency").val("en Pesos");
		if ( $("#convertCurrency").val() == "Convertir Pesos")
			 $("#intoCurrency").val("en USD");
	}

	function synchronizeIntoConvert()
	{
		if ( $("#intoCurrency").val() == "en Pesos" )
			 $("#convertCurrency").val("Convertir USD");
		if ( $("#intoCurrency").val() == "en USD" )
			 $("#convertCurrency").val("Convertir Pesos");
	}

	<%

		Locale locale = Utils.getLocale();
		
		List<FXPrice> fxPrices = Utils.getFxPrices();
		
		FXPrice usdQuote = fxPrices.get(0); 
		String currency = usdQuote.getCurrency();
		float buyPrice = usdQuote.getBuy();
		float sellPrice = usdQuote.getSell();
		float midPrice = (buyPrice + sellPrice) / 2;
		
	%>

	var midPrice = <%= midPrice %>;
	var buyPrice = <%= buyPrice %>;
	var sellPrice = <%= sellPrice %>;

	function getInitialAmount() {
		return parseFloat( $("#fromQty").val().replace(".","").replace(",",".") );
	}

	function getFinalAmount() {
		return parseFloat( $("#toQty"  ).val().replace(".","").replace(",",".") );
	}
	
	var savingsLink = " <br/><small><a href=#>¿quieres saber c&oacute;mo funciona?</a></small>";

	function showSavings() 
	{
		var savings = calculateSavings();
	}
	
	function calculateSavings()
	{
		var savings = 0;

		if ( $("#convertCurrency").val() == "Convertir USD")
		{
			var initialAmount = getInitialAmount();
			var marketPrice = (initialAmount * buyPrice);
			var ourPrice = ((initialAmount * midPrice) * 99) / 100;
			savings = ourPrice - marketPrice;
			savings = savings.toFixed(2);

			$("#savings").html("Genial! Al convertir ahora, obtienes $ "+savings+" más!"+savingsLink);
		}

		if ( $("#convertCurrency").val() == "Convertir Pesos")
		{
			var finalAmount = getFinalAmount();
			var marketPrice = (finalAmount * sellPrice);
			var ourPrice = ((finalAmount * midPrice) * 101) / 100;
			savings = marketPrice - ourPrice;
			savings = savings.toFixed(2);

			$("#savings").html("Genial! Al convertir ahora, ahorras $ "+savings+" "+savingsLink);
		}

		$("#savings").show();

		return savings;
	}

	function refreshAmount()
	{
		var finalAmount = getFinalAmount();
		var result = 0;
		
		if ( $("#convertCurrency").val() == "Convertir USD")
			result = ((finalAmount / midPrice) * 99) / 100;

		if ( $("#convertCurrency").val() == "Convertir Pesos")
			result = ((finalAmount * midPrice) * 99) / 100;

		$("#fromQty").val( result.toLocaleString('de-DE', {minimumFractionDigits: 2, maximumFractionDigits: 2} ) );

		return result;
	}

	function refreshResult()
	{
		var initialAmount = getInitialAmount();
		var result = 0;
		
		if ( $("#convertCurrency").val() == "Convertir USD")
			result = ((initialAmount * midPrice) * 99) / 100;

		if ( $("#convertCurrency").val() == "Convertir Pesos")
			result = ((initialAmount / midPrice) * 99) / 100;

		$("#toQty").val( result.toLocaleString('de-DE', {minimumFractionDigits: 2, maximumFractionDigits: 2} ) );

		return result;
	}
	
</script>

</head>

<body>
	<h3>hello test!</h3>
	<img id="title" src="img/cambiasso.png"/>
	<div id="converter">
		<div id="fromCurrency">
			<div id="fromTitle">
				<select id="convertCurrency"
						onmouseover="this.size=2"
						onmouseout="this.size=1" 
						onchange="this.size=1; synchronize(this);">		
					<option selected>Convertir USD</option>
					<option>Convertir Pesos</option>
				</select>
			</div>
			<div id="fromQtyDiv">
				<input id="fromQty" type="text" class="currencyQuantity"  oninput="refreshResult()" value="1.000,00"/>
			</div>
		</div>
		<div id="toCurrency">
			<div id="toTitle">
				<select id="intoCurrency"
						onmouseover="this.size=2"
						onmouseout="this.size=1" 
						onchange="this.size=1; synchronize(this);">		
					<option selected>en Pesos</option>
					<option>en USD</option>
				</select>
			</div>
			<div id="toQtyDiv">
				<input id="toQty" type="text" class="currencyQuantity"  oninput="refreshAmount()" value="<%= String.format(locale,"%,.2f", midPrice * 1000 * 99 / 100 ) %>"/>
			</div>
		</div>

		<div id="buttonMessage" onmouseleave="$('#savings').hide();" >		
			<input type="button" class="button" value="cambiasso!" onmouseover="showSavings();" >
 
	 		<div id="savings"></div>
 		</div>
 		
	</div>

 	<div style="position:absolute; top:0px; left:30px; color:white;">
 	  <p>Moneda: <%= currency %></p>
 	  <p>Compra: <%= buyPrice %></p>
 	  <p>Venta.: <%= sellPrice %></p>
 	  <p>Media.: <%= midPrice %></p>
	</div>
	 
</body>

</html>