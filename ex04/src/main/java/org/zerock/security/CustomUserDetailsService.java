package org.zerock.security;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.zerock.domain.CustomUser;
import org.zerock.domain.MemberVO;
import org.zerock.mapper.MemberMapper;

import lombok.Setter;
import lombok.extern.log4j.Log4j;

@Log4j
public class CustomUserDetailsService implements UserDetailsService{

	@Autowired
	@Setter
	private MemberMapper mapper;

	
	@Override
	public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
		
		log.warn("Load UserName : " + username);
		
		MemberVO vo = mapper.read(username);
		
		log.warn("member mapper : " + vo);
		
		
		if(vo == null) {
			throw new UsernameNotFoundException(username);
		} else {
			return new CustomUser(vo);
		}
	}
	
	
}
