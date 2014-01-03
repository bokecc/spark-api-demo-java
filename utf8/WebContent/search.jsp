<%@page import="com.bokecc.util.APIServiceFunction"%>
<%@page import="com.bokecc.config.Config"%>
<%@page import="com.bokecc.bean.Video"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.net.URLDecoder"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.Iterator"%>
<%@page import="com.bokecc.util.*"%>
<%@page import="java.util.List"%>
<%@page import="org.dom4j.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>video search demo</title>
</head>
<body>
<h1>API java demo 视频搜索</h1>
	<hr />
	<a href='index.jsp'>返回首页</a>
	<hr />
<form method="get" name="searchform" action="/searchvideo.jsp">
	<div>
		搜索条件：
		<select name="search_query" id="search_query">
			<option value="TITLE" selected="selected">按视频标题</option>
		</select><input type="text" name="search_cont" id ="search_cont" size="10"/>
	</div>
	<div>排序方式：
		<select name="sort_param" id="sort_param">
			<option value="CREATION_DATE:ASC" selected="selected">按日期升序排列</option>
			<option value="FILE_SIZE:ASC">按文件大小升序排列</option>
			<option value="CREATION_DATE:DESC">按日期降序排列</option>
			<option value="FILE_SIZE:DESC">按文件大小降序排列</option>
		</select>
	</div>
	<div>视频分类：
	<%
		Map<String, String> paramsMap = new HashMap<String, String>();
		paramsMap.put("userid", Config.userid);
		long time = System.currentTimeMillis();
		String requestURL = APIServiceFunction.createHashedQueryString(paramsMap, time, Config.key);
		//get方式
		String responseStr = APIServiceFunction.HttpRetrieve(Config.api_category + "?" + requestURL);
		Document doc = DemoUtil.build(responseStr);
		@SuppressWarnings("unchecked")
		// 得到视频分类XML
		Iterator<Element> categorys = doc.getRootElement().elementIterator("category");
		Map<String, Iterator<Element>> categoryMap = new HashMap<String, Iterator<Element>>();
		
		if (categorys != null) {
	%>
	<select id="supercategory" onchange="show();">
		<option value="all">全部分类</option>
		<%
			while (categorys.hasNext()) {
				Element categoryElement = categorys.next();
				if (categoryElement.elementIterator("sub-category").hasNext()) {
					@SuppressWarnings("unchecked")
					Iterator<Element> subcategorys = categoryElement.elementIterator("sub-category");
					categoryMap.put(categoryElement.elementText("id"), subcategorys);
					
					//显示当前视频的一级分类信息
				}
		%>
		<option value="<%=categoryElement.elementText("id")%>"><%=categoryElement.elementText("name")%></option>
		<%
			}
		%>
	</select>
		<%
			for (String superCategoryId : categoryMap.keySet()) {
				Iterator<Element> subcategorys = categoryMap.get(superCategoryId);
		%>
				<select id="sub_<%=superCategoryId%>" style="display: none;" name="sub_category">
		<%
				while (subcategorys.hasNext()) {
					Element subcategoryElement = subcategorys.next();
		%>
					<option value="<%=subcategoryElement.elementText("id")%>"><%=subcategoryElement.elementText("name")%></option>
		<%
				}
		%>
	</select>
		<%
			}
		}
	%>
	<br />
	<input type="button" value="搜索" onclick="searchVideo();"/>
	</div>
</form>
	<br />
	<div id="search_result"></div>
	<script type="text/javascript">
		showSub();
		function show() {
			subCategorys = document.getElementsByName("sub_category");
			for ( var i = 0; i < document.getElementsByName("sub_category").length; i++) {
				subCategorys[i].style.display = 'none';
			}
			showSub();
		}
	
		function showSub() {
			var superCategory = document.getElementById("supercategory").value;
			var subCategory = document.getElementById("sub_" + superCategory);
			if (subCategory != null) {
				subCategory.style.display = 'inline';
			}
		}
		
		function searchVideo(){
			var searchQuery = encodeURIComponent(document.getElementById("search_query").value, "utf-8");
			var searchCont = encodeURIComponent(document.getElementById("search_cont").value, "utf-8");
			if(searchCont == null || searchCont == ""){
				alert("查询条件不可为空");
				return;
			}
			var sortParam = encodeURIComponent(document.getElementById("sort_param").value, "utf-8");
			var superCategory = encodeURIComponent(document.getElementById("supercategory").value, "utf-8");
			var subCategory = document.getElementById("sub_" + superCategory);
			
			var url = "searchvideo.jsp?search_query=" + searchQuery + "&search_cont=" + searchCont + "&sort_param=" + sortParam;
			if (document.getElementById("supercategory") != null
					&& document.getElementById("supercategory").value != "all"
					&& subCategory == null){
				document.getElementById("search_result").innerHTML = "<div style='color:red;'>一级分类不能添加视频，请重新选择</div>";
				return;
			}
			if (subCategory != null) {
				url = url + "&categoryid=" + subCategory.value;
			}
			
			var req = getAjax();
			req.open("GET", url, true);
			req.onreadystatechange = function() {
				if (req.readyState == 4) {
					if (req.status == 200) {
						var re = req.responseText;//获取返回的内容
						document.getElementById("search_result").innerHTML = re;
					}
				}
			};
			req.send(null);
		}
		
		function deletevideo(videoId) {
			var url = "delete.jsp?videoid=" + videoId;
			var req = getAjax();
			req.open("GET", url, true);
			req.onreadystatechange = function() {
				if (req.readyState == 4) {
					if (req.status == 200) {
						re = req.responseText;//获取返回的内容
						document.getElementById("delete_result").innerHTML = re;
					}
				}
			};
			req.send(null);
		}
		
		function getAjax() {
			var oHttpReq = null;

			if (window.XMLHttpRequest) {
				oHttpReq = new XMLHttpRequest;
				if (oHttpReq.overrideMimeType) {
					oHttpReq.overrideMimeType("text/xml");
				}
			} else if (window.ActiveXObject) {
				try {
					oHttpReq = new ActiveXObject("Msxml2.XMLHTTP");
				} catch (e) {
					oHttpReq = new ActiveXObject("Microsoft.XMLHTTP");
				}
			} else if (window.createRequest) {
				oHttpReq = window.createRequest();
			} else {
				oHttpReq = new XMLHttpRequest();
			}

			return oHttpReq;
		}
	</script>
</body>
</html>