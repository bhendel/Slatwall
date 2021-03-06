/*

    Slatwall - An e-commerce plugin for Mura CMS
    Copyright (C) 2011 ten24, LLC

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
    
    Linking this library statically or dynamically with other modules is
    making a combined work based on this library.  Thus, the terms and
    conditions of the GNU General Public License cover the whole
    combination.
 
    As a special exception, the copyright holders of this library give you
    permission to link this library with independent modules to produce an
    executable, regardless of the license terms of these independent
    modules, and to copy and distribute the resulting executable under
    terms of your choice, provided that you also meet, for each linked
    independent module, the terms and conditions of the license of that
    module.  An independent module is a module which is not derived from
    or based on this library.  If you modify this library, you may extend
    this exception to your version of the library, but you are not
    obligated to do so.  If you do not wish to do so, delete this
    exception statement from your version.

Notes:

*/

component accessors="true" output="false" displayname="UPS" implements="Slatwall.integrationServices.ShippingInterface" {

	// Custom Properties that need to be set by the end user
	property name="apiKey" validateRequired displayname="API Key" type="string";
	property name="username" displayname="UPS Username" type="string";
	property name="password" displayname="UPS Password" type="string" editType="password";
	property name="testingFlag" displayname="Testing Mode" type="boolean";
	property name="shipperNumber" displayname="Shipper Number" type="string";
	property name="shipFromCity" displayname="Ship From City" type="string";
	property name="shipFromStateCode" displayname="Ship From State Code" type="string";
	property name="shipFromPostalCode" displayname="Ship From Postal Code" type="string";
	property name="shipFromCountryCode" displayname="Ship From Country Code" type="string";
	property name="pickupTypeCode" displayname="Pickup Type Code (advanced optional)" type="string";
	property name="customerClassificationCode" displayname="Customer Classification Code (advanced optional)" type="string";
	
	variables.testRateURL = "https://wwwcie.ups.com/ups.app/xml/Rate";
	variables.liveRateURL = "https://www.ups.com/ups.app/xml/Rate";
	
	// Variables Saved in this application scope, but not set by end user
	variables.shippingMethods = {};

	public any function init() {
		setAPIKey("");
		setUsername("");
		setPassword("");
		setTestingFlag(true);
		setShipperNumber("");
		setShipFromCity("");
		setShipFromStateCode("");
		setShipFromPostalCode("");
		setShipFromCountryCode("");
		
		variables.shippingMethods = {
			01="UPS Next Day Air",
			02="UPS 2nd Day Air",
			03="UPS Ground",
			07="UPS Worldwide Express",
			08="UPS Worldwide Express Expedited",
			11="UPS Standard",
			12="UPS 3 Day Select",
			13="UPS Next Day Air Saver",
			14="UPS Next Day Air Early A.M.",
			54="UPS Worldwide Express Plus",
			59="UPS 2nd Day Air A.M.",
			65="UPS Saver"
		};
		
		// Set the defaults for these codes
		setPickupTypeCode(03);
		setCustomerClassificationCode(04);
		
		return this;
	}
	
	public struct function getShippingMethods() {
		return variables.shippingMethods;
	}
	
	public string function getTrackingURL() {
		return "http://wwwapps.ups.com/WebTracking/track?loc=en_US&track.x=Track&trackNums=${trackingNumber}";
	}
	
	public Slatwall.com.utility.fulfillment.ShippingRatesResponseBean function getRates(required Slatwall.com.utility.fulfillment.ShippingRatesRequestBean requestBean) {
		var responseBean = new Slatwall.com.utility.fulfillment.ShippingRatesResponseBean();
		
		// Insert Custom Logic Here
		var totalItemsWeight = 0;
		var totalItemsValue = 0;
		
		// Loop over all items to get a price and weight for shipping
		for(var i=1; i<=arrayLen(arguments.requestBean.getShippingItemRequestBeans()); i++) {
			if(isNumeric(arguments.requestBean.getShippingItemRequestBeans()[i].getWeight())) {
				totalItemsWeight +=	arguments.requestBean.getShippingItemRequestBeans()[i].getWeight() * arguments.requestBean.getShippingItemRequestBeans()[i].getQuantity();
			}
			 
			totalItemsValue += arguments.requestBean.getShippingItemRequestBeans()[i].getValue() * arguments.requestBean.getShippingItemRequestBeans()[i].getQuantity();
		}
		
		if(totalItemsWeight < 1) {
			totalItemsWeight = 1;
		}
		
		// Build Request XML
		var xmlPacket = "";
		
		savecontent variable="xmlPacket" {
			include "RatesRequestTemplate.cfm";
        }
        
        // Setup Request to push to UPS
        
        var httpRequest = new http();
        httpRequest.setMethod("POST");
		httpRequest.setPort("443");
		httpRequest.setTimeout(45);
		
		if(variables.testingFlag) {
			httpRequest.setUrl(variables.testRateURL);
		} else {
			httpRequest.setUrl(variables.liveRateURL);
		}
		
		httpRequest.setResolveurl(false);
		httpRequest.addParam(type="xml", name="data",value="#trim(xmlPacket)#");
		
		var xmlResponse = XmlParse(REReplace(httpRequest.send().getPrefix().fileContent, "^[^<]*", "", "one"));
		
		var responseBean = new Slatwall.com.utility.fulfillment.ShippingRatesResponseBean();
		responseBean.setData(xmlResponse);
		
		if(isDefined('xmlResponse.Fault')) {
			responseBean.addMessage(messageCode="0", messageType="Unexpected", message="An unexpected communication error occured, please notify system administrator.");
			// If XML fault then log error
			responseBean.getErrorBean().addError("unknown", "An unexpected communication error occured, please notify system administrator.");
		} else {
			// Log all messages from FedEx into the response bean
			for(var i=1; i<=arrayLen(xmlResponse.RatingServiceSelectionResponse.Response); i++) {
				responseBean.addMessage(
					messageCode=xmlResponse.RatingServiceSelectionResponse.Response[i].ResponseStatusCode.xmltext,
					message=xmlResponse.RatingServiceSelectionResponse.Response[i].ResponseStatusDescription.xmltext
				);
				if(structKeyExists(xmlResponse.RatingServiceSelectionResponse.Response[i], "Error")) {
					responseBean.addMessage(
						messageCode=xmlResponse.RatingServiceSelectionResponse.Response[i].Error.ErrorCode.xmltext,
						messageType=xmlResponse.RatingServiceSelectionResponse.Response[i].Error.ErrorSeverity.xmltext,
						message=xmlResponse.RatingServiceSelectionResponse.Response[i].Error.ErrorDescription.xmltext
					);
					responseBean.getErrorBean().addError(
						xmlResponse.RatingServiceSelectionResponse.Response[i].Error.ErrorCode.xmltext,
						xmlResponse.RatingServiceSelectionResponse.Response[i].Error.ErrorDescription.xmltext
					);
				}
			}
			
			if(!responseBean.hasErrors()) {
				for(var i=1; i<=arrayLen(xmlResponse.RatingServiceSelectionResponse.RatedShipment); i++) {
					responseBean.addShippingMethod(
						shippingProviderMethod=xmlResponse.RatingServiceSelectionResponse.RatedShipment[i].Service.code.xmlText,
						totalCharge=xmlResponse.RatingServiceSelectionResponse.RatedShipment[i].TotalCharges.MonetaryValue.xmlText
					);
				}
			}
		}

		return responseBean;
	}
	
	
}
