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
component displayname="Product" entityname="SlatwallProduct" table="SlatwallProduct" persistent="true" extends="BaseEntity" {
	
	// Persistent Properties
	property name="productID" ormtype="string" length="32" fieldtype="id" generator="uuid" unsavedvalue="" default="";
	property name="activeFlag" ormtype="boolean" hint="As Products Get Old, They would be marked as Not Active";
	property name="filename" ormtype="string" validateRequired="true" unique="true" hint="This is the name that is used in the URL string";
	property name="template" ormtype="string" hint="This is the Template to use for product display";
	property name="productName" ormtype="string" notNull="true" validateRequired="true" hint="Primary Notation for the Product to be Called By";
	property name="productCode" ormtype="string" unique="true" validateRequired="true" hint="Product Code, Typically used for Manufacturer Coded";
	property name="productDescription" ormtype="string" length="4000" hint="HTML Formated description of the Product";
	property name="manufactureDiscontinuedFlag" default="false"	ormtype="boolean" hint="This property can determine if a product can still be ordered by a vendor or not";
	property name="publishedFlag" ormtype="boolean" default="false" hint="Should this product be sold on the web retail Site";
	property name="trackInventoryFlag" ormtype="boolean";
	property name="callToOrderFlag" ormtype="boolean";
	property name="allowShippingFlag" ormtype="boolean";
	property name="allowPreorderFlag" ormtype="boolean";
	property name="allowBackorderFlag" ormtype="boolean";
	property name="allowDropshipFlag" ormtype="boolean";
	property name="sortOrder" ormtype="integer";
	
	// Related Object Properties (many-to-one)
	property name="brand" validateRequired="true" cfc="Brand" fieldtype="many-to-one" fkcolumn="brandID";
	property name="productType" validateRequired="true" cfc="ProductType" fieldtype="many-to-one" fkcolumn="productTypeID";
	property name="defaultSku" cfc="Sku" fieldtype="many-to-one" fkcolumn="defaultSkuID";
	
	// Related Object Properties (one-to-many)
	property name="skus" type="array" cfc="Sku" singularname="Sku" fieldtype="one-to-many" fkcolumn="productID" cascade="all-delete-orphan" inverse="true";
	property name="images" type="array" cfc="ProductImage" singularname="ProductImage" fieldtype="one-to-many" fkcolumn="productID" cascade="all-delete-orphan";
	property name="productContent" cfc="ProductContent" fieldtype="one-to-many" fkcolumn="productID" cascade="all-delete-orphan" inverse="true";
	property name="productCategories" singularname="ProductCategory" cfc="ProductCategory" fieldtype="one-to-many" fkcolumn="productID" cascade="all-delete-orphan" inverse="true";
	property name="attributeValues" singularname="attributeValue" cfc="ProductAttributeValue" fieldtype="one-to-many" fkcolumn="productID" cascade="all-delete-orphan" inverse="true";
	property name="attributeSetAssignments" singularname="attributeSetAssignment" cfc="ProductAttributeSetAssignment" fieldtype="one-to-many" fkcolumn="productID" cascade="all-delete-orphan" inverse="true";
	property name="productRelationships" singlularname="productRelationship" cfc="ProductRelationship" fieldtype="one-to-many" fkcolumn="productID" cascade="all-delete-orphan" inverse="true";
	property name="productReviews" singlularname="productReview" cfc="ProductReview" fieldtype="one-to-many" fkcolumn="productID" cascade="all-delete-orphan" inverse="true";
	
	// Related Object Properties (many-to-many)
	property name="promotionRewards" singularname="promotionReward" cfc="PromotionRewardProduct" fieldtype="many-to-many" linktable="SlatwallPromotionRewardProductProduct" fkcolumn="productID" inversejoincolumn="promotionRewardID" cascade="all" inverse="true";

	// Remote properties
	property name="remoteID" ormtype="string";
	
	// Audit properties
	property name="createdDateTime" ormtype="timestamp";
	property name="createdByAccount" cfc="Account" fieldtype="many-to-one" fkcolumn="createdByAccountID" constrained="false";
	property name="modifiedDateTime" ormtype="timestamp";
	property name="modifiedByAccount" cfc="Account" fieldtype="many-to-one" fkcolumn="modifiedByAccountID" constrained="false";
	
	// Non-Persistent Properties
	property name="title" type="string" persistent="false";
	property name="onTermSaleFlag" type="boolean" persistent="false";
	property name="onClearanceSaleFlag" type="boolean" persistent="false";
	property name="dateFirstReceived" type="date" persistent="false";
	property name="dateLastReceived" type="date" persistent="false";
	property name="livePrice" type="numeric" persistent="false";
	property name="price" type="numeric" validateRequired="true" validateNumeric="true" persistent="false";
	property name="listPrice" type="numeric" validateRequired="true" validateNumeric="true" persistent="false";
	property name="shippingWeight" validateRequired="true" type="numeric" validateNumeric="true" persistent="false";
	property name="qoh" type="numeric" persistent="false" hint="quantity on hand" ;
	property name="qc" type="numeric" persistent="false" hint="quantity committed" ;
	property name="qexp" type="numeric" persistent="false" hint="quantity expected" ;
	property name="qia" type="numeric" persistent="false" hint="quantity immediately available";
	property name="qea" type="numeric" persistent="false" hint="quantity expected available";
	
	// Calculated Properties
	property name="orderedFlag" type="boolean" formula="SELECT count(soi.skuID) from SlatwallOrderItem soi where soi.skuID in (SELECT ss.skuID from SlatwallSku ss INNER JOIN SlatwallProduct sp on ss.productID = sp.productID where ss.productID=productID)";
	
	public Product function init(){
	   // set default collections for association management methods
	   if(isNull(variables.activeFlag)) {
	       variables.activeFlag = 1;
	   }
	   if(isNull(variables.ProductContent)) {
	       variables.ProductContent = [];
	   }
	   if(isNull(variables.ProductCategories)) {
	       variables.ProductCategories = [];
	   }
	   if(isNull(variables.Skus)) {
	       variables.Skus = [];
	   }
	   if(isNull(variables.attributeValues)) {
	       variables.attributeValues = [];
	   }	   
	   if(isNull(variables.attributeSetAssignments)) {
	       variables.attributeSetAssignments = [];
	   }
	   if(isNull(variables.promotionRewards)) {
	       variables.promotionRewards = [];
	   }
	   if(isNull(variables.productRelationships)) {
	       variables.productRelationships = [];
	   }
	   if(isNull(variables.productReviews)) {
	       variables.productReviews = [];
	   }
	   return Super.init();
	}

	// Related Object Helpers
	
	public string function getBrandName() {
		if( structKeyExists(variables,"brand") ) {
			return getBrand().getBrandName();
		}
		else {	
			return "";
		}
	}
	
	public any function getBrandOptions() {
		if(!structKeyExists(variables, "brandOptions")) {
			var smartList = new Slatwall.org.entitySmartList.SmartList(entityName="SlatwallBrand");
			smartList.addSelect(propertyIdentifier="brandName", alias="name");
			smartList.addSelect(propertyIdentifier="brandID", alias="id"); 
			smartList.addOrder("brandName|ASC");
			variables.brandOptions = smartList.getRecords();
		}
		return variables.brandOptions;
	}
	
	public any function getProductTypeOptions() {
		if(!structKeyExists(variables, "productTypeOptions")) {
			var productTypeTree = getProductTypeTree();
			var productTypeOptions = [];
			for(var i=1; i <= productTypeTree.recordCount; i++) {
				// only get the leaf nodes of the tree (those with no children)
				if( productTypeTree.childCount[i] == 0 ) {
					arrayAppend(productTypeOptions, {id=productTypeTree.productTypeID[i], name=productTypeTree.productTypeName[i], label=listChangeDelims(productTypeTree.productTypeNamePath[i], " &raquo; ")});
				}
			}
			variables.productTypeOptions = productTypeOptions;
		}
		return variables.productTypeOptions;
	}
    
    public any function getProductTypeTree() {
        return getService("ProductService").getProductTypeTree();
    }
    	
	
    public array function getSkus(boolean sorted=false) {
        if(!sorted) {
        	return variables.skus;
        } else {
        	if(isNull(variables.sortedSkus)) {
	        	variables.sortedSkus = getService("skuService").getSortedProductSkus(this);
	        }
        	return variables.sortedSkus;
        }
    }
	
	public any function getSkuByID(required string skuID) {
		var skus = getSkus();
		for(var i = 1; i <= arrayLen(skus); i++) {
			if(skus[i].getSkuID() == arguments.skuID) {
				return skus[i];
			}
		}
	}
	
	public any function getTemplateOptions() {
		if(!isDefined("variables.templateOptions")){
			variables.templateOptions = getService(service="ProductService").getProductTemplates();
		}
		return variables.templateOptions;
	}
	
	// Non-Persistent Helpers
	
	public string function getContentIDs() { 
		var contentIDs = "";
		for( var i=1; i<= arrayLen(getProductContent()); i++ ) {
			contentIDs = listAppend(contentIDs,getProductContent()[i].getContentID());
		}
		return contentIDs;
	}
	
	public string function getCategoryIDs(boolean featured=false) { 
		var categoryIDs = "";
		for( var i=1; i<= arrayLen(getProductCategories()); i++ ) {
			local.thisProductCategory = getProductCategories()[i];
			local.addID = true;
			if(arguments.featured) {
				local.addID = local.thisProductCategory.getFeaturedFlag();
			}
			if(local.addID) {
				categoryIDs = listAppend(categoryIDs,getProductCategories()[i].getCategoryID());	
			}
		}
		return categoryIDs;
	}
	
	public string function getTitle() {
		return getService("utilityService").replaceStringTemplate(template=setting('product_titleString'), object=this);
	}
	
	public string function getProductURL() {
		return $.createHREF(filename="#setting('product_urlKey')#/#getFilename()#");
	}
	
	public string function getListingProductURL(string filename=$.content('filename')) {
		return $.createHREF(filename="#arguments.filename#/#setting('product_urlKey')#/#getFilename()#");
	}
	
	public numeric function getQOH() {
		if(isNull(variables.qoh)) {
    		variables.qoh = 0;
    		if(getSetting("trackInventoryFlag")) {
	    		var skus = getSkus();
	    		for(var i = 1; i<= arrayLen(skus); i++) {
	    			variables.qoh += skus[i].getQOH();
	    		}	
    		}
    	}
    	return variables.qoh;
	}
	
	public numeric function getQC() {
		if(isNull(variables.qc)) {
    		variables.qc = 0;
    		if(getSetting("trackInventoryFlag")) {
	    		var skus = getSkus();
	    		for(var i = 1; i<= arrayLen(skus); i++) {
	    			variables.qc += skus[i].getQC();
	    		}	
    		}
    	}
    	return variables.qc;
	}
	
	public numeric function getQEXP() {
		if(isNull(variables.qexp)) {
    		variables.qexp = 0;
    		if(getSetting("trackInventoryFlag")) {
	    		var skus = getSkus();
	    		for(var i = 1; i<= arrayLen(skus); i++) {
	    			variables.qexp += skus[i].getQEXP();
	    		}	
    		}
    	}
    	return variables.qexp;
	}
	
	public numeric function getQEA() {
		return (getQOH() - getQC()) + getQEXP();
	}
	
	public numeric function getQIA() {
		return getQOH() - getQC();
	}
	
	public string function getTemplate() {
		if(!structKeyExists(variables, "template") || variables.template == "") {
			return setting('product_defaultTemplate');
		} else {
			return variables.template;
		}
	}
	
	public string function getAlternateImageDirectory() {
    	return "#$.siteConfig().getAssetPath()#/assets/Image/Slatwall/product/";	
    }
    
    public numeric function getProductRating() {
    	var totalRatingPoints = 0;
    	var averageRating = 0;
    	
    	if(arrayLen(getProductReviews())) {
	    	for(var i=1; i<=arrayLen(getProductReviews()); i++) {
	    		var totalRatingPoints += getProductReviews()[1].getRating();
	    	}
	    	averageRating = totalRatingPoints / arrayLen(getProductReviews());
    	}
    	
    	return averageRating;
    }
	
	// Persistent property helpers
	
	public string function getURLTitle() {
		return getFileName();
	}

	
	/******* Product Setting methods **************/
	
	// Generic setting accessor
	public boolean function getSetting( required string settingName ) {
		if(structKeyExists(variables,arguments.settingName)) {
			return variables[arguments.settingName];
		} else {
			return getInheritedSetting( arguments.settingName );
		}
	}	
	
	public boolean function getInheritedSetting( required string settingName ) {
		if(!isNull(getProductType())) {
			return getProductType().getSetting(arguments.settingName);
		} else {
			// so a CF error won't be thrown during validtion if the product type wasn't selected
			return setting("product_" & arguments.settingName);
		}
	}
	
	// Get source of setting
    public any function getWhereSettingDefined( required string settingName ) {
    	if(structKeyExists(variables,arguments.settingName)) {
    		return {type="Product"};
    	} else {
    		return getService("ProductService").getWhereSettingDefined( getProductType().getProductTypeID(),arguments.settingName );
    	}
    }
	
	
	/***************************************************/
	

	/******* Association management methods for bidirectional relationships **************/
	
	// Product Type (many-to-one)
	
	public void function setProductType(required ProductType ProductType) {
	   variables.productType = arguments.ProductType;
	   if(isNew() or !arguments.ProductType.hasProduct(this)) {
	       arrayAppend(arguments.ProductType.getProducts(),this);
	   }
	}
	
	public void function removeProductType(required ProductType ProductType) {
       var index = arrayFind(arguments.ProductType.getProducts(),this);
       if(index > 0) {
           arrayDeleteAt(arguments.ProductType.getProducts(),index);
       }    
       structDelete(variables,"productType");
    }
    
    // Brand (many-to-one)
	
	public void function setBrand(required Brand Brand) {
	   variables.Brand = arguments.Brand;
	   if(isNew() or !arguments.Brand.hasProduct(this)) {
	       arrayAppend(arguments.Brand.getProducts(),this);
	   }
	}
	
	public void function removeBrand(required Brand Brand) {
       var index = arrayFind(arguments.Brand.getProducts(),this);
       if(index > 0) {
           arrayDeleteAt(arguments.Brand.getProducts(),index);
       }    
       structDelete(variables,"Brand");
    }
	
	// ProductContent (one-to-many)
	
	public void function setProductContent(required array ProductContent) {
		if( !arrayIsEmpty(arguments.ProductContent) ) {
			for( var i=1; i<= arraylen(arguments.ProductContent); i++ ) {
				var thisProductContent = arguments.ProductContent[i];
				if(isObject(thisProductContent) && thisProductContent.getClassName() == "SlatwallProductContent") {
					addProductContent(thisProductContent);
				}
			}
		} 
	}
	
	public void function clearProductContent() {
		while(arraylen(getProductContent()) > 0) {
			removeProductContent(getProductContent()[1]);
		}
	}
	
	public void function addProductContent(required ProductContent ProductContent) {
	   arguments.ProductContent.setProduct(this);
	}
	
	public void function removeProductContent(required ProductContent ProductContent) {
	   arguments.ProductContent.removeProduct(this);
	}
	
	// ProductCategories (one-to-many)
	public void function clearProductCategories() {
		for( var i=1; i<= arraylen(getProductCategories()); i++ ) {
			removeProductCategory(getProductCategory()[i]);
		}
	}
	
	public void function addProductCategory(required any ProductCategory) {    
	   arguments.ProductCategory.setProduct(this);    
	}    
	    
	public void function removeProductCategory(required any ProductCategory) {    
	   arguments.ProductCategory.removeProduct(this);    
	}
	
	// Skus (one-to-many)
	
	public void function setSkus(required array Skus) {
		// first, clear existing collection
		variables.Skus = [];
		for( var i=1; i<= arraylen(arguments.Skus); i++ ) {
			var thisSku = arguments.Skus[i];
			if(isObject(thisSku) && thisSku.getClassName() == "SlatwallSku") {
				addSku(thisSku);
			}
		}
	}
	
	public void function addSku(required any Sku) {
	   arguments.Sku.setProduct(this);
	}
	
	public void function removeSku(required any Sku) {
	   arguments.Sku.removeProduct(this);
	}
	
	// attributeValues (one-to-many)
	public void function addAttribtueValue(required any attributeValue) {
	   arguments.attributeValue.setProduct(this);
	}
	
	public void function removeAttributeValue(required any attributeValue) {
	   arguments.attributeValue.removeProduct(this);
	}
	
	// productReviews (one-to-many)
	public void function addProductReview(required any productReview) {
	   arguments.productReview.setProduct(this);
	}
	
	public void function removeProductReview(required any productReview) {
	   arguments.productReview.removeProduct(this);
	}
	
	// promotionRewards (many-to-many)
	public void function addPromotionReward(required any promotionReward) {
	   arguments.promotionReward.addProduct(this);
	}
	
	public void function removePromotionReward(required any promotionReward) {
	   arguments.promotionReward.removeProduct(this);
	}
	
	/************   END Association Management Methods   *******************/

	public struct function getOptionGroupsStruct() {
		if( !structKeyExists(variables, "optionGroupsStruct") ) {
			variables.optionGroupsStruct = {};
			for(var optionGroup in getOptionGroups()){
				variables.optionGroupsStruct[optionGroup.getOptionGroupID()] = optionGroup;
			}
		}
		return variables.optionGroupsStruct;
	}
	
	public array function getOptionGroups() {
		if( !structKeyExists(variables, "optionGroups") ) {
			variables.optionGroups = [];
			var smartList = getService("OptionService").getOptionGroupSmartList();
			smartList.addFilter("options_skus_product_productID",this.getProductID());
			smartList.addOrder("sortOrder|ASC");
			variables.optionGroups = smartList.getRecords();
		}
		return variables.optionGroups;
	}
	
	public numeric function getOptionGroupCount() {
		return arrayLen(getOptionGroups());
	}
	
	// Start: Functions that delegate to the default sku
    public string function getImageDirectory() {
    	return getDefaultSku().getImageDirectory();	
    }
    
	public string function getImage(string size, numeric width, numeric height, string class, string alt, string resizeMethod="scale", string cropLocation="",numeric cropXStart=0, numeric cropYStart=0,numeric scaleWidth=0,numeric scaleHeight=0) {
		return getDefaultSku().getImage(argumentCollection = arguments);
	}
	
	public string function getImagePath() {
		return getDefaultSku().getImagePath();
	}
	
	public string function getResizedImagePath(string size, numeric width, numeric height, string resizeMethod="scale", string cropLocation="",numeric cropXStart=0, numeric cropYStart=0,numeric scaleWidth=0,numeric scaleHeight=0) {
		return getDefaultSku().getResizedImagePath(argumentCollection = arguments);
	}
	
	public array function getImageGalleryArray(array resizeSizes=[{size='s'},{size='m'},{size='l'}]) {
		var imageGalleryArray = [];
		var filenames = "";
		
		// Add all skus's default images
		for(var i=1; i<=arrayLen(getSkus()); i++) {
			if( !listFind(filenames, getSkus()[i].getImageFile()) ) {
				filenames = listAppend(filenames, getSkus()[i].getImageFile());
				var thisImage = {};
				thisImage.originalFilename = getSkus()[i].getImageFile();
				thisImage.originalPath = getSkus()[i].getImagePath();
				thisImage.type = "skuDefaultImage";
				thisImage.productID = getProductID();
				thisImage.name = getTitle();
				thisImage.description = getProductDescription();
				thisImage.resizedImagePaths = [];
				for(var s=1; s<=arrayLen(arguments.resizeSizes); s++) {
					arrayAppend(thisImage.resizedImagePaths, getSkus()[i].getResizedImagePath(argumentCollection = arguments.resizeSizes[s]));
				}
				arrayAppend(imageGalleryArray, thisImage);
			}
		}
		
		// Add all alternate image paths
		for(var i=1; i<=arrayLen(getImages()); i++) {
			if( !listFind(filenames, getImages()[i].getImageID()) ) {
				filenames = listAppend(filenames, getImages()[i].getImageID());
				var thisImage = {};
				thisImage.originalFilename = getImages()[i].getImageID() & "." & getImages()[i].getImageExtension();
				thisImage.originalPath = getImages()[i].getImagePath();
				thisImage.type = "productAlternateImage";
				thisImage.skuID = "";
				thisImage.productID = getProductID();
				thisImage.name = "";
				if(!isNull(getImages()[i].getImageName())) {
					thisImage.name = getImages()[i].getImageName();
				}
				thisImage.description = "";
				if(!isNull(getImages()[i].getImageDescription())) {
					thisImage.name = getImages()[i].getImageDescription();
				}
				thisImage.resizedImagePaths = [];
				for(var s=1; s<=arrayLen(arguments.resizeSizes); s++) {
					arrayAppend(thisImage.resizedImagePaths, getImages()[i].getResizedImagePath(argumentCollection = arguments.resizeSizes[s]));
				}
				arrayAppend(imageGalleryArray, thisImage);
			}
		}
		
		return imageGalleryArray;
	}
	
	public numeric function getPrice() {
		// brand new products won't have a default SKU yet but need this method for create form
		if( structKeyExists(variables,"defaultSku") ) {
			return getDefaultSku().getPrice();
		} else {
			return 0;
		}
	}
	
	public numeric function getListPrice() {
		// brand new products won't have a default SKU yet but need this method for create form
		if( structKeyExists(variables,"defaultSku") ) {
			return getDefaultSku().getListPrice();
		} else {
			return 0;
		}
	}
	
	public numeric function getLivePrice() {
		// brand new products won't have a default SKU yet but need this method for create form
		if( structKeyExists(variables,"defaultSku") ) {
			return getDefaultSku().getLivePrice();
		} else {
			return 0;
		}
	}

	public numeric function getShippingWeight() {
		// brand new products won't have a default SKU yet but need this method for create form
		if( structKeyExists(variables,"defaultSku") ) {
			if(isNumeric(getDefaultSku().getShippingWeight())) {
				return getDefaultSku().getShippingWeight();	
			} else {
				return 0;
			}
		} else {
			return 0;
		}
	}
	
	public array function getOptionsByOptionGroup(required string optionGroupID) {
		var smartList = getService("optionService").getOptionSmartList();
		smartList.addFilter("optionGroup_optionGroupID",arguments.optionGroupID);
		smartList.addFilter("skus_product_productID",this.getProductID());
		smartList.addOrder("sortOrder|ASC");
		return smartList.getRecords();
	}

	public any function getSkuBySelectedOptions(string selectedOptions="") {
		if(len(arguments.selectedOptions) > 0) {
			return getService("productService").getProductSkuBySelectedOptions(arguments.selectedOptions,this.getProductID());
		} else {
			return getDefaultSku();
		}
	}
	
	// get all the assigned attribute sets
	public array function getAttributeSets(array attributeSetTypeCode){
		var attributeSets = [];
		// get all the parent product types
		var productTypeIDs = getService("ProductService").getProductTypeFromTree(getProductType().getProductTypeID()).IDPath;
		
		return getService("ProductService").getAttributeSets(arguments.attributeSetTypeCode,listToArray(productTypeIDs));
	}
	
	//get attribute value
	public any function getAttributeValue(required string attribute, returnEntity=false){
		var smartList = new Slatwall.org.entitySmartList.SmartList(entityName="SlatwallProductAttributeValue");
		
		smartList.addFilter("product_productID",getProductID(),1);
		smartList.addFilter("attribute_attributeID",attribute,1);
		
		smartList.addFilter("product_productID",getProductID(),2);
		smartList.addFilter("attribute_attributeCode",attribute,2);
		
		var attributeValue = smartList.getRecords();
		
		if(arrayLen(attributeValue)){
			if(returnEntity) {
				return attributeValue[1];	
			} else {
				return attributeValue[1].getAttributeValue();
			}
		}else{
			if(returnEntity) {
				return getService("ProductService").newProductAttributeValue();	
			} else {
				return "";
			}
		}
	}
	
	public struct function getCrumbData(required string path, required string siteID, required array baseCrumbArray) {
		var productFilename = replace(arguments.path, "/#arguments.siteID#/", "", "all");
		productFilename = left(productFilename, len(productFilename)-1);
		
		var productCrumbData = {
			contentHistID = "",
			contentID = "",
			filename = productFilename,
			inheritobjects = "Cascade",
			menuTitle = getTitle(),
			metaDesc = "",
			metaKeywords = "",
			parentArray = arguments.baseCrumbArray[1].parentArray,
			parentID = "",
			restricted = 0,
			retrictgroups = "",
			siteid = arguments.siteID,
			sortby = "orderno",
			sortdirection = "asc",
			target = "_self",
			targetPrams = "",
			template = "",
			type = "Page"
		};
		
		return productCrumbData;
	}
	
}


