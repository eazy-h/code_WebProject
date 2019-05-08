package org.zerock.service;

import java.util.List;

import org.springframework.stereotype.Service;
import org.zerock.domain.BoardDTO;
import org.zerock.domain.Criteria;
import org.zerock.mapper.BoardMapper;

import lombok.AllArgsConstructor;
import lombok.extern.log4j.Log4j;

@Log4j
@Service
@AllArgsConstructor
public class BoardServiceImpl implements BoardService{

	private BoardMapper mapper;
	//insert
	@Override
	public void register(BoardDTO board) {
		log.info("register" + board);
		mapper.insertSelectKey(board);
	}
	//read (one)
	@Override
	public BoardDTO get(Long bno) {
		log.info("get..." + bno);
		return mapper.read(bno);
	}
	//update 
	@Override
	public boolean modify(BoardDTO board) {
		log.info("modify..."+board);
		return mapper.update(board)==1;
	}
	//delete
	@Override
	public boolean remove(Long bno) {
		log.info("remove Bno..."+bno);
		return mapper.delete(bno)==1;
	}
//	//전체 게시물 list
//	@Override
//	public List<BoardDTO> getList() {
//		log.info("getList......");
//		return mapper.getList();
//	}
	//전체 게시물 list + Paging
	@Override
	public List<BoardDTO> getList(Criteria cri) {
		log.info("getList..."+cri);
		return mapper.getListPaging(cri);
	}
	@Override
	public int getTotal(Criteria cri) {
		log.info("getTotal : "+cri);
		return mapper.getTotalCount(cri);
	}
	
	
}
