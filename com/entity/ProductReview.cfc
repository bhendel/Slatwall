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
component displayname="Product Review" entityname="SlatwallProductReview" table="SlatwallProductReview" persistent="true" output="false" accessors="true" extends="BaseEntity" {
	
	// Persistent Properties
	property name="productReviewID" ormtype="string" length="32" fieldtype="id" generator="uuid" unsavedvalue="" default="";
	property name="activeFlag" ormtype="boolean";
	property name="reviewerName" validateRequired="true" ormtype="string";
	property name="review" validateRequired="true" ormtype="string" length="4000" hint="HTML Formated review of the Product";
	property name="reviewTitle" ormtype="string";
	property name="rating" ormtpe="int";

	// Related Object Properties (many-to-one)
	property name="product" validateRequired="true" cfc="Product" fieldtype="many-to-one" fkcolumn="productID";
	property name="account" cfc="Account" fieldtype="many-to-one" fkcolumn="accountID";
	
	// Audit properties
	property name="createdDateTime" ormtype="timestamp";
	property name="createdByAccount" cfc="Account" fieldtype="many-to-one" fkcolumn="createdByAccountID" constrained="false";
	property name="modifiedDateTime" ormtype="timestamp";
	property name="modifiedByAccount" cfc="Account" fieldtype="many-to-one" fkcolumn="modifiedByAccountID" constrained="false";
	
	public any function init() {
		setActiveFlag(0);
		
		if(isNull(variables.reviewTitle)) {
			variables.reviewTitle = "";
		}
		if(isNull(variables.rating)) {
			variables.rating = 0;
		}
		
		return super.init();
	}
	
	/******* Association management methods for bidirectional relationships **************/
	
    // Product (many-to-one)
	public void function setProduct(required any product) {
	   variables.product = arguments.product;
	   if(isNew() or !arguments.product.hasProductReview(this)) {
	       arrayAppend(arguments.product.getProductReviews(),this);
	   }
	}
	
	public void function removeProduct(required any product) {
       var index = arrayFind(arguments.product.getProductReviews(),this);
       if(index > 0) {
           arrayDeleteAt(arguments.product.getProductReviews(),index);
       }    
       structDelete(variables,"product");
    }
    
    // Account (many-to-one)
	public void function setAccount(required any account) {
	   variables.account = arguments.account;
	   if(isNew() or !arguments.account.hasProductReview(this)) {
	       arrayAppend(arguments.account.getProductReviews(),this);
	   }
	}
	
	public void function removeAccount(required any account) {
       var index = arrayFind(arguments.account.getProductReviews(),this);
       if(index > 0) {
           arrayDeleteAt(arguments.account.getProductReviews(),index);
       }
       structDelete(variables,"account");
    }
	
	/************   END Association Management Methods   *******************/
	
	
	// Event Handler Methods	
	public void function preInsert(){
		super.preInsert(argumentcollection=arguments);
		
		if( isNull(variables.account) && !isNull(getService("SessionService").getCurrentAccount()) ) {
			setAccount(getService("SessionService").getCurrentAccount());
		}
	}
	
}
