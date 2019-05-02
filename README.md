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
  -  



## Point

- @Service : ServiceImpl 클래스에 계층구조상 비지니스 영역을 담당하는 객체임을 표시
- @AllargsContstructor : 모든 파라미터를 이용하는 생성자를 만드는 어노테이션

```
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





## 문제해결

- @Log4j Import가 되지 않는 문제

  - `pom.xml` 의 `<dependencies>` 에 log4j 버전(1.2.17) 변경 및 `<exclusions>` , `<scope>` 제거 후 `maven Update`

- @Log4j  log.info 설정 후 콘솔에 로그 메세지 출력되지 않는 문제

  - 프로젝트 생성 후 톰캣 서버를 설정할 때 실행전  path 경로를 `/` 로 변경 후 프로젝트 실행 (path를 추후 변경시 출력되지 않음)

  