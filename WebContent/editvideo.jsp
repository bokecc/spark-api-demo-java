<%@page import="com.bokecc.util.DemoUtil"%>
<%@page import="com.bokecc.util.APIServiceFunction"%>
<%@page import="com.bokecc.config.Config"%>
<%@page import="org.dom4j.Document"%>
<%@page pageEncoding="UTF-8"%>
<jsp:directive.page import="java.util.Map" />
<jsp:directive.page import="java.util.HashMap" />
<%
	/**
	 * 功能：视频编辑操作页面
	 * 版本：2.1.2
	 * 日期：2013-11-13
	 * 作者：gt
	 **/
	Map<String, String> paramsMap = new HashMap<String, String>();
	paramsMap.put("videoid", request.getParameter("videoid"));
	paramsMap.put("userid", Config.userid);
	String title = request.getParameter("title");
	String tag = request.getParameter("tag");
	String description = request.getParameter("description");
	paramsMap.put("title", new String(title.getBytes("ISO-8859-1"), "UTF-8"));
	paramsMap.put("tag", new String(tag.getBytes("ISO-8859-1"), "UTF-8"));
	paramsMap.put("description", new String(description.getBytes("ISO-8859-1"), "UTF-8"));
	if (request.getParameter("categoryid") != null) {
		paramsMap.put("categoryid", request.getParameter("categoryid"));
	}
	if (request.getParameter("imageindex") != null) {
		paramsMap.put("imageindex", request.getParameter("imageindex"));
	}
	long time = System.currentTimeMillis();
	String salt = Config.key;
	String requestURL = APIServiceFunction.createHashedQueryString(paramsMap, time, salt);
	String responsestr = APIServiceFunction.HttpRetrieve(Config.api_updateVideo + "?" + requestURL);
	Document doc = DemoUtil.build(responsestr);
	String videoId = doc.getRootElement().elementText("id");
	if(videoId!=null){
		out.print("<div style='color:red;'>编辑成功</div>请同步视频,查看编辑结果 &nbsp;&nbsp;<a href='videosync.jsp?videoidFrom=&videoidTo=' target='_self'>同步视频</a><br/><br/>");
	}else{
		out.print("<h3>编辑失败，请稍后再试</h3>");
	}
%>