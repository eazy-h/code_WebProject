# code_WebProject
>  코드로 배우는 스프링 웹프로젝트 서적을 보며 실습한 프로젝트입니다.



## 개발환경

- Mac OS mojave
- Java 8
- Tomcat 9
- Spring 5
- Oracle
- mybatis

## 주요기능

- 게시판 CRUD
- 검색, 페이징
- 게시물 댓글
- 파일 업로드
- 로그인,비밀번호 암호화
- Rest방식 테스트



## 핵심정리

- 영속영역(엔티티 혹은 데이터를 저장하고 관리하는 영역)
  - 테이블의 컬럼 구조를 반영하는 VO 객체
  - Mybatis의 Mapper 인터페이스의 작성 및 xml 처리
  - 작성한 Mapper 인터페이스 테스트

- 비지니스영역

  - 고객의 요구사항을 반영하는 계층 프레젠테이션 계층과 영속계층의 중간 다리역할

  - 비지니스 계층에서 인터페이스 구현 후 root-context에 service영역을 추가 

    - `namespace` -> `context` 체크 후 component-scan태그 사용

    

- 프레젠테이션영역
  
  -  웹이 구현영역 Controller내에서 여러 메소드를 작성 후 Mapping을 통해 URL로 분기하는 구조
  -  service 영역의 연동해야함으로 의존성 처리 @AllArgsConstructor 후 service 클래스 선언(Service에 의존하는 Controller)



## Point

- @Service : ServiceImpl 클래스에 계층구조상 비지니스 영역을 담당하는 객체임을 표시
- @AllargsContstructor : 모든 파라미터를 이용하는 생성자를 만드는 어노테이션
- @Controller : 컨트롤러클래스를 스프링 빈으로 등록
- @Log4j : 프로그램 실행중 로그를 남기기 위한 빈 등록
- @WebAppConfiguration : servlet의 servlet-context를 이용하기 위한 선언(WebApplicationContext 사용)
- @Before : 테스트 이전 매번 실행되는 메소드

```
//예시
package org.zerock.service;

import java.util.List;

import org.springframework.stereotype.Service;
import org.zerock.domain.BoardDTO;
import org.zerock.mapper.BoardMapper;

import lombok.AllArgsConstructor;
import lombok.extern.log4j.Log4j;

@Log4j
@Service	//표기 
@AllArgsConstructor	//BoardMapper를 주입받는 생성자 생성
public class BoardServiceImpl implements BoardService{

	private BoardMapper mapper;
	
	@Override
	public void register(BoardDTO board) {
		
	}

}

```



RestAPI

- @RestController : Controller가 REST 방식을 처리하기 위한 것을 명시
- @ResponseBody : 일반적인 view(jsp,asp)로 전달되는 것이 아니라 데이터 자체를 전달하는 용도
- @PathVariable : URL 경로에 있는 값을 파라미터로 사용할 때 사용
- @CrossOrigin : Ajax의 크로스 도메인 문제를 해결
- @RequestBody : JSON 데이터를 원하는 타입으로 Binding
- @ResponseEntity : 데이터와 함께 HTTP header의 상태메세지를 함께 전달



<br>







## 문제해결

- @Log4j Import가 되지 않는 문제

  - `pom.xml` 의 `<dependencies>` 에 log4j 버전(1.2.17) 변경 및 `<exclusions>` , `<scope>` 제거 후 `maven Update`

- @Log4j  log.info 설정 후 콘솔에 로그 메세지 출력되지 않는 문제

  - 프로젝트 생성 후 톰캣 서버를 설정할 때 실행전  path 경로를 `/` 로 변경 후 프로젝트 실행 (path를 추후 변경시 출력되지 않음)

  