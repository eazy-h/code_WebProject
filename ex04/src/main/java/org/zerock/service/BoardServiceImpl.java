package org.zerock.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.zerock.domain.BoardAttachVO;
import org.zerock.domain.BoardDTO;
import org.zerock.domain.Criteria;
import org.zerock.mapper.BoardAttachMapper;
import org.zerock.mapper.BoardMapper;

import lombok.AllArgsConstructor;
import lombok.Setter;
import lombok.extern.log4j.Log4j;

@Log4j
@Service
public class BoardServiceImpl implements BoardService{

	//2개의mapper를 주입받아야함(게시글, 첨부파일)
	@Autowired
	@Setter
	private BoardMapper mapper;
	
	@Autowired
	@Setter
	private BoardAttachMapper attachMapper;
	
	//insert
	@Transactional
	@Override
	public void register(BoardDTO board) {
		log.info("register......." + board);
		//게시글 먼저 입력 후
		mapper.insertSelectKey(board);
		//첨부파일 없을때 처리
		if(board.getAttachList() == null || board.getAttachList().size() <=0 ) {
			return;
		}
		//첨부파일 있으면 처리
		board.getAttachList().forEach(attach -> {
	
			attach.setBno(board.getBno()); attachMapper.insert(attach);
			
			});
	}
	
	//read (one)
	@Override
	public BoardDTO get(Long bno) {
		log.info("get..." + bno);
		return mapper.read(bno);
	}
	
	//update
	@Transactional
	@Override
	public boolean modify(BoardDTO board) {
		log.info("modify..."+board);
		//파일 전체 삭제
		attachMapper.deleteAll(board.getBno());
		
		//수정 작업
		boolean modiResult = mapper.update(board) == 1;
		//수정이 성공하면 다시 파일첨부 insert
		if (modiResult && board.getAttachList() != null && board.getAttachList().size() > 0) {
			board.getAttachList().forEach(attach -> {
				attach.setBno(board.getBno());
				attachMapper.insert(attach);
			});
		}
		
		return modiResult;
	}
	//delete
	@Override
	public boolean remove(Long bno) {
		log.info("remove Bno..."+bno);
		attachMapper.deleteAll(bno);
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
	//전체 게시물의 수 가져오기
	@Override
	public int getTotal(Criteria cri) {
		log.info("getTotal : "+cri);
		return mapper.getTotalCount(cri);
	}
	//첨부파일 리스트 가져오기
	@Override
	public List<BoardAttachVO> getAttachList(Long bno) {
		return attachMapper.findByBno(bno);
	}
	
	
}
