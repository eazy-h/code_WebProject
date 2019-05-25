package org.zerock.domain;

import java.sql.Date;

import lombok.Data;

@Data
public class BoardDTO {
	private long bno;
	private String title;
	private String content;
	private String writer;
	private Date regDate;
	private Date updateDate;
	
}
