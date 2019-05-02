package org.zerock.controller;

import java.util.ArrayList;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import lombok.extern.log4j.Log4j;

@Controller
@RequestMapping("/sample/*")
@Log4j
public class SampleController {
	@RequestMapping("")
	public void basic() {
		log.info("basic...");
	}
	
	//list dto 로그 확인
	@GetMapping("/ex01")
	public String ex01(SampleDTO dto) {
		log.info("" + dto);
		return "ex01";
	}
	
	//list 로그 확인
	@GetMapping("/ex02List")
	public String ex02(@RequestParam("ids")ArrayList<String> ids) {
		log.info("" + ids);
		return "ex02";
	}
	
	//jsp확인
	@GetMapping("/ex03")
	public String ex03(SampleDTO dto, @ModelAttribute("page") int page) {
		log.info("" + dto);
		log.info("" + page);
		return "/sample/ex03";
	}
}
