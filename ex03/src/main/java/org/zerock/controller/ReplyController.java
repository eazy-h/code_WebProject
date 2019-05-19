package org.zerock.controller;

import java.util.List;

import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;
import org.zerock.domain.Criteria;
import org.zerock.domain.ReplyPageDTO;
import org.zerock.domain.ReplyVO;
import org.zerock.service.ReplyService;

import lombok.AllArgsConstructor;
import lombok.extern.log4j.Log4j;

@RequestMapping("/replies/")
@RestController
@Log4j
@AllArgsConstructor
public class ReplyController {
	
	private ReplyService service;
	
	//댓글 insert
	@PostMapping(value = "/new",
			consumes = "application/json",
			produces = { MediaType.TEXT_PLAIN_VALUE })
	public ResponseEntity<String> create(@RequestBody ReplyVO vo) {
		log.info("ReplyVO : " + vo);
		int insertResult = service.register(vo);
		
		return insertResult == 1 ? new ResponseEntity<>("success", HttpStatus.OK) 
								 : new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
	}
	
	//댓글 리스트 가져오기
	@GetMapping(value = "/pages/{bno}/{page}",
			produces = { 
					MediaType.TEXT_XML_VALUE,
					MediaType.APPLICATION_JSON_UTF8_VALUE })
	public ResponseEntity<ReplyPageDTO> getList(@PathVariable("page") int page, @PathVariable("bno") Long bno) {
		
		Criteria cri = new Criteria(page,10);
		
		log.info("getList Board Num : " + bno);
		
		log.info("cri : " + cri);
		
		return new ResponseEntity<>(service.getListPage(cri, bno),HttpStatus.OK);
	}
	
	//댓글하나 가져오기
	@GetMapping(value = "/{rno}",
			produces = { 
					MediaType.TEXT_XML_VALUE,
					MediaType.APPLICATION_JSON_UTF8_VALUE })
	public ResponseEntity<ReplyVO> get(@PathVariable("rno") Long rno) {
		log.info("get Reply No : " + rno);
		
		return new ResponseEntity<>(service.get(rno),HttpStatus.OK);
	}
	
	//댓글 지우기
	@DeleteMapping(value = "/{rno}",
			produces = { MediaType.TEXT_PLAIN_VALUE })
	public ResponseEntity<String> delete(@PathVariable("rno") Long rno) {
		log.info("delete Reply No :" + rno);
		
		int deleteResult = service.delete(rno);
		
		return deleteResult == 1 
				 ? new ResponseEntity<>("success", HttpStatus.OK) 
				 : new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
	} 
	
	
	//댓글 수정
	@RequestMapping(method = { RequestMethod.PUT, RequestMethod.PATCH },
			value = "/{rno}",
			consumes = "application/json",
			produces = { MediaType.TEXT_PLAIN_VALUE })
	public ResponseEntity<String> modify(@RequestBody ReplyVO vo, @PathVariable("rno") Long rno) {
		
		//수정할 리플 번호를 세팅해준다.
		vo.setRno(rno);
		
		log.info("rno : " + rno);
		
		int modifyResult = service.modify(vo);
		return modifyResult == 1 
				 ? new ResponseEntity<>("success", HttpStatus.OK) 
				 : new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
		
	}
	
	
	
	
	

	
}
