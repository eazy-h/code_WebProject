package org.zerock.controller;

import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.springframework.test.context.web.WebAppConfiguration;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.request.MockMvcRequestBuilders;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;
import org.springframework.web.context.WebApplicationContext;
import org.zerock.mapper.BoardMapper;

import lombok.Setter;
import lombok.extern.log4j.Log4j;

@RunWith(SpringJUnit4ClassRunner.class)
@WebAppConfiguration
@ContextConfiguration({"file:src/main/webapp/WEB-INF/spring/root-context.xml","file:src/main/webapp/WEB-INF/spring/appServlet/servlet-context.xml"})
@Log4j
public class BoardControllerTests {
	
	@Autowired
	@Setter
	private WebApplicationContext ctx;
	
	//fake MVC 가짜 URL과 파라미터등을 브라우저에 사용하는것처럼 만들어 Controller를 실행함
	private MockMvc mockMvc;
	
	//테스트 이전 매번 실행되는 메소드
	@Before
	public void setup() {
		this.mockMvc = MockMvcBuilders.webAppContextSetup(ctx).build();
	}
	
//	@Test
//	public void testList() throws Exception {
//		log.info(mockMvc.perform(MockMvcRequestBuilders.get("/board/list"))
//		.andReturn()
//		.getModelAndView()
//		.getModelMap());
//	}
	
//	//post()방식을 이용하면 param을 통해 전달하는 파라미터를 테스트할 수 있다 insert, update는 String result로 받기
//	@Test
//	public void testRegister() throws Exception {
//		String resultPage = mockMvc.perform(MockMvcRequestBuilders.post("/board/register")
//				.param("title", "테스트 새글새글 제목")
//				.param("content", "테스트 새글새글 내용")
//				.param("writer", "글쓴이"))
//				.andReturn()
//				.getModelAndView()
//				.getViewName();
//		log.info(resultPage);
//	}
	
//	@Test
//	public void testGet() throws Exception {
//		log.info(mockMvc.perform(MockMvcRequestBuilders.get("/board/get")
//				.param("bno","2"))
//				.andReturn()
//				.getModelAndView()
//				.getModelMap()
//				);
//	}
	
//	@Test
//	public void testModify() throws Exception {
//		String resultPage = mockMvc.perform(MockMvcRequestBuilders.post("/board/modify")
//				.param("bno","1")
//				.param("title", "수정된 테스트 제목1")
//				.param("content", "수정된 테스트 내용1")
//				.param("writer", "updateUser00"))
//				.andReturn()
//				.getModelAndView()
//				.getViewName();
//		
//		log.info(resultPage);
//				
//	}
	
//	@Test
//	public void testDelete() throws Exception {
//		//삭제전 게시물 번호 확인
//		String resultPage = mockMvc.perform(MockMvcRequestBuilders.post("/board/delete")
//				.param("bno","21"))
//				.andReturn()
//				.getModelAndView()
//				.getViewName();
//		
//		log.info(resultPage);
//	}
	
	@Test
	public void testListPaging() throws Exception {
		log.info(mockMvc.perform(MockMvcRequestBuilders.get("/board/list")
				.param("pageNum","2")
				.param("amount","10"))
				.andReturn()
				.getModelAndView()
				.getModelMap()
				);
	}
}
