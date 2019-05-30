package org.zerock.controller;

import java.io.File;
import java.net.URLDecoder;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.List;

import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import org.zerock.domain.BoardAttachVO;
import org.zerock.domain.BoardDTO;
import org.zerock.domain.Criteria;
import org.zerock.domain.PageDTO;
import org.zerock.service.BoardService;

import lombok.AllArgsConstructor;
import lombok.extern.log4j.Log4j;
import net.sf.jmimemagic.Magic;
import net.sf.jmimemagic.MagicMatch;

@Controller
@Log4j
@RequestMapping("/board/*")
@AllArgsConstructor
public class BoardController {
	
	private BoardService service;
	
//	@GetMapping("/list")
//	public void list(Model model) {
//		log.info("list");
//		model.addAttribute("list",service.getList());
//	}
	
	@GetMapping("/list")
	public void list(Model model, Criteria cri) {
		log.info("list : " + cri);
		model.addAttribute("list",service.getList(cri));
//		model.addAttribute("pageMaker", new PageDTO(cri, 123));
		int total = service.getTotal(cri);
		log.info("total : "+total);
		model.addAttribute("pageMaker",new PageDTO(cri,total));
	}
	
	//String 타입으로 한 이유는 글 등록 후 다시 목록화면으로 redirect하기 위함
	//리턴시 redirect를 입력하는 이유는 스프링MVC가 내부적으로 response.sendRedirect를 처리해줌
	@PostMapping("/register")
	@PreAuthorize("isAuthenticated()") //로그인 허용된 사용자만 /register 접근 가능 처리
	public String register(BoardDTO board, RedirectAttributes rttr) {
		log.info("register : "+board);
		
		if(board.getAttachList() != null) {
			board.getAttachList().forEach(attach ->log.info(attach));
		}
		
		service.register(board);
		rttr.addFlashAttribute("result",board.getBno());
		log.info("---------/register----------");
		return "redirect:/board/list";
	}
	
	//ModelAttribute는 자동으로 Model에 데이터를 지정한 이름으로 담는다("cri")
	@GetMapping({"/get","/modify"})
	public void get(Model model, @RequestParam("bno")Long bno, @ModelAttribute("cri") Criteria cri) {
		log.info("/get or modify");
		model.addAttribute("board",service.get(bno));
	}
	
	@PreAuthorize("principal.username == #board.writer")
	@PostMapping("/modify")
	public String modify(BoardDTO board, RedirectAttributes rttr, @ModelAttribute("cri") Criteria cri) {
		log.info("modify : "+board);
		if(service.modify(board)) {
			rttr.addFlashAttribute("result","success");
		}
		
		rttr.addAttribute("pageNum",cri.getPageNum());
		rttr.addAttribute("amount",cri.getAmount());
		rttr.addAttribute("type",cri.getType());
		rttr.addAttribute("keyword",cri.getKeyword());
		return "redirect:/board/list" + cri.getListLink();
	}
	
	@PreAuthorize("principal.username == #writer") 
	@PostMapping("/delete")
	public String remove(@RequestParam("bno")Long bno, RedirectAttributes rttr, @ModelAttribute("cri") Criteria cri, String writer) {
		log.info("delete : "+ bno);
		
		//게시물의 bno로 해당 첨부파일 리스트 가져오기
		List<BoardAttachVO> attachList = service.getAttachList(bno);
			
		if(service.remove(bno)) {
			deleteFiles(attachList);
			rttr.addFlashAttribute("result","success");
		}
		
		
		rttr.addAttribute("pageNum",cri.getPageNum());
		rttr.addAttribute("amount",cri.getAmount());
		rttr.addAttribute("type",cri.getType());
		rttr.addAttribute("keyword",cri.getKeyword());
		
		return "redirect:/board/list" + cri.getListLink();
	}	
	
	@PreAuthorize("isAuthenticated()")
	@GetMapping("/register")
	public void register() {
		
	}
	
	//리스트 보여주기(화면에 파일 첨부시)
	@GetMapping(value = "/getAttachList", produces = MediaType.APPLICATION_JSON_UTF8_VALUE)
	@ResponseBody
	public ResponseEntity<List<BoardAttachVO>> getAttachList(Long bno) {
		log.info("getAttachListBno : " + bno);

		return new ResponseEntity<>(service.getAttachList(bno),HttpStatus.OK);
		
	}
	
	//게시물 삭제 후 첨부파일 삭제
	private void deleteFiles(List<BoardAttachVO> attachList) {
	    
	    if(attachList == null || attachList.size() == 0) {
	      return;
	    }
	    
	    log.info("delete attach files" + attachList);
	    
	    attachList.forEach(attach -> {
	      
	    	File file;
	    	
	    try {        
	        String filePath  = attach.getUploadPath()+"/" + attach.getUuid()+"_"+ attach.getFileName();
	        
	        log.info("filePath ____________________ -----> : " + filePath);
//	        Files.deleteIfExists(filePath);
//	        
//	        File file = new File(attach.getUploadPath(), attach.getFileName());
	        file = new File(URLDecoder.decode(filePath,"UTF-8"));
	        
	        
	        Magic magic = new Magic();
	        MagicMatch match = magic.getMagicMatch(file,false);
			String mime = match.getMimeType();
			log.info("mime type : " + mime);
			
			file.delete();
			
	        if(mime.contains("image")) {
	        
	          String thumbnailPath= attach.getUploadPath()+"/s_" + attach.getUuid()+"_"+ attach.getFileName();
	          log.info("thumbnailPath Name : " + thumbnailPath);
	          
	          file = new File(URLDecoder.decode(thumbnailPath,"UTF-8"));
	          file.delete();
	        }
	
	      }catch(Exception e) {
	        log.error("delete file error" + e.getMessage());
	      }
	    });
	  }
	
	
}
