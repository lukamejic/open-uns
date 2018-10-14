<%--

    The contents of this file are subject to the license and copyright
    detailed in the LICENSE and NOTICE files at the root of the source
    tree and available online at

    http://www.dspace.org/license/

--%>
<% if(mostCitedItem != null && mostCitedItem.getItems()!=null && mostCitedItem.getItems().size()!=0){ %>
        <div class="panel panel-primary vertical-carousel" data-itemstoshow="3">        
        <div class="panel-heading">
          <h3 class="panel-title">
          		<a href="JavaScript:otvoriBlok('RecSub');"><fmt:message key="jsp.components.most-cited"/><i id="faMostCit" class="fa fa-angle-double-down"></i></a>
          </h3>
       </div>   
	   <div class="panel-body hideNi panDesno" id="blokMostCit">
	   		<div class="list-groups">
<% for(MostViewedItem mvi : mostCitedItem.getItems()){
		IGlobalSearchResult item = mvi.getItem();
		if ( mvi.getVisits()==null ) {
			%>
				<fmt:message key="jsp.components.most-cited.data-loading"/>
			<%
			break;
		}
%>
		<dspace:discovery-artifact style="global" artifact="<%= item %>" view="<%= mostCitedItem.getConfiguration() %>">
		<span class="badge" data-toggle="tooltip" data-placement="top" title="<fmt:message key="jsp.components.most-cited.badge-tooltip"/>"><fmt:formatNumber value="<%= (mvi==null || mvi.getVisits()==null)?0.0:mvi.getVisits() %>" type="NUMBER" maxFractionDigits="0" /></span> ##artifact-item##
		</dspace:discovery-artifact>
<%
     }
%>
			</div>
		  </div>
     </div>
<%
}
%>