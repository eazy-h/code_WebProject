package org.zerock.mapper;

import java.util.List;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.zerock.domain.BoardDTO;
import org.zerock.domain.Criteria;

import lombok.Setter;
import lombok.extern.log4j.Log4j;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration("file:src/main/webapp/WEB-INF/spring/root-context.xml")
@Log4j
public class BoardMapperTests {
	
	@Setter(onMethod_ = @Autowired)
	private BoardMapper boardMapper;
	
	//BoardMapper 쿼리 테스트 메소드 명으로 실행 
//	@Test
//	public void testGetList() {
//		boardMapper.getList().forEach(board -> log.info(board));
//	}
	
	//basic insert
//	@Test
//	public void testInsert() {
//		BoardDTO board = new BoardDTO();
//		board.setTitle("New title");
//		board.setContent("New content");
//		board.setWriter("new Writer");
//		
//		boardMapper.insert(board);
//		
//		log.info(board);
//	}
	
	//selectKey insert
//	@Test
//	public void testInsertSelectKey() {
//		BoardDTO board = new BoardDTO();
//		board.setTitle("셀렉트키 New title");
//		board.setContent("셀렉트키 New content");
//		board.setWriter("셀렉트키 new Writer");
//		
//		boardMapper.insertSelectKey(board);
//		
//		log.info(board);
//	}
	
	//readOne
//	@Test
//	public void testRead() {
//		BoardDTO board = boardMapper.read(5L);
//		log.info(board);
//	}
	
	//delete
//	@Test
//	public void testDelete() {
//		log.info("delete Count : "+boardMapper.delete(3L));
//	}
	
	//update
//	@Test
//	public void testUpdate() {
//		BoardDTO board = new BoardDTO();
//		board.setBno(5L);
//		board.setTitle("수정된 제목");
//		board.setContent("수정된 내용");
//		board.setWriter("수정될 일 없는 작성자");
//		int count=boardMapper.update(board);
//		log.info("update Count : "+count);
//	}
	
	//paging test
	@Test
	public void pagingTest() {
		Criteria criteria = new Criteria();
		criteria.setPageNum(3);
		criteria.setAmount(10);
		List<BoardDTO>list = boardMapper.getListPaging(criteria);
		list.forEach(board-> log.info(board.getBno()));
	}
}
