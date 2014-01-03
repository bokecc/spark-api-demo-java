<%@page import="java.util.ArrayList"%>
<%@page import="com.bokecc.bean.Video"%>
<%@page import="com.bokecc.util.DemoUtil"%>
<%@page import="com.bokecc.config.Config"%>
<%@page import="java.util.Iterator"%>
<%@page import="java.util.List"%>
<%@page import="com.bokecc.util.APIServiceFunction"%>
<%@page import="org.dom4j.*"%>
<%@page import="java.util.Map" %>
<%@page import="java.util.HashMap" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>video list demo</title>
</head>
<body>
	<h1>API java demo 视频同步列表</h1>
	<hr />
	<a href='index.jsp'>返回首页</a>
	<hr />
	<a href="videosync.jsp?videoidFrom=&videoidTo=" target="_blank">同步视频</a>
	<hr />
	<div style="color: red;" id="delete_result"></div>
	<%
		String userId = Config.userid;
		List<Video> videos = DemoUtil.SYNC_VIDEO_LIST;
		int videoCount = videos.size();
	%>
	视频总数：<%=videoCount%>个
	<table border="1">
		<tr>
			<th align="center">视频标题</th>
			<th align="center">图片</th>
			<th align="center">操作</th>
			<th align="center">是否可以播放</th>
			<th align="center">点击播放</th>
			<th align="center">视频代码</th>
		</tr>
		<%
			for (Video video : videos) {
				String videoId = video.getSpark_videoid();
		%>
		<tr>
			<td align="center"><%=video.getTitle()%></td>
			<td align="center"><img alt="<%=video.getTitle()%>"
				src="<%=video.getImage()%>" /></td>
			<td align="center"><a href="edit.jsp?videoid=<%=videoId%>">编辑</a>|<a
				onclick="deletevideo(this.id);" href="#" id="<%=videoId%>">删除</a></td>
			<%
				if (video.getStatus().equals("OK")) {
						//可播放
			%>
			<td align="center">可播放</td>
			<td align="center"><a
				href="play.jsp?userid=<%=userId%>&videoid=<%=videoId%>"
				target="_blank">点击播放</a>
			</td>
			<td align="center"><a href="playcode.jsp?videoid=<%=videoId%>"
				target="_blank">查看代码</a>
			</td>
			<%
				} else {
						//不可播放
			%>
			<td align="center">不可播放</td>
			<td align="center">不可查看</td>
			<td align="center"></td>
			<%
				}
			%>
		</tr>
		<%
			}
		%>
	</table>
	<script type="text/javascript">
		function deletevideo(videoId) {
			var url = "delete.jsp?videoid=" + videoId;
			var req = getAjax();
			req.open("GET", url, true);
			req.onreadystatechange = function() {
				if (req.readyState == 4) {
					if (req.status == 200) {
						var re = req.responseText;//获取返回的内容
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