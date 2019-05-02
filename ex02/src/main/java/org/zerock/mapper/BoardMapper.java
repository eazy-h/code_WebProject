package org.zerock.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Select;
import org.zerock.domain.BoardDTO;

public interface BoardMapper {

	public List<BoardDTO> getList();
	
	//insert만 할때
	public void insert(BoardDTO board);
	//insert 후 bno을 알아야 할 때
	public void insertSelectKey(BoardDTO board);
	//게시물 읽기
	public BoardDTO read(Long bno);
	//게시물 삭제
	public int delete(Long bno);
	//게시물 수정
	public int update(BoardDTO board);
}
