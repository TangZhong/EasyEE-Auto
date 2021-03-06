<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%
	String path = request.getContextPath();
	String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + path + "/";
%>
<%@ taglib uri="/struts-tags" prefix="s"%>
<%@ taglib uri="http://shiro.apache.org/tags" prefix="shiro"%>

<%--  JavaScript  --%>
<%-- JavaScript --%>
<script type="text/javascript">
	// ${ClsLabel} Namespace
	var ${ClassName} = {};
	$(function() {
		/*
		 * datagrid
		 */
		var dg = $("#${ClassName}DataGrid");

		// EasyUIEx datagrid
		$("#${ClassName}DataGrid").initDatagrid({
			// CRUD URL
			url : "${ClassName}/list",
			saveUrl : "${ClassName}/save",
			updateUrl : "${ClassName}/update",
			destroyUrl : "${ClassName}/delete",
			// Primary Key filed
			idField : "${Oid}", 
			
			showHeaderContextMenu : true, // Datagrid header ContextMenu
			
			<#if pagination>pagination : true,<#else>pagination : false,</#if> // pagination
			// pageSize: 10,
			// pageList: [10, 20, 30, 40, 50],
			
			//queryParams:{"rows":dg.datagrid("options").pageSize}, // pagination query parameters
			
			checkbox : true,
			checkOnSelect : true,
			singleSelect : false,
			
			clickCellEdit : true, //cellEdit
			autoSave : true, // Auto Save
			
			<#if contextMenu>
			menuSelector : "#${ClassName}ContextMenu", // ContextMenu
			showContextMenu : true,</#if>
			
			sendRowDataPrefix : "${ClassName?uncap_first}.", //send parameter name prefix
						
			showMsg : true, // The action message is displayed
			successKey : "statusCode", //The success key returned by the server
			successValue : "200" //The success value returned by the server
			
			<#if mutipleDelete>,mutipleDelete : true, // Multiple rows are submitted for deletion
			mutipleDeleteProperty : "${Oid}" // Multiple rows to mention the attributes and values to the server, will not add sendRowDataPrefix prefix to support the use of an array to specify multiple attribute names
			</#if>
		});

		/*
		 * Functions
		 */
		<#if toolbar>
		// Search
		${ClassName}.doSearch = function() {
			dg.datagrid("load", {
				<#if Propertys??>
				<#list Propertys as item>
				<#assign info=item?split("#")>
				'${ClassName?uncap_first}Criteria.${info[1]}' : $("#${ClassName?uncap_first}${info[1]?cap_first}").val()<#sep>,</#sep>
				</#list>
				</#if>
			});
		}
		
		// Clear all search conditions
		${ClassName}.clearAll = function() {
			$("#${ClassName}SearchForm")[0].reset();
			dg.datagrid("load", {
			});
		}
		</#if>
		
		<#if save>
		<%--
		// Dialog Add
		${ClassName}.toAdd = function() {
			uiEx.resetForm("#${ClassName}AddForm");
			uiEx.openDialog("#${ClassName}AddDialog", "${ClsLabel} <s:text name="label.add"></s:text>");
		}
		--%></#if>
		
		<#if update>
		<%--
		// Dialog Eidt
		${ClassName}.toEdit = function() {
			var row = $("#${ClassName}DataGrid").datagrid('getSelected');
			if (rows && rows.length && rows.length>0) {
				toEdit(row);
			} else {
				uiEx.msg("<s:text name="msg.choiceEditRow"></s:text>");
			}
		}
		function toEdit(row) {
			uiEx.resetForm("#${ClassName}EditForm");
			uiEx.openDialog("#${ClassName}EditDialog", "${ClsLabel} <s:text name="label.edit"></s:text>");
			uiEx.loadForm("#${ClassName}EditForm", row, "");
		}
		--%></#if>
		
	});
</script>

<%-- 2. Page --%>
<table id="${ClassName}DataGrid" title="${ClsLabel}<s:text name="label.list"></s:text>" style="width: 100%"  <#if toolbar>toolbar="#${ClassName}Toolbar"</#if> idField="${Oid}" rownumbers="true" fit="true" fitColumns="true" nowrap="false">
	<thead>
		<tr>
			<th field="ck" checkbox="true" width="50" sortable="true"><s:text name="label.chkbox"></s:text></th>
			<#if Autos??>
			<#list Autos as item>
			<#assign info=item?split("#")>
			<#if info[4]=="true">
			<th field="${info[0]}" width="50" sortable="true" <#if info[6]=="true">editor="{type:'textbox',options:{<#if info[3]=="true">required:true</#if>}}"</#if>>${info[2]}</th>
			</#if>
			</#list>
			</#if>
		</tr>
	</thead>
</table>
<#if toolbar>
<%-- 3. Search ToolBar --%>
<div id="${ClassName}Toolbar">
	<div>
	<form action="" id="${ClassName}SearchForm" onsubmit="${ClassName}.doSearch();return false">
		<#if Propertys??>
		<#list Propertys as item>
		<#assign info=item?split("#")>
		<span>${info[4]}:</span> <input name="${ClassName?uncap_first}Criteria.${info[1]}" id="${ClassName?uncap_first}${info[1]?cap_first}" class="${info[7]}" /> 
		</#list>
		</#if>
		<#if search>
		<a class="easyui-linkbutton" iconCls="icon-search" plain="true" onclick="${ClassName}.doSearch()"><s:text name="label.search"></s:text></a>
		<a class="easyui-linkbutton" iconCls="icon-clear" plain="true" onclick="${ClassName}.clearAll()"><s:text name="label.clear"></s:text></a>
		<input type="submit" style="display: none;"/></#if>
	</form>
	</div>
	
	<#if save><%--<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-add',plain:true" onclick="${ClassName}.toAdd()">Dialog <s:text name="label.add"></s:text>${ClsLabel}</a>--%></#if>
	<#if update><%--<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-edit',plain:true" onclick="${ClassName}.toEdit()">Dialog <s:text name="label.edit"></s:text>${ClsLabel}</a>--%></#if>
	<#if save><a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-add',plain:true" onclick="$('#${ClassName}DataGrid').rowAdd()"><s:text name="label.add"></s:text>${ClsLabel}</a></#if>
	<#if remove><a class="easyui-linkbutton" iconCls="icon-remove" plain="true" onclick="$('#${ClassName}DataGrid').rowDelete()"><s:text name="label.delete"></s:text>${ClsLabel}</a></#if>
	<a class="easyui-linkbutton" iconCls="icon-undo" plain="true" onclick="javascript:$('#${ClassName}DataGrid').rowCancelEdit()"><s:text name="label.cancelEdit"></s:text></a>
</div>
</#if>
<#if contextMenu>
<%-- 4. Grid ContextMenu --%>
<div id="${ClassName}ContextMenu" class="easyui-menu" style="width:120px;">
	<#if save><div onclick="$('#${ClassName}DataGrid').rowAdd()" data-options="iconCls:'icon-add'"><s:text name="label.add"></s:text>${ClsLabel}</div></#if>
	<#if remove><div onclick="$('#${ClassName}DataGrid').rowDelete()" data-options="iconCls:'icon-remove'"><s:text name="label.delete"></s:text>${ClsLabel}</div></#if>
	<a class="easyui-linkbutton" iconCls="icon-undo" plain="true" onclick="javascript:$('#${ClassName}DataGrid').rowCancelEdit()"><s:text name="label.cancelEdit"></s:text></a>
 </div>
</#if>

<%-- 
<%@ include file="/WEB-INF/content/dialog/${Module}/${ClassName}Add.jsp"%>  
<%@ include file="/WEB-INF/content/dialog/${Module}/${ClassName}Edit.jsp"%>  
--%>