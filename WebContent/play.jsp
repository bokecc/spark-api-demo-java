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
<h1>API java demo 视频播放</h1>
<hr />
<a href='videolist.jsp'>返回视频列表</a>
<hr />
<a href="#" onclick="player_play();">开始播放</a>
&nbsp;&nbsp;
<a href="#" onclick="player_pause();">暂停播放</a>
&nbsp;&nbsp;
<a href="#" onclick="player_resume();">恢复播放</a>
&nbsp;&nbsp;
<a href="#" onclick="player_seek();">拖动到10秒</a>
&nbsp;&nbsp;
<a href="#" onclick="player_duration();">获取片长</a>
&nbsp;&nbsp;
<a href="#" onclick="player_position();">获取当前播放位置</a>
&nbsp;&nbsp;
<hr />
<div id="swfDiv"></div>
<script type="text/javascript">
	//	功能：创建播放器flash，需传递所需参数，具体参数请参考api文档
	var swfobj=new SWFObject('http://union.bokecc.com/flash/player.swf', 'playerswf', '400', '300', '8');
	swfobj.addVariable( "userid" , "<%=request.getParameter("userid")%>");	//	partnerID,用户id
	swfobj.addVariable( "videoid" , "<%=request.getParameter("videoid")%>");	//	spark_videoid,视频所拥有的 api id
	swfobj.addVariable( "mode" , "api");	//	mode, 注意：必须填写，否则无法播放
	swfobj.addVariable( "autostart" , "false");	//	开始自动播放，true/false
	swfobj.addVariable( "jscontrol" , "true");	//	开启js控制播放器，true/false
	
	swfobj.addParam('allowFullscreen','true');
	swfobj.addParam('allowScriptAccess','always');
	swfobj.addParam('wmode','transparent');
	swfobj.write('swfDiv');

//	-------------------
//	调用者：flash
//	功能：播放器加载完毕时所调用函数
//	时间：2010-12-22
//	说明：用户可以加入相应逻辑
//	-------------------
	function on_spark_player_ready() {
		//alert("播放器加载完毕");
	}
	
//	-------------------
//	调用者：flash
//	功能：播放器开始播放时所调用函数
//	时间：2010-12-22
//	说明：用户可以加入相应逻辑
//	-------------------
	function on_spark_player_start() {
		//alert('开始播放');
	}
	
//	-------------------
//	调用者：flash
//	功能：播放器暂停时所调用函数
//	时间：2010-12-22
//	说明：用户可以加入相应逻辑
//	-------------------
	function on_spark_player_pause() {
		//alert('暂停播放');
	}
	
//	-------------------
//	调用者：flash
//	功能：播放器暂停后，继续播放时所调用函数
//	时间：2010-12-22
//	说明：用户可以加入相应逻辑
//	-------------------
	function on_spark_player_resume() {
		//alert('暂停后继续播放');
	}
	
//	-------------------
//	调用者：flash
//	功能：播放器播放停止时所调用函数
//	时间：2010-12-22
//	说明：用户可以加入相应逻辑
//	-------------------
	function on_spark_player_stop() {
		//alert('播放停止');
	}

	function player_play() { //	调用播放器开始播放函数
		document.getElementById("playerswf").spark_player_start();
	}
	function player_pause() { //	调用播放器暂停函数
		document.getElementById("playerswf").spark_player_pause();
	}
	function player_resume() { //	调用播放器恢复播放函数
		document.getElementById("playerswf").spark_player_resume();
	}
	function player_seek() { //	调用播放器拖动播放函数
		document.getElementById("playerswf").spark_player_seek(10);
	}
	function player_position() { //	调用播放器获取播放位置函数
		alert(document.getElementById("playerswf").spark_player_position() + "s");
	}
	function player_duration(){// 调用播放器获取片长函数
		alert(document.getElementById("playerswf").spark_player_duration() + "s");
	}
</script>
</body>
</html>