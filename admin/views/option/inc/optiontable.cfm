<!---

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
<cfparam name="rc.options" type="any" />
<cfparam name="rc.optiongroups" type="any" />

<cfoutput>
<cfif arrayLen(rc.options.getPageRecords()) GT 0>
<table class="mura-table-grid stripe" id="Options">
	<tr>
		<th class="varWidth">#rc.$.Slatwall.rbKey("entity.option.optionname")#</th>
		<th>#rc.$.Slatwall.rbKey("entity.option.optioncode")#</th>
		<th>#rc.$.Slatwall.rbKey("entity.option.optiongroup")#</th>
		<th>#rc.$.Slatwall.rbKey("entity.option.sortorder")#</th>
		<th>&nbsp;</th>
	</tr>
<cfloop array="#rc.options.getPageRecords()#" index="local.thisOption">
	<tr>
		<td class="varWidth">#local.thisOption.getOptionName()#</td>
		<td>#local.thisOption.getOptionCode()#</td>
		<td>#local.thisOption.getOptionGroup().getOptionGroupName()#</td>
		<td>#local.thisOption.getSortOrder()#</td>
		<td class="administration">
		  <ul class="two">
              <cf_SlatwallActionCaller action="admin:option.edit" querystring="optiongroupid=#local.thisOption.getOptionGroup().getOptionGroupID()#&optionID=#local.thisOption.getOptionID()#" class="edit" type="list">
              <cf_SlatwallActionCaller action="admin:option.delete" querystring="optionid=#local.thisOption.getOptionID()#" class="delete" type="list" disabled="#local.thisOption.getAssignedFlag()#" confirmrequired="true">
		  </ul>		
		
		</td>
	</tr>
</cfloop>
</table>
<cf_SlatwallSmartListPager smartList="#rc.options#">
<cfelse>
<p><em>#rc.$.Slatwall.rbKey("admin.option.nooptionsdefined")#</em></p>
</cfif>
</cfoutput>
