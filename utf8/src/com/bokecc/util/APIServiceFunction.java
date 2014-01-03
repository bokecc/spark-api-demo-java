package com.bokecc.util;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.UnsupportedEncodingException;
import java.net.MalformedURLException;
import java.net.URL;
import java.net.URLConnection;
import java.net.URLEncoder;
import java.util.Map;
import java.util.TreeMap;

/**
 * 功能：api接口公用函数
 * 详细：该页面是请求接口生成参数字符串的公用函数处理文件，不需要修改
 * 版本：1.0
 * 修改日期：2010-12-20
 * 作者：chu
 */
public class APIServiceFunction {

	/**
	 * 功能：将一个Map按照Key字母升序构成一个QueryString. 并且加入时间混淆的hash串。
	 * 
	 * @param queryMap
	 *            query内容
	 * @param time
	 *            加密时候，为当前时间；解密时，为从querystring得到的时间；
	 * @param salt
	 *            加密salt
	 * @return
	 */
	public static String createHashedQueryString(Map<String, String> queryMap,
			long time, String salt) {

		Map<String, String> map = new TreeMap<String, String>(queryMap);
		String qs = createQueryString(map);
		if (qs == null) {
			return null;
		}
		time = time / 1000;

		String hash = Md5Encrypt.md5(String.format("%s&time=%d&salt=%s", qs,
				time, salt));
		hash = hash.toLowerCase();
		String htqs = String.format("%s&time=%d&hash=%s", qs, time, hash);

		return htqs;
	}

	/**
	 * 功能：用一个Map生成一个QueryString，参数的顺序不可预知。
	 * 
	 * @param queryString
	 * @return
	 */
	public static String createQueryString(Map<String, String> queryMap) {

		if (queryMap == null) {
			return null;
		}

		try {
			StringBuilder sb = new StringBuilder();
			for (Map.Entry<String, String> entry : queryMap.entrySet()) {
				if (entry.getValue() == null) {
					continue;
				}
				String key = entry.getKey().trim();
				String value = URLEncoder.encode(entry.getValue().trim(),
						"utf-8");
				sb.append(String.format("%s=%s&", key, value));
			}
			return sb.substring(0, sb.length() - 1);
		} catch (StringIndexOutOfBoundsException e) {
			e.printStackTrace();
			return null;
		} catch (UnsupportedEncodingException e) {
			e.printStackTrace();
			return null;
		}
	}

	/**
	 * 功能：远程触发接口，返回响应结果
	 * 
	 * @param queryString
	 * @return
	 */
	public static String HttpRetrieve(String triggerURL) {
		StringBuffer document = new StringBuffer();
		try {
			URL url = new URL(triggerURL);
			URLConnection conn = url.openConnection();
			BufferedReader reader = new BufferedReader(new InputStreamReader(
					conn.getInputStream()));
			String line = null;
			while ((line = reader.readLine()) != null) {
				document.append(line);
			}
			reader.close();
		} catch (MalformedURLException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		}
		return document.toString();
	}

}
