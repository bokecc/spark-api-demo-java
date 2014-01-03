<%@page import="java.util.Iterator"%>
<%@page import="java.util.List"%>
<%@page import="com.bokecc.util.DemoUtil"%>
<%@page import="com.bokecc.util.APIServiceFunction"%>
<%@page import="com.bokecc.config.Config"%>
<%@page import="org.dom4j.*"%>
<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="java.util.Map" %>
<%@page import="java.util.HashMap" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<title>edit info</title>
</head>
<body>
	<h1>API java demo 视频编辑</h1>
	<hr />
	<a href='index.jsp'>返回首页</a>
	<hr />
	<br />
	<%
		/**
		 * 功能：视频编辑接口示例
		 * 版本：2.1.2
		 * 日期：2013-11-13
		 * 作者：gt
		 **/
		Map<String, String> paramsMap = new HashMap<String, String>();
		String videoId = request.getParameter("videoid");
		paramsMap.put("userid", Config.userid);
		paramsMap.put("videoid", videoId);
		long time = System.currentTimeMillis();
		String salt = Config.key;
		String requestURL = APIServiceFunction.createHashedQueryString(paramsMap, time, salt);
		// get方式
		String responseStr = APIServiceFunction.HttpRetrieve(Config.api_video + "?" + requestURL);
		Document doc = DemoUtil.build(responseStr);
		// 得到视频信息XML
		Element videoElement = doc.getRootElement();
	%>
	<div id="edit_result"></div>
	<input type="hidden" id="videoid" value="<%=videoId%>"> 视频标题：
	<input id="title" value="<%=videoElement.elementText("title")%>" />
	<br /> 视频标签：
	<input id="tag" value="<%=videoElement.elementText("tags")%>" />
	<br /> 视频描述：
	<input id="desp" value="<%=videoElement.elementText("desp")%>" />
	<br /> 视频分类：
	<%
		paramsMap.clear();
		paramsMap.put("userid", Config.userid);
		time = System.currentTimeMillis();
		requestURL = APIServiceFunction.createHashedQueryString(paramsMap, time, salt);
		//get方式
		responseStr = APIServiceFunction.HttpRetrieve(Config.api_category + "?" + requestURL);
		doc = DemoUtil.build(responseStr);
		@SuppressWarnings("unchecked")
		// 得到视频分类XML
		Iterator<Element> categorys = doc.getRootElement().elementIterator("category");
		Map<String, Iterator<Element>> categoryMap = new HashMap<String, Iterator<Element>>();
		
		if (categorys != null) {
	%>
	<select id="supercategory" onchange="show();">
		<%
		    String currentSubCategoryId = videoElement.elementText("category");
			String currentCategoryId ="";
		
			while (categorys.hasNext()) {
				Element categoryElement = categorys.next();
				if (categoryElement.elementIterator("sub-category").hasNext()) {
					@SuppressWarnings("unchecked")
					Iterator<Element> subcategorys = categoryElement.elementIterator("sub-category");
					categoryMap.put(categoryElement.elementText("id"), subcategorys);
					
					//显示当前视频的一级分类信息
					@SuppressWarnings("unchecked")
					Iterator<Element> subcategorytemps = categoryElement.elementIterator("sub-category");
					while (subcategorytemps.hasNext()) {
						Element subcategorytemp = subcategorytemps.next();
						if(currentSubCategoryId.equals(subcategorytemp.elementText("id"))){
							currentCategoryId = categoryElement.elementText("id");
						}
					}
					
				}
		%>
		<option value="<%=categoryElement.elementText("id")%>"
		<%
				if(currentCategoryId.equals(categoryElement.elementText("id"))){
					out.print("selected='selected'");
				}
		%>
		><%=categoryElement.elementText("name")%></option>
		<%
			}
		%>
	</select>
		<%
			for (String categoryId : categoryMap.keySet()) {
				Iterator<Element> subcategorys = categoryMap.get(categoryId);
		%>
	<select id="sub_<%=categoryId%>" style="display: none;" name="sub_category">
		<%
				while (subcategorys.hasNext()) {
					Element subcategoryElement = subcategorys.next();
		%>
		<option value="<%=subcategoryElement.elementText("id")%>"
		<%
					if(currentSubCategoryId.equals(subcategoryElement.elementText("id"))){
						out.print("selected='selected'");
					}
		%>
		><%=subcategoryElement.elementText("name")%></option>
		<%
				}
		%>
	</select>
	<%
			}
		}
	%>
	<br> 选择视频截图：
	<br>
	<%
		@SuppressWarnings("unchecked")
		Iterator<Element> imgElements = videoElement.elementIterator("image-alternate");
		while (imgElements.hasNext()) {
			Element imgElement = imgElements.next();
	%>
	<img src="<%=imgElement.elementText("url")%>" alt="暂无截图" style="width: 9%;" />
	<input type="radio" name="video_img" value="<%=imgElement.elementText("index")%>" />
	<%
		}
	%>
	<br>
	<br>
	<input type="button" id="submit" onclick="submitVideo();" value="提交" />

	<script type="text/javascript">
		//控制视频分类显示
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
		//控制视频编辑
		function submitVideo() {
			var videoId = document.getElementById("videoid").value;
			var title = encodeURIComponent(
					document.getElementById("title").value, "utf-8");
			var tag = encodeURIComponent(document.getElementById("tag").value,
					"utf-8");
			var description = encodeURIComponent(document
					.getElementById("desp").value, "utf-8");
			var superCategory = encodeURIComponent(document
					.getElementById("supercategory").value, "utf-8");
			var subCategory = document.getElementById("sub_" + superCategory);
			var editUrl = "editvideo.jsp?videoid=" + videoId + "&title="
					+ title + "&tag=" + tag + "&description=" + description;
			if (document.getElementById("supercategory") != null
					&& subCategory == null){
				document.getElementById("edit_result").innerHTML = "<div style='color:red;'>一级分类不能添加视频，请重新选择</div>";
				return;
			}
			if (subCategory != null) {
				editUrl = editUrl + "&categoryid=" + subCategory.value;
			}
			var images = document.getElementsByName("video_img");
			for ( var i = 0; i < document.getElementsByName("video_img").length; i++) {
				if (images[i].checked) {
					editUrl = editUrl + "&imageindex=" + images[i].value;
				}
			}
			var req = getAjax();
			req.open("GET", editUrl, true);
			req.onreadystatechange = function() {
				if (req.readyState == 4) {
					if (req.status == 200) {
						var re = req.responseText;//获取返回的内容
						document.getElementById("edit_result").innerHTML = re;
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
