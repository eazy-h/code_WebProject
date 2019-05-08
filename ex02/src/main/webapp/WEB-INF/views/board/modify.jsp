<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ include file="../includes/header.jsp" %>

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
                            Board Register
                        </div>
                        <div class="panel-body">
                                    <form role="form" action="/board/modify" method="post">
	                                    <input type="hidden" name="pageNum" value='<c:out value="${cri.pageNum}"/>'>
	                                    <input type="hidden" name="amount" value='<c:out value="${cri.amount}"/>'>
                                    	<div class="form-group">
                                            <label>BoardNo</label>
                                            <input class="form-control" name="bno" value="<c:out value='${board.bno}'/>" readonly>
                                        </div>
                                        <div class="form-group">
                                            <label>Title</label>
                                            <input class="form-control" name="title" value="<c:out value='${board.title}'/>"  >
                                        </div>
                                        <div class="form-group">
                                            <label>Text Area</label>
                                            <textarea class="form-control" rows="3" name="content"><c:out value='${board.content}'/>
                                            </textarea>
                                        </div>
                                        <div class="form-group">
                                            <label>Writer</label>
                                            <input class="form-control" name="writer" value="<c:out value='${board.writer }'/>" readonly>
                                        </div>
                                        <button type="submit" data-oper="modify" class="btn btn-default">Modify</button>
                                        <button type="submit" data-oper="remove" class="btn btn-danger">Remove</button>
                                        <button type="submit" data-oper="list" class="btn btn-info">List</button>
                                    </form>
                                <!-- /.col-lg-6 (nested) -->
                        </div>
                        <!-- /.panel-body -->
                    </div>
                    <!-- /.panel -->
                </div>
                <!-- /.col-lg-12 -->
            </div>
            <!-- /.row -->

	<script type="text/javascript">
		$(document).ready(function(){
			var formObj = $("form");
			
			$('button').on("click",function(e){
				//발생한 이벤트 취소
				e.preventDefault();
				//data-oper의 속성값
				var operation = $(this).data("oper");
				console.log(operation);
				
				if(operation === 'remove'){
					formObj.attr("action","/board/delete");
				
				}else if(operation === 'list'){
					formObj.attr("action","/board/list").attr("method","get");
					// name의 요소를 복사 후 
					var pageNumTag=$("input[name='pageNum']").clone();
					var amountTag=$("input[name='amount']").clone();
					
					formObj.empty();
					
					formObj.append(pageNumTag);
					formObj.append(amountTag);
				}
				//form 이벤트를 취소했기에 다시 submit을 해준다.
				formObj.submit();
			});
		});
	</script>

<%@include file="../includes/footer.jsp" %>