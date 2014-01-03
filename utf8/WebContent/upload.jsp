<%@page import="com.bokecc.config.Config"%>
<%@page import="java.util.Iterator"%>
<%@page import="java.util.List"%>
<%@page import="com.bokecc.util.DemoUtil"%>
<%@page import="com.bokecc.util.APIServiceFunction"%>
<%@page import="org.dom4j.*"%>
<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="java.util.Map" %>
<%@page import="java.util.HashMap" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>upload demo</title>
<style type="text/css">
.fla_btn {
	position: relative;
}

.fla_btn embed {
	position: absolute;
	z-index: 1;
}
#swfDiv{*position:absolute; z-index:2;}
</style>
<script type="text/javascript" src="js/swfobject.js"></script>
</head>
<body>
<h1>API java demo 上传视频</h1>
<hr />
<a href='index.jsp'>返回首页</a>
<hr />
<div id="tips"></div>
<form id="addvform" name="addvform" action="" method="get">
<div class="fla_btn"><span style="float:left;">选择视频：<input id="videofile" name="videofile" type="text" /></span> <div
	id="swfDiv"></div> <input type="button" value="upload"
	id="btn_width" style="width: 80px; height: 25px" /></div>
<div style="clear:both;">视频标题：<input id="title" name="title" type="text" /></div>
<div>视频标签：<input id="tag" name="tag" type="text" /></div>
<div>视频简介：<textarea id="description" name="description" rows="5" cols="30"></textarea></div>
<input id="videoid" name="videoid" type="hidden" value="" />
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
</div>
<div><input type="button" value="提交" onclick="submitvideo();"></div>
<br />
<hr />
videoid:<div id="videoidshow"></div>
<div>上传进度：<span id="up"></span></div>
<div>请求地址：<span id="request_params"></span></div>
</form>
<script type="text/javascript">

// 加载上传flash ------------- start
	var swfobj=new SWFObject('http://union.bokecc.com/flash/api/uploader.swf', 'uploadswf', '80', '25', '8');
	swfobj.addVariable( "progress_interval" , 1);	//	上传进度通知间隔时长（单位：s）
	swfobj.addVariable( "notify_url" , "<%= Config.notify_url%>");	//	上传视频后回调接口
	swfobj.addParam('allowFullscreen','true');
	swfobj.addParam('allowScriptAccess','always');
	swfobj.addParam('wmode','transparent');
	swfobj.write('swfDiv');
// 加载上传flash ------------- end

//	-------------------
//	调用者：flash
//	功能：选中上传文件，获取文件名函数
//	时间：2010-12-22
//	说明：用户可以加入相应逻辑
//	-------------------
	function on_spark_selected_file(filename) {
		document.getElementById("videofile").value = filename;
	}
	
//	-------------------
//	调用者：flash
//	功能：验证上传是否正常进行函数
//	时间：2010-12-22
//	说明：用户可以加入相应逻辑
//	-------------------
	function on_spark_upload_validated(status, videoid) {
		if (status == "OK") {
			alert("上传正常,videoid:" + videoid);
			document.getElementById("videoid").value = videoid;
			document.getElementById("videoidshow").innerHTML = videoid;
		} else if (status == "NETWORK_ERROR") {
			alert("网络错误");
		} else {
			alert("api错误码：" + status);
		}
	}
	
//	-------------------
//	调用者：flash
//	功能：通知上传进度函数
//	时间：2010-12-22
//	说明：用户可以加入相应逻辑
//	-------------------
	function on_spark_upload_progress(progress) {
		var uploadProgress = document.getElementById("up");
		if (progress == -1) {
			uploadProgress.innerHTML = "上传出错：" + progress;
		} else if (progress == 100) {
			uploadProgress.innerHTML = "进度：100% 上传完成";
		} else {
			uploadProgress.innerHTML = "进度：" + progress + "%";
		}
	}
	
	function positionUploadSWF() {
		document.getElementById("swfDiv").style.width = document.getElementById("btn_width").style.width;
		document.getElementById("swfDiv").style.height = document.getElementById("btn_width").style.height;
	}
	
	//控制上传
	function submitvideo() {
		var title = encodeURIComponent(document.getElementById("title").value, "utf-8");
		var tag = encodeURIComponent(document.getElementById("tag").value, "utf-8");
		var description = encodeURIComponent(document.getElementById("description").value, "utf-8");
		var superCategory = encodeURIComponent(document.getElementById("supercategory").value, "utf-8");
		var subCategory = document.getElementById("sub_" + superCategory);
		if (document.getElementById("supercategory") != null && subCategory == null){
			document.getElementById("tips").innerHTML = "<div style='color:red;'>一级分类不能添加视频，请重新选择</div>";
			return;
		}
		
		var url = "getuploadurl.jsp?title=" + title + "&tag=" + tag
				+ "&description=" + description;
		
		if (subCategory != null) {
			url = url + "&categoryid=" + subCategory.value;
		}
		
		var req = getAjax();
		req.open("GET", url, true);
		req.onreadystatechange = function() {
			if (req.readyState == 4) {
				if (req.status == 200) {
					var re = req.responseText;//获取返回的内容
					document.getElementById("uploadswf").start_upload(re); //	调用flash上传函数
					document.getElementById("request_params").innerHTML = re;
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
</script>
</body>
</html>