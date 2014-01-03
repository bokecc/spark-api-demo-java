<%@page import="com.bokecc.util.DemoUtil"%>
<%@page import="com.bokecc.util.APIServiceFunction"%>
<%@page import="com.bokecc.config.Config"%>
<%@page import="org.dom4j.Document"%>
<%@page pageEncoding="UTF-8"%>
<jsp:directive.page import="java.net.URLDecoder" />
<jsp:directive.page import="java.util.Map" />
<jsp:directive.page import="java.util.HashMap" />
<%
	/**
	 * 功能：删除视频信息接口示例
	 * 版本：2.1.2
	 * 日期：2013-11-13
	 * 作者：gt
	 **/
	out.clear();
	Map<String, String> paramsMap = new HashMap<String, String>();
	String videoId = request.getParameter("videoid");
	paramsMap.put("videoid", videoId);
	paramsMap.put("userid", Config.userid);
	long time = System.currentTimeMillis();
	String salt = Config.key;
	String requestURL = APIServiceFunction.createHashedQueryString(
			paramsMap, time, salt);
	//get方式
	String responsestr = APIServiceFunction
			.HttpRetrieve(Config.api_deleteVideo + "?" + requestURL);
	Document doc = DemoUtil.build(responsestr);
	String result = doc.getRootElement().getText();
	if ("OK".equals(result)) {
		out.print("删除成功，请同步视频查看结果");
	} else {
		out.print("删除失败!");
	}
%>
