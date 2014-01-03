<%@page import="com.bokecc.util.APIServiceFunction"%>
<%@page import="com.bokecc.config.Config"%>
<%@page import="com.bokecc.bean.Video"%>
<%@page import="com.bokecc.util.DemoUtil"%>
<%@page import="java.util.ArrayList"%>
<%@page pageEncoding="UTF-8"%>
<jsp:directive.page import="org.dom4j.Element"/>
<jsp:directive.page import="java.util.Iterator"/>
<jsp:directive.page import="org.dom4j.Document"/>
<jsp:directive.page import="java.util.Map"/>
<jsp:directive.page import="java.util.HashMap"/>
<%
/**
 * 功能：视频信息数据获取接口示例
 * 版本：2.1.2
 * 日期：2013-11-13
 * 作者：chu
 **/
 
	out.clear();
	DemoUtil.SYNC_VIDEO_LIST = new ArrayList<Video>();
	out.println("开始请求视频数据 …...");
	String videoid_from = request.getParameter("videoidFrom");
	String videoid_to = request.getParameter("videoidTo");
	if (videoid_from == null)
		videoid_from = "";
	if (videoid_to == null)
		videoid_to = "";
	
	Map<String, String> queryMap = new HashMap<String, String>();
	int pageNum = 1;
	int pageSize = 100; //	单页视频上限个数为100个
	queryMap.put("userid", Config.userid); //	userid 用户id，不可以为空
	queryMap.put("videoid_from", videoid_from); //	videoid_from 起始videoid，若为空，则从上传的第一个视频开始
	queryMap.put("videoid_to", videoid_to); //	videoid_to 终止videoid，若为空，则到最后一个上传的视频
	queryMap.put("num_per_page", pageSize + ""); //	num_per_page 返回信息时，每页包含的视频个数，上限为100个
	queryMap.put("page", pageNum + ""); //	page 当前的页数

	long time = System.currentTimeMillis();
	String triggerURL = Config.api_videos
			+ "?"
			+ APIServiceFunction.createHashedQueryString(queryMap, time,
					Config.key);
	out.print("第 1 页视频操作 triggerURL:"+triggerURL);
	String result = APIServiceFunction.HttpRetrieve(triggerURL);
	/**	
		返回视频数据xml，返回的xml中的视频结点均为正常可播放视频
	
		<?xml version="1.0" encoding="UTF-8"?>
		<videos>
			<total>100</total>
			<video>
				<videoid>01234567</id>
				<title><![CDATA[视频标题]]></title>
				<desp><![CDATA[视频描述]]></desp>
				<tags><![CDATA[标签1 标签2 标签3]]></tags>
				<duration>314</duration>
				<image>http://image.bokecc.com/abc.jpg</image>
			</video>
			…...
		</videos>
	 **/
	Document document = DemoUtil.build(result);
	String totalStr = document.getRootElement().element("total")
			.getTextTrim();
	Integer total = Integer.parseInt(totalStr);
	int AllPageNum = 1;
	if ((total % pageSize) == 0) {
		AllPageNum = total / pageSize;
	} else {
		AllPageNum = (total / pageSize) + 1;
	}
	if (AllPageNum < 1)
		AllPageNum = 1;

	DemoUtil.apiVideos_parseXML(document);
	out.println(" .................... OK");
	for (int i = 2; i <= AllPageNum; i++) {
		queryMap = new HashMap<String, String>();
		queryMap.put("userid", Config.userid); //	userid 用户id，不可以为空
		queryMap.put("videoid_from", ""); //	videoid_from 起始videoid，若为空，则从上传的第一个视频开始
		queryMap.put("videoid_to", ""); //	videoid_to 终止videoid，若为空，则到最后一个上传的视频
		queryMap.put("num_per_page", pageSize + ""); //	num_per_page 返回信息时，每页包含的视频个数，上限为100个
		queryMap.put("page", i + ""); //	page 当前的页数

		time = System.currentTimeMillis();
		triggerURL = Config.api_videos
				+ "?"
				+ APIServiceFunction.createHashedQueryString(queryMap,
						time, Config.key);
		out.print("第 " + i + " 页视频操作 triggerURL:"+triggerURL);
		result = APIServiceFunction.HttpRetrieve(triggerURL);
		document = DemoUtil.build(result);
		DemoUtil.apiVideos_parseXML(document);
		out.println(" .................... OK");
	}
	out.println("请求视频数据结束。<a href='videolist.jsp'>返回视频同步列表</a>");
%>