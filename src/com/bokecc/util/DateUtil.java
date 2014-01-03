package com.bokecc.util;

import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;

/**
 * 功能：自定义时间处理类
 * 版本：1.0
 * 日期：2010-12-21
 * 作者：chu
 **/
public class DateUtil {
	// 获取日期，格式：yyyy-MM-dd HH:mm:ss
	public static String getDateFormatter() {
		Date date = new Date();
		DateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		return df.format(date);
	}

	// 秒转换成两位的时间，格式：HH:mm:ss
	public static String turnSecondsToTimestring(int seconds) {
		String result = "";
		int hour = 0, min = 0, second = 0;
		hour = seconds / 3600;
		min = (seconds - hour * 3600) / 60;
		second = seconds - hour * 3600 - min * 60;
		if (hour < 10) {
			result += "0" + hour + ":";
		} else {
			result += hour + ":";
		}
		if (min < 10) {
			result += "0" + min + ":";
		} else {
			result += min + ":";
		}
		if (second < 10) {
			result += "0" + second;
		} else {
			result += second;
		}

		return result;

	}

	public static void main(String[] args) {
		System.out.println(DateUtil.turnSecondsToTimestring(61));
	}

}
