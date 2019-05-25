package org.zerock.controller;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.net.URLDecoder;
import java.nio.file.Files;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

import org.springframework.core.io.FileSystemResource;
import org.springframework.core.io.Resource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.FileCopyUtils;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.zerock.domain.AttachFileVO;

import lombok.extern.log4j.Log4j;
import net.coobird.thumbnailator.Thumbnailator;
import net.sf.jmimemagic.Magic;
import net.sf.jmimemagic.MagicMatch;

@Controller
@Log4j
public class UploadController {
	
	
	//이미지파일 확인
	private boolean checkImgType(File file) {
				
		try {
			
			Magic magic = new Magic();
			MagicMatch match = magic.getMagicMatch(file,false);
			String mime = match.getMimeType();
			log.info("mime type : " + mime);
			return mime.contains("image");
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return false;
	}
	 
	
	@GetMapping("/uploadForm")
	public void uploadForm() {
		log.info("uploadForm getMapping");
	}
	
	@PostMapping("/uploadFormAction")
	public void uploadFormPost(MultipartFile[] uploadFile) {
	
		String uploadFolderLoc = "/Users/lj/Documents/upload/temps";
		
		for(MultipartFile multipartFile : uploadFile) {
			
			log.info("=====================MultipartFile=====================");
			log.info("Origin fileName : " + multipartFile.getOriginalFilename());
			log.info("Origin file Size : " + multipartFile.getSize());
			
			File saveFile = new File(uploadFolderLoc, multipartFile.getOriginalFilename());
			try {
				multipartFile.transferTo(saveFile);
			} catch (Exception e) {
				log.info(e.getMessage());
			}
		}
	}
	
	@GetMapping("/uploadAjax")
	public void uploadAjax() {
		log.info("upload ajax");
	}
	
	//ajax로 파일 업로드 insert
	@PostMapping(value = "/uploadAjaxAction", produces = MediaType.APPLICATION_JSON_UTF8_VALUE)
	public ResponseEntity<List<AttachFileVO>> uploadAjaxPost(MultipartFile[] uploadFile) {
		
		List<AttachFileVO> list = new ArrayList<>();
		
		log.info("Post Ajax File Upload");
		
		String uploadFolderLoc = "/Users/lj/Documents/upload/temps";
		
		
		for(MultipartFile multipartFile : uploadFile) {
			
			AttachFileVO vo = new AttachFileVO();
			
			log.info("=====================MultipartFile=====================");
			log.info("Origin fileName : " + multipartFile.getOriginalFilename());
			log.info("upload file Size : " + multipartFile.getSize());
			
			String uploadFileName = multipartFile.getOriginalFilename();
			
			vo.setFileName(uploadFileName);
			
			//파일 중복 제거
			UUID uuid = UUID.randomUUID(); 
					
			uploadFileName=uuid.toString() + "_" +  uploadFileName;
			
			//파일 저장 (loc, fileName)
			
			log.info("save fileName : " + uploadFileName);
			
			try {
				//파일 저장
				File saveFile = new File(uploadFolderLoc, uploadFileName);
				multipartFile.transferTo(saveFile);
				
				vo.setUploadPath(uploadFolderLoc);
				vo.setUuid(uuid.toString());
				
				//체크 이미지 파일(썸네일)
				if(checkImgType(saveFile)) {
					
					vo.setImage(true);
					
					FileOutputStream thumbnail = new FileOutputStream(new File(uploadFolderLoc,"s_" + uploadFileName));
					Thumbnailator.createThumbnail(multipartFile.getInputStream(), thumbnail, 100, 100);
					thumbnail.close();
				}
				
				
				list.add(vo);
				
			} catch (Exception e) {
				log.info(e.getMessage());
			}
			
		}
		
		return new ResponseEntity<>(list,HttpStatus.OK);
	}
	
	@PostMapping("deleteFile")
	@ResponseBody
	public ResponseEntity<String> deleteFile(String fileName, String type) {
		log.info("Delete File Name : " + fileName);
		
		File file;
		
		//일반 파일 삭제시
		try {

			file = new File(URLDecoder.decode(fileName,"UTF-8"));
			
			file.delete();
			
			//이미지 삭제시 썸네일도 검증
			if(type.equals("image")) {
				
				String largeFileName = file.getAbsolutePath().replace("s_","");
				
				log.info("largeFile Name : " + largeFileName);
				
				file = new File(largeFileName);
				
				file.delete();
			}
			
		} catch (Exception e) {
			e.printStackTrace();
			return new ResponseEntity<>(HttpStatus.NOT_FOUND);
		}
		
		return new ResponseEntity<String>("deleted",HttpStatus.OK);
	}
	
	//다운로드 처리
	@GetMapping(value="/download", produces = MediaType.APPLICATION_OCTET_STREAM_VALUE)
	@ResponseBody
	public ResponseEntity<Resource> downFile(String fileName) {
		log.info("download file : " + fileName);
		
		Resource resource = new FileSystemResource(fileName);
		
		log.info("resource : " + resource);
		
		String resourceName = resource.getFilename();
		String resourceOriginName = resourceName.substring(resourceName.indexOf("_")+1);
		
		log.info("resourceName : " + resourceName);
		log.info("resourceOriginName : " + resourceOriginName);
		
		HttpHeaders headers = new HttpHeaders();
		
		try {
			//헤더에 전송
			headers.add("Content-Disposition", "attachment; filename=" + new String(resourceOriginName.getBytes("UTF-8"), "ISO-8859-1"));
		} catch (UnsupportedEncodingException e) {
			e.printStackTrace();
		}
		
		return new ResponseEntity<Resource>(resource,headers,HttpStatus.OK);
	}
	
	//썸네일 이미지 보여주기
	@GetMapping("/display")
	@ResponseBody
	public ResponseEntity<byte[]> getFile(String fileName) {
		log.info("fileName : " + fileName);
		
		File file = new File(fileName);
		
		log.info("file: " +file);
		
		ResponseEntity<byte[]> result = null;
		
		
		try {
			HttpHeaders header = new HttpHeaders();
			header.add("Content-Type", Files.probeContentType(file.toPath()));
			result = new ResponseEntity<>(FileCopyUtils.copyToByteArray(file),header,HttpStatus.OK);
			
		} catch (IOException e) {

			e.printStackTrace();
			
		}
		return result;
		
	}

}
