/**
 * 
 */

console.log("Reply Module");
var replyService = (function(){
	//댓글 추가
	function add(reply, callback, error){
		console.log("add reply!!!!!!!!");
		
		$.ajax({
			type : 'post',
			url : '/replies/new',
			data : JSON.stringify(reply),
			contentType : "application/json; charset=utf-8",
			success : function(result, status, xhr) {
				if(callback) {
					callback(result);
				}
			},
			error : function(xhr, status, er) {
				if(error) {
					error(er);
				}
			}
		})
	}
	
	//댓글 리스트 불러오기
	function getList(param, callback, error) {
		var bno = param.bno;
		var page = param.page || 1;
		
		$.getJSON("/replies/pages/" + bno + "/" + page + ".json",
			function(data) {
				if(callback) {
					callback(data.replyCnt, data.replyList);
				}
		}).fail(function(xhr, status, err) {
			if(error) {
				error();
			}
		}); 
	}
	
	//댓글 삭제
	function remove(rno, replyer, callback, error) {
		$.ajax({
			type : 'delete',
			url : '/replies/' + rno,
			data : JSON.stringify({rno:rno, replyer:replyer}),
			contentType : "application/json; charset=utf-8",
			success : function(deleteResult, status, xhr) {
				if(callback) {
					callback(deleteResult);
				}
			},
			error : function(xhr, status, er) {
				if(error) {
					error(er);
				}
			}
		})
	}
	
	//댓글 수정 
	function modify(reply, callback, error) {
		$.ajax({
			type : 'put',
			url : '/replies/' + reply.rno,
			data : JSON.stringify(reply),
			contentType : "application/json; charset=utf-8",
			success : function(result, status, xhr) {
				if(callback) {
					callback(result);
				}
			},
			error : function(xhr, status, er) {
				if(error) {
					error(er);
				}
			}
		});
	}
	
	//댓글 하나 가져오기
	function get(rno, callback, error) {
		$.get("/replies/" + rno + ".json", function(resultData){
			if(callback) {
				callback(resultData);
			}
		}).fail(function(xhr, status, err) {
			if(error) {
				error();
			}
		}); 
	}
	
	//댓글 시간 처리 함수
	function displayTime(timeValue) {
		var today = new Date();
		
		var gap = today.getTime() - timeValue;
		
		var dateObj = new Date(timeValue);
		
		var str = "";
		
		if(gap < (1000 * 60 * 60 * 24)) {
			var hh = dateObj.getHours();
			var mi = dateObj.getMinutes();
			var ss = dateObj.getSeconds();
			
			return [ (hh > 9 ? '' : '0') + hh, ':',
					 (mi > 9 ? '' : '0') + mi, ':', 
					 (ss > 9 ? '' : '0') + ss ].join('');
			
		} else {
			var yy = dateObj.getFullYear();
			var mm = dateObj.getMonth() + 1;
			var dd = dateObj.getDate();
			
			return [ yy, '/', (mm > 9 ? '' : '0') + mm, '/', (dd > 9 ? '' : '0') + dd ].join('');
			
		}
		
	};
	
	return {
		add : add,
		getList : getList,
		remove : remove,
		modify : modify,
		get : get,
		displayTime : displayTime
	};
	
})();