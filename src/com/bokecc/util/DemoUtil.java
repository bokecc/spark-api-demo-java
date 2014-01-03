package com.bokecc.util;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

import org.dom4j.Document;
import org.dom4j.DocumentHelper;
import org.dom4j.Element;

import com.bokecc.bean.Video;

/**
 * 功能：demo使用处理类
	 * 版本：2.1.2
	 * 日期：2013-11-13
 * 作者：chu
 **/
public class DemoUtil {
	
	public static List<String> NOTIFY_VIDEO_LIST = new ArrayList<String>();
	
	public static List<Video> SYNC_VIDEO_LIST = new ArrayList<Video>();

	/**
	 * 功能：将xml字符串转换成document对象
	 * 
	 * @param xmlString
	 * @return
	 */
	public static Document build(String xmlString) {
		Document doc = null;
		if (xmlString == null) {
			return doc;
		}
		try {
			doc = DocumentHelper.parseText(xmlString);
		} catch (Exception e) {
		}
		return doc;
	}

	/**
	 * 功能：解析获取视频信息接口得到的video节点
	 * 
	 * @param document
	 * @return
	 */
	public static void apiVideos_parseXML(Document document) {
		@SuppressWarnings("unchecked")
		Iterator<Element> videoElements = document.getRootElement()
				.elementIterator("video");
		if (videoElements == null)
			return;
		while (videoElements.hasNext()) {
			try {
				Element videoElement = videoElements.next();
				String videoid = videoElement.element("id").getTextTrim();
				if (videoid == null)
					continue;
				String title = videoElement.element("title").getTextTrim();
				if (title == null)
					title = "";
				String desp = videoElement.element("desp").getTextTrim();
				if (desp == null)
					desp = "";
				String tags = videoElement.element("tags").getTextTrim();
				if (tags == null)
					tags = "";
				String secondStr = videoElement.element("duration")
						.getTextTrim();
				if (secondStr == null)
					secondStr = "00:00:00";
				String image = videoElement.element("image").getTextTrim();
				if (image == null)
					image = "";

				String duration = DateUtil.turnSecondsToTimestring(Integer
						.parseInt(secondStr));
				Video video = new Video();
				video.setSpark_videoid(videoid);
				video.setDescription(desp);
				video.setDuration(duration);
				video.setImage(image);
				video.setStatus("OK");
				video.setTag(tags);
				video.setTitle(title);
				SYNC_VIDEO_LIST.add(video);

			} catch (Exception e) {
				e.printStackTrace();
			}
		}
	}

	public static float getFloat(String floatStr){
		float floatNum = 0;
		try {
			floatNum = Float.parseFloat(floatStr);
		} catch (NumberFormatException e) {
		} catch (NullPointerException e){
		}
		return floatNum;
	}
	public static void main(String[] args) {
	}

}
