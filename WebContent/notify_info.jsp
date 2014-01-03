<%@page import="com.bokecc.util.DemoUtil"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>play demo</title>
<script type="text/javascript" src="js/swfobject.js"></script>
</head>
<body>
<h1>API java demo 视频回调</h1>
<hr />
<a href='index.jsp'>返回首页</a>
<hr />
<%
for (int i = 0; i < DemoUtil.NOTIFY_VIDEO_LIST.size(); i++){
%>
	url:<%=DemoUtil.NOTIFY_VIDEO_LIST.get(i) %><br />
<%
}
%>
</body>
</html>