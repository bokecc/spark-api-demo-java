<%@page import="com.bokecc.util.DemoUtil"%>
<%@page import="org.dom4j.DocumentHelper"%>
<%@page import="org.dom4j.Document"%>
<%@page pageEncoding="UTF-8"%>
<jsp:directive.page import="java.util.Map"/>
<jsp:directive.page import="java.util.HashMap"/>
<%
/**
 * 功能：视频处理完成回调接口
 * 版本：1.0
 * 日期：2010-12-21
 * 作者：chu
 **/
DemoUtil.NOTIFY_VIDEO_LIST.add(request.getQueryString());
Document doc = DocumentHelper.createDocument(DocumentHelper.createElement("result").addText("OK"));
out.clear();
out.print(doc.asXML());
%>
