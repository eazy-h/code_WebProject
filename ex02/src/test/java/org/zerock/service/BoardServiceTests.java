package org.zerock.service;

import static org.junit.Assert.assertNotNull;
import static org.junit.Assert.assertNull;

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
public class BoardServiceTests {
	
	
	@Setter(onMethod_ = @Autowired)
	private BoardService service;
	
//	@Test
//	public void testExist() {
//		log.info(service);
//		assertNotNull(service);
//	}
	
//	@Test
//	public void testRegister() {
//		BoardDTO board = new BoardDTO();
//		
//		board.setTitle("새로운 제목 1");
//		board.setContent("새로운 내용 1");
//		board.setWriter("새로운 작성자 1");
//		
//		service.register(board);
//		
//		log.info("생성된 게시물 번호 : "+board.getBno());
//	}
	
	@Test
	public void testGetList() {
//		service.getList().forEach(board -> log.info(board));
		service.getList(new Criteria(2,10)).forEach(board -> log.info(board));
	}
	
//	@Test
//	public void testGet() {
//		log.info(service.get(1L));
//	}
	
//	@Test
//	public void  testUpdate() {
//		BoardDTO board = service.get(2L);
//		if(board!=null) {			
//			log.info(service.modify(board));
//		}else {
//			return ;
//		}
//	}
	
//	@Test
//	public void  testDelete() {
//		if(service.get(6L)!=null) {
//			log.info(service.remove(6L));			
//		}else {
//			return ;
//		}
//	}
}
