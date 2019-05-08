package org.zerock.domain;

import lombok.Getter;
import lombok.ToString;

@Getter
@ToString
public class PageDTO {
	
	private int startPage;
	private int endPage;
	private boolean prev, next;
	private int total;
	private Criteria cri;
	
	public PageDTO(Criteria cri, int total) {
		//페이지 번호(pageNum), 데이터수(amount)
		this.cri = cri;
		this.total = total;
		//현재 페이지에서 보여줄 끝 페이지 번호
		this.endPage = (int) (Math.ceil(cri.getPageNum() / 10.0)) * 10;
		//현재 페이지에서 보여줄 시작 페이지 번호
		this.startPage = this.endPage - 9;
		//보여줄 페이지가 10개 단위가 아닐 시 끝페이지 번호 처리 
		int realEnd = (int) (Math.ceil((total * 1.0) / cri.getAmount()));
		if(realEnd<this.endPage) {
			this.endPage = realEnd;
		}
		this.prev = this.startPage > 1;
		this.next = this.endPage < realEnd;
	}
}
