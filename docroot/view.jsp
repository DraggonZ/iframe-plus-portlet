<%@include file="/init.jsp"%>

<%
	String sourceUrl = preferences.getValue("sourceUrl",StringPool.BLANK);
	String portletPath = renderResponse.encodeURL(renderRequest.getContextPath());
	String portalHomeUrl = PortalUtil.getPortalURL(request);
%>

<div class="iframe-plus" id="<%=portletNamespace%>-iframe-container">
</div>

<script type="text/javascript">
	/* A loading mask is added if the option is activated (user set the option from 
	   the configuration menu) */
	if(<%=maskActivated%>){
		$("#<%=portletNamespace%>-iframe-container").closest(".portlet-content")
		.mask("<liferay-ui:message key='loading'/>");
	}
	
	/* Socket used to listen to the message coming from the page contained in the iframe-container.
	   depending on the message content different action are  */
	if("<%=sourceUrl%>"){
		var transport = new easyXDM.Socket({
		    remote: "<%=sourceUrl%>",
		    swf: "<%=portalHomeUrl%><%=portletPath%>/easyxdm/easyxdm.swf",
		    container: "<%=portletNamespace%>-iframe-container",
		    onMessage: function(message, origin){	 
		        if(message=="hide-loading-automatic" && "<%=endLoading%>"=="automatic"){
		        	closeLoadingMask();
				} else if(message=="hide-loading-manual") {
					closeLoadingMask();
				}else{ //resize iframe
				    var message = JSON.parse(message);
				    var iframe = $("iframe").eq(0);
				    iframe.height(message.height);
				    /*alert("iframe height = " + iframe.height()
				    		+ "\niframe width = " + iframe.width()
				    		+ "\nbody width = " + $("body").width()
				    		+ "\nmessage width = " + message.width
				    		+ "\nmessage height = " + message.height);*/
					//if (message.width > iframe.width()){
					var diff =  message.width - iframe.width();
					var body = $("body");
					var oldWidth;
					if (body.width() > iframe.width()){
						oldWidth = body.width();
					}
					else{
						oldWidth = iframe.width() + 30;
					}
					body.css("min-width", oldWidth + diff + "px");						
				}
			}
		});
	 }
	
	function closeLoadingMask(){
		$("#<%=portletNamespace%>-iframe-container")
    	.closest(".portlet-content").unmask();
	}
</script>