<%@page import="com.bokecc.util.DemoUtil"%>
<%@page import="com.bokecc.util.APIServiceFunction"%>
<%@page import="com.bokecc.config.Config"%>
<%@page import="org.dom4j.Document"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<jsp:directive.page import="java.util.Map"/>
<jsp:directive.page import="java.util.HashMap"/>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>user info</title>
</head>
<body>
<h1>API java demo 用户信息</h1>
<hr />
<a href='index.jsp'>返回首页</a>
<hr />
<br />
<%
/**
 * 功能：用户信息接口示例
 * 版本：1.0
 * 日期：2010-12-21
 * 作者：yaosj chu
 **/
	Map<String, String> paramsMap = new HashMap<String, String>();
	paramsMap.put("userid", Config.userid);
	long time = System.currentTimeMillis();
	String salt = Config.key;
	String requestURL = APIServiceFunction.createHashedQueryString(
			paramsMap, time, salt);
	//get方式
	String responsestr = APIServiceFunction.HttpRetrieve(Config.api_user + "?" + requestURL);
	Document doc = DemoUtil.build(responsestr);
	String email = doc.getRootElement().element("account").getText();
	String version = doc.getRootElement().element("version").getText();
	String expired = doc.getRootElement().element("expired").getText();
	String space_total = doc.getRootElement().element("space").element("total").getText();
	String space_remain = doc.getRootElement().element("space").element("remain").getText();
	String traffic_total = doc.getRootElement().element("traffic").element("total").getText();
	String traffic_used = doc.getRootElement().element("traffic").element("used").getText();
	//out.println(responsestr);
%>
账户：<%=email %><br />
版本：<%=version %><br />
到期：<%=expired %><br />
空间：总：<%=space_total %>&nbsp;&nbsp;&nbsp;&nbsp;剩余：<%=space_remain %><br />
流量：总：<%=traffic_total %>&nbsp;&nbsp;&nbsp;&nbsp;已用：<%=traffic_used %><br />
</body>
</html>