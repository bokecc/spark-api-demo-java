package com.bokecc.bean;

/**
 * 功能：视频包装类，用来对视频数据进行封装 
 * 版本：1.0 
 * 日期：2010-12-21 
 * 作者：chu 
 **/
public class Video {

	private int id;
	private String spark_videoid;
	private String title;
	private String description;
	private String tag;
	private String status;
	private String duration;
	private String image;

	public Video() {
	}

	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}

	public String getSpark_videoid() {
		return spark_videoid;
	}

	public void setSpark_videoid(String spark_videoid) {
		this.spark_videoid = spark_videoid;
	}

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}

	public String getDuration() {
		return duration;
	}

	public void setDuration(String duration) {
		this.duration = duration;
	}

	public String getImage() {
		return image;
	}

	public void setImage(String image) {
		this.image = image;
	}

	public String getTitle() {
		return title;
	}

	public void setTitle(String title) {
		this.title = title;
	}

	public String getDescription() {
		return description;
	}

	public void setDescription(String description) {
		this.description = description;
	}

	public String getTag() {
		return tag;
	}

	public void setTag(String tag) {
		this.tag = tag;
	}

}
