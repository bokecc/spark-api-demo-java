<%@page import="com.bokecc.util.APIServiceFunction"%>
<%@page import="com.bokecc.config.Config"%>
<%@page pageEncoding="UTF-8"%>
<%@page import="java.net.URLDecoder"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.HashMap"%>
<%
/**
 * 功能：视频上传接口示例
 * 版本：2.1.2
 * 日期：2013-11-13
 * 作者：chu
 **/
	out.clear();
	String title = request.getParameter("title");
	String tag = request.getParameter("tag");
	String description = request.getParameter("description");
	String categoryId = request.getParameter("categoryid");
	Map<String, String> paramsMap = new HashMap<String, String>();
	paramsMap.put("userid",Config.userid);
	paramsMap.put("title", new String(title.getBytes("ISO-8859-1"), "UTF-8"));
	paramsMap.put("description",new String(description.getBytes("ISO-8859-1"), "UTF-8"));
	paramsMap.put("tag",new String(tag.getBytes("ISO-8859-1"), "UTF-8"));
	paramsMap.put("categoryid",new String(categoryId.getBytes("ISO-8859-1"), "UTF-8"));
	long time = System.currentTimeMillis();
	String salt = Config.key;
	String requestURL = APIServiceFunction.createHashedQueryString(paramsMap, time, salt);
	out.print(requestURL);
%>
