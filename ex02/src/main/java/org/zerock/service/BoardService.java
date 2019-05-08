package org.zerock.service;

import java.util.List;

import org.zerock.domain.BoardDTO;
import org.zerock.domain.Criteria;

public interface BoardService {
	
	public void register(BoardDTO board);
	public BoardDTO get(Long bno);
	public boolean modify(BoardDTO board);
	public boolean remove(Long bno);
//	public List<BoardDTO> getList();
	public List<BoardDTO> getList(Criteria cri);
	public int getTotal(Criteria cri);
}
