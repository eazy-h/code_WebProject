package org.zerock.mapper;

import java.util.List;
import java.util.stream.IntStream;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.zerock.domain.Criteria;
import org.zerock.domain.ReplyVO;

import lombok.Setter;
import lombok.extern.log4j.Log4j;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration("file:src/main/webapp/WEB-INF/spring/root-context.xml")
@Log4j
public class ReplyMapperTests {
	
	@Autowired
	@Setter
	private ReplyMapper replyMapper;
	
	private Long[] bnoArr = { 458862L, 458842L, 458841L, 458840L, 458839L }; 
	
//	@Test
//	public void testMapper() {
//		
//		log.info(replyMapper);
//		
//	}
	
//	@Test
//	public void testInsert() {
//		
//		IntStream.rangeClosed(1, 10).forEach(i -> {			
//			ReplyVO vo = new ReplyVO();
//			
//			vo.setBno(bnoArr[i % 5]);
//			vo.setReply("댓글 테스트 내용 : "+ i);
//			vo.setReplyer("repley : " + i);
//			
//			replyMapper.insert(vo);
//		});
//	}
	
//	@Test
//	public void testRead() {
//		
//		Long targetRno = 5L;
//		
//		ReplyVO vo = replyMapper.read(targetRno);
//		
//		log.info(vo);
//	}
	
//	@Test
//	public void testDelete() {
//		
//		Long targetRno = 10L;
//		
//		int result = replyMapper.delete(targetRno);
//		
//		log.info("result 반환 결과 : " + result);
//	}
	
//	@Test
//	public void testUpdate() {
//		
//		Long targetRno = 9L;
//		
//		ReplyVO vo = replyMapper.read(targetRno);
//		
//		vo.setReply("Update Reply 내용");
//		
//		int result = replyMapper.update(vo);
//		
//		log.info(vo);
//		log.info("업데이트 카운트 " + result);
//		
//	}
	
//	@Test
//	public void testSelect() {
//		
//		Criteria cri = new Criteria();
//		
//		List<ReplyVO>replies = replyMapper.getListPaging(cri,bnoArr[0]);
//		
//		replies.forEach(reply -> log.info(reply));
//		
//	}
	
	@Test
	public void testList2() {
		
		Criteria cri = new Criteria(2,10);
		
		List<ReplyVO> replies = replyMapper.getListPaging(cri,458862L);
		
		replies.forEach(reply -> log.info(reply));
	}
}
