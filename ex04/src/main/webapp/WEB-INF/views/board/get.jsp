<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<%@ include file="../includes/header.jsp" %>
<style>
.uploadResult {
  width:100%;
  background-color: gray;
}
.uploadResult ul{
  display:flex;
  flex-flow: row;
  justify-content: center;
  align-items: center;
}
.uploadResult ul li {
  list-style: none;
  padding: 10px;
  align-content: center;
  text-align: center;
}
.uploadResult ul li img{
  width: 100px;
}
.uploadResult ul li span {
  color:white;
}
.bigPictureWrapper {
  position: absolute;
  display: none;
  justify-content: center;
  align-items: center;
  top:0%;
  width:100%;
  height:100%;
  background-color: gray; 
  z-index: 100;
  background:rgba(255,255,255,0.5);
}
.bigPicture {
  position: relative;
  display:flex;
  justify-content: center;
  align-items: center;
}

.bigPicture img {
  width:600px;
}

</style>
	<div class="row">
          <div class="col-lg-12">
              <h1 class="page-header">Board Register</h1>
          </div>
          <!-- /.col-lg-12 -->
    </div>
	       <!-- /.row -->
	       <div class="row">
	           <div class="col-lg-12">
	               <div class="panel panel-default">
	                   <div class="panel-heading">
	                       Board Modify Page
	                   </div>
	                   <div class="panel-body">
                          	<div class="form-group">
                                  <label>BoardNo</label>
                                  <input class="form-control" name="bno" value="<c:out value='${board.bno}'/>" readonly>
                              </div>
                              <div class="form-group">
                                  <label>Title</label>
                                  <input class="form-control" name="title" value="<c:out value='${board.title}'/>" readonly >
                              </div>
                              <div class="form-group">
                                  <label>Text Area</label>
                                  <textarea class="form-control" rows="3" name="content" readonly><c:out value='${board.content}'/>
                                  </textarea>
                              </div>
                              <div class="form-group">
                                  <label>Writer</label>
                                  <input class="form-control" name="writer" value="<c:out value='${board.writer }'/>" readonly >
                              </div>
                              <sec:authentication property="principal" var="pinfo"/>
                              <sec:authorize access="isAuthenticated()">
                              	<c:if test="${ pinfo.username eq board.writer}">
	                              	<button data-oper="modify" class="btn btn-default">Modify</button>
                              	</c:if>
                              </sec:authorize>
                              <button data-oper="list" class="btn btn-info">List</button>
	                       <!-- /.col-lg-6 (nested) -->
	                       <form id="operForm" action="/board/modify" method="get">
	                       	<input type="hidden" id='bno' name='bno' value='<c:out value="${board.bno}"/>'>
	                       	<input type="hidden" name="pageNum" value="<c:out value='${cri.pageNum}'/>">
	                       	<input type="hidden" name="amount" value="<c:out value='${cri.amount}'/>">
	                       	<input type="hidden" name="type" value="${cri.type}">
                  			<input type="hidden" name="keyword" value="${cri.keyword}">
	                       </form> 
	                   </div>
	                   <!-- /.panel-body -->
	                   
	               </div>
	               <!-- /.panel -->
	               
	               <div class="row">
					  <div class="col-lg-12">
					    <div class="panel panel-default">
					
					      <div class="panel-heading">Files</div>
					      <!-- /.panel-heading -->
					      <div class="panel-body">
					        <!-- 첨부파일 목록 view -->
					        <div class='uploadResult'> 
					          <ul>
					          </ul>
					        </div>
					      </div>
					      <!--  end panel-body -->
					    </div>
					    <!--  end panel-body -->
					  </div>
					  <!-- end panel -->
					</div>
					<!-- /.row -->
	              
	              <!-- Reply -->
	   <div class="panel panel-default">
		<div class="panel-heading">
			<i class="fa fa-comments fa-fw"></i>Reply
			 <sec:authorize access="isAuthenticated()">
				<button id='addReplyBtn' class='btn btn-primary btn-xs pull-right'>New Reply</button>
			 </sec:authorize>
		</div>
		
		<div class="panel-body">
			<ul class="chat">
				
	         </ul>
	    </div>
	        <div class="panel-footer">
	            	
	        </div>
	     </div>
   </div>
     <!-- /.col-lg-12 -->
 </div>
 <!-- /.row -->
	       
	        <!-- Modal -->
	        <div class="modal fade" id="myModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
	            <div class="modal-dialog">
	                <div class="modal-content">
	                    <div class="modal-header">
	                        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
	                        <h4 class="modal-title" id="myModalLabel">Modal title</h4>
	                    </div>
	                    <div class="modal-body">
	                    	<div class="from-group">
	                    		<label>Reply</label>
	                    		<input class="form-control" name="reply" value="New Reply!!">
	                    	</div>
	                    	<div class="from-group">
	                    		<label>Replyer</label>
	                    		<input class="form-control" name="replyer" value="replyer">
	                    	</div>
	                    	<div class="from-group">
	                    		<label>Reply Date</label>
	                    		<input class="form-control" name="replyDate" value="">
	                    	</div>
	                    </div>
	                    <div class="modal-footer">
	                        <button id="modalModifyBtn" type="button" class="btn btn-warning" data-dismiss="modal">Modify</button>
	                        <button id="modalRemoveBtn" type="button" class="btn btn-danger" data-dismiss="modal">Remove</button>
	                        <button id="modalRegisterBtn" type="button" class="btn btn-primary" data-dismiss="modal">Register</button>
	                        <button id="modalCloseBtn" type="button" class="btn btn-default" data-dismiss="modal">Close</button>
	                    </div>
	                </div>
	                <!-- /.modal-content -->
	            </div>
	            <!-- /.modal-dialog -->
	        </div>
	        <!-- /.modal -->
	        
	        <div class='bigPictureWrapper'>
			  <div class='bigPicture'>
			  </div>
			</div>
        <script type="text/javascript" src="/resources/js/reply.js"></script>    
        <script type="text/javascript">
        	$(document).ready(function(){
        		/* 테스트코드 
        		
        		console.log("-----------");
        		console.log("JS Test");
        		
        		var bnoValue = '<c:out value = "${board.bno}"/>';
        		
        		replyService.add(
        			{reply : "JS Test", replyer : "tester", bno : bnoValue}
        			,
        			function(result) {
        				alert("Result : " + result);
        			}
        		);
        		
        		replyService.getList({bno : bnoValue, page : 1}, function(list) {
        			
        			for(var i = 0, len = list.length||0; i < len; i++) {
        				console.log(list[i]);
        			}
        		});
        		
        		replyService.remove(24, function(resultCount) {
        			
        			console.log(resultCount);
        			
        			if(resultCount==="success"){        				
        				alert("RemoveResult : " + resultCount);
        			}
        		}, function(err) {
        			alert('Error !!!!!!');
        		}); 
        		
        		 replyService.modify({
        			rno : 23,
        			reply : "수정된 댓글",
        			replyer : "미니쿠퍼",
        			bno : bnoValue}, function(result) {
        				alert("수정 완료!!");
        			}); 
        		
        		
        		replyService.get(7, function(resultData) {
        			console.log(resultData);	
        		}); */
        		
        		//게시글 번호 가져오기
        		var bnoValue = '<c:out value = "${board.bno}"/>';

        		//게시물 조회 파일첨부(즉시실행함수)
        		(function() {
        			$.getJSON("/board/getAttachList", {bno:bnoValue}, function(arr){
        				
        				console.log(arr);
        				var str ="";
        				
        				$(arr).each(function(i, attach){
     				       
       			         //파일 이미지 여부
       			         if(attach.fileType){
       			           var fileCallPath =  encodeURIComponent(attach.uploadPath + "/s_" + attach.uuid + "_" + attach.fileName);
       			           
       			           str += "<li data-path='"+attach.uploadPath+"' data-uuid='"+attach.uuid+"' data-filename='"+attach.fileName+"' data-type='"+attach.fileType+"' ><div>";
       			           str += "<img src='/display?fileName="+fileCallPath+"'>";
       			           str += "</div>";
       			           str +"</li>";
       			         } else {
       			             
       			           str += "<li data-path='" + attach.uploadPath + "' data-uuid='" + attach.uuid + "' data-filename='" + attach.fileName + "' data-type='" + attach.fileType + "' ><div>";
       			           str += "<span> "+ attach.fileName + "</span><br/>";
       			           str += "<img src='/resources/img/attach.png'></a>";
       			           str += "</div>";
       			           str +"</li>";
       			         }
       			       });
       			       
       			       $(".uploadResult ul").html(str);
        			}); 
        		})();
        		
        		
        		//첨부파일 클릭 후 이벤트
        		$(".uploadResult").on('click','li', function(e){
        			console.log("view Img");
        			
        			var liObj = $(this);
        			//파일경로
        			var path = encodeURIComponent(liObj.data("path") + "/" + liObj.data("uuid") + "_" + liObj.data("filename"));
        			
        			if(liObj.data('type')) {
        				showImage(path.replace(new RegExp(/\\/g),"/"));
        			} else {
        				self.location = "/download?fileName=" + path;
        			}
        		});
        		
        		//보여주기
        		function showImage(fileCallPath) {
        			/* alert(fileCallPath); */
        			
        			$(".bigPictureWrapper").css("display","flex").show();
        			    
       			    $(".bigPicture").html("<img src='/display?fileName="+fileCallPath+"' >")
       			    .animate({width:'100%', height: '100%'}, 700);
       			    
	       			$(".bigPictureWrapper").on("click", function(e){
	       			   $(".bigPicture").animate({width:'0%', height: '0%'}, 800);
	       			   setTimeout(function(){
	       			   $('.bigPictureWrapper').hide();
	       			    }, 800);
	       			});
        		}
        		
        		
        		
        		//댓글 html 기준
        		var replyUL = $('.chat');
        		
        		//댓글 초기화리스트
        		showList(1);
        		
        		function showList(page) {
        			replyService.getList({bno : bnoValue, page : page||1 }, function(replyCnt,replyList) {
        				
        				console.log("replyCnt : " + replyCnt);
        				console.log("replyList : " + replyList);
        				
        				if(page == -1) {
        					pageNum = Math.ceil(replyCnt/10.0);
        					showList(pageNum);
        					return;
        				}
        				
        				var str="";
        				if(replyList == null || replyList.length == 0) {
        					replyUL.html("");
        					
        					return;
        				}
        				
        				for(var i = 0, len = replyList.length || 0; i<len; i++) {
        					str += "<li class='left clearfix' data-rno='" + replyList[i].rno + "'>";
        					str += "<div><div class='header'><strong class='primary-font'>" + replyList[i].replyer + "</strong>";
        					str += "<small class='pull-right text-muted'>" + replyService.displayTime(replyList[i].replyDate) + "</small></div>";
        					str += "<p>" + replyList[i].reply + "</p></div></li>";
        				}
        				
        				replyUL.html(str);
        				//댓글 페이징 불러오기
        				showReplyPage(replyCnt);
        			});
        		}
        		
        		//modal창
        		var modal = $('.modal');
        		var modalInputReply = modal.find("input[name='reply']");
        		var modalInputReplyer = modal.find("input[name='replyer']");
        		var modalInputReplyDate = modal.find("input[name='replyDate']");
        		
        		var modalModifyBtn = $('#modalModifyBtn');
        		var modalRemoveBtn = $('#modalRemoveBtn');
        		var modalRegisterBtn = $('#modalRegisterBtn');
        		
        		$('#addReplyBtn').on('click',function(){
        			
        			modal.find("input").val(""); 
	        		modalInputReplyDate.closest("div").hide();
	        		modal.find('button[id != "modalCloseBtn"]').hide();
	        		
	        		modalRegisterBtn.show();
	        		$('.modal').modal('show');
	        		
        		});
        		
        		//댓글 추가 처리
        		modalRegisterBtn.on('click', function(){
        			var reply = {
        				 reply : modalInputReply.val(),
        				 replyer : modalInputReplyer.val(),
        				 bno : bnoValue
        				};
        			
        			replyService.add(reply,function(result){
						
        				alert(result);
						
						modal.find("input").val("");
						modal.modal("hide");
						
						//댓글 등록 후 리스트 갱신
						/* showList(1); */
						showList(-1);
						
        			});
        		  
        		});
        		
        		//댓글 가져오기
        		$('.chat').on('click', 'li', function(){
        			var rno = $(this).data("rno");
        			
        			replyService.get(rno, function(reply){
        				modalInputReply.val(reply.reply);
        				modalInputReplyer.val(reply.replyer);
        				modalInputReplyDate.val(replyService.displayTime(reply.replyDate)).attr("readonly","readonly");
	        			modal.data("rno",reply.rno);
	        			
	        			
	        			modal.find('button[id != "modalCloseBtn"]').hide();
	        			modalRemoveBtn.show();
	        			modalModifyBtn.show();
	        			
	        			$('.modal').modal('show');
        			});
        			
        		});
        		
        		//댓글 수정
        		modalModifyBtn.on('click', function(){
        			var reply = {rno : modal.data("rno"), reply : modalInputReply.val()};
        			
        			replyService.modify(reply, function(result){
        				
        				alert(result);
        				modal.modal("hide");
        				showListp(pageNum);
        				
        			})
        		});
        		
        		//댓글 삭제
        		modalRemoveBtn.on('click', function(){
        			var rno = modal.data("rno");
        			
        			replyService.remove(rno, function(result){
        			
        				alert(result);
        				modal.modal("hide");
        				showList(pageNum);
        				
        			})
        		});
        		
        		
        		//댓글 페이징 화면 코드
        		var pageNum = 1;
       		    var replyPageFooter = $(".panel-footer");
       		    
       		    function showReplyPage(replyCnt){
       		      
       		      var endNum = Math.ceil(pageNum / 10.0) * 10;  
       		      var startNum = endNum - 9; 
       		      
       		      var prev = startNum != 1;
       		      var next = false;
       		      
       		      if(endNum * 10 >= replyCnt){
       		        endNum = Math.ceil(replyCnt/10.0);
       		      }
       		      
       		      if(endNum * 10 < replyCnt){
       		        next = true;
       		      }
       		      
       		      var str = "<ul class='pagination pull-right'>";
       		      
       		      if(prev){
       		        str+= "<li class='page-item'><a class='page-link' href='"+(startNum -1)+"'>Previous</a></li>";
       		      }
       		      
       		      for(var i = startNum ; i <= endNum; i++){
       		        
       		        var active = pageNum == i? "active":"";
       		        
       		        str+= "<li class='page-item "+active+" '><a class='page-link' href='"+i+"'>"+i+"</a></li>";
       		      }
       		      
       		      if(next){
       		        str+= "<li class='page-item'><a class='page-link' href='"+(endNum + 1)+"'>Next</a></li>";
       		      }
       		      
       		      str += "</ul>";
       		      
       		      console.log(str);
       		      
       		      replyPageFooter.html(str);
       		    }
       		    
       		    //댓글 페이지 번호 클릭시 처리
       		 	replyPageFooter.on('click','li a',function(e){
       		 		e.preventDefault();
       		 		var targetPageNum = $(this).attr("href");
       		 		
       		 		pageNum = targetPageNum;
       		 		showList(pageNum);
       		 		
       		 	});
        		
        		
        				
        	});
        </script>
        <script type="text/javascript">
			$(document).ready(function(){
				var operForm = $('#operForm');
				
				$("button[data-oper='modify']").on('click',function(e){
					operForm.attr("action", "/board/modify").submit();
				});
				
				$("button[data-oper='list']").on('click',function(e){
					operForm.find("#bno").remove();
					operForm.attr("action", "/board/list");
					operForm.submit();
				});
			});
		</script>



<%@include file="../includes/footer.jsp" %>