﻿<!---

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

--->

<cfoutput>
	<div class="vendorAddressDisplay">
		<dl class="twoColumn">
			
			<!---
			property name="addressID" ormtype="string" length="32" fieldtype="id" generator="uuid" unsavedvalue="" default="";
	property name="name" ormtype="string";
	property name="company" ormtype="string";
	property name="phone" ormtype="string";
	property name="streetAddress" ormtype="string";
	property name="street2Address" ormtype="string";
	property name="locality" ormtype="string";
	property name="city" ormtype="string";
	property name="stateCode" ormtype="string";
	property name="postalCode" ormtype="string";
	property name="countryCode" ormtype="string"
			--->
			
			<input type="hidden" name="vendorAddresses[1].vendorAddressId" value="#rc.vendorAddress.getVendorAddressId()#"/>
			<cf_SlatwallAddressDisplay address="#rc.vendorAddress.getAddress()#" edit="#rc.edit#" fieldNamePrefix="vendorAddresses[1].address." />
			
			<!---<cf_SlatwallPropertyDisplay object="#rc.vendorAddress.getAddress()#" property="streetAddress" fieldName="vendorAddresses[1].addresses[1].streetAddress" edit="#rc.edit#" />--->
			<!--- More to come! --->
		</dl>
	</div>
</cfoutput>