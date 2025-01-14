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
                            Board Register
                        </div>
                        <div class="panel-body">
                             <form role="form" action="/board/modify" method="post">
                              <input type="hidden" name="pageNum" value='<c:out value="${cri.pageNum}"/>'>
                              <input type="hidden" name="amount" value='<c:out value="${cri.amount}"/>'>
                              <input type="hidden" name="type" value="${cri.type}">
	               				<input type="hidden" name="keyword" value="${cri.keyword}">
	               				<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
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
                                  <sec:authentication property="principal" var="pinfo"/>
                       				 <sec:authorize access="isAuthenticated()">
                       					<c:if test="${ pinfo.username eq board.writer}">
		                                   <button type="submit" data-oper="modify" class="btn btn-default">Modify</button>
		                                   <button type="submit" data-oper="remove" class="btn btn-danger">Remove</button>
                                 		</c:if>
                                 </sec:authorize>
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
            
            <div class="row">
			  <div class="col-lg-12">
			    <div class="panel panel-default">
			
			      <div class="panel-heading">Files</div>
			      <!-- /.panel-heading -->
			      <div class="panel-body">
			        <div class="form-group uploadDiv">
			            <input type="file" name='uploadFile' multiple="multiple">
			        </div>
			        
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
					var typeTag=$("input[name='type']").clone();
					var keywordTag=$("input[name='keyword']").clone();
					
					formObj.empty();
					
					formObj.append(pageNumTag);
					formObj.append(amountTag);
					formObj.append(keywordTag);
					formObj.append(typeTag);
				} else if(operation === 'modify') {
			        
			        console.log("submit clicked");
			        
			        var str = "";
			        
			        $(".uploadResult ul li").each(function(i, obj){
			          
			          var attachObj = $(obj);
			          
			          console.dir(attachObj);
			          
			          str += "<input type='hidden' name='attachList["+i+"].fileName' value='"+attachObj.data("filename")+"'>";
			          str += "<input type='hidden' name='attachList["+i+"].uuid' value='"+attachObj.data("uuid")+"'>";
			          str += "<input type='hidden' name='attachList["+i+"].uploadPath' value='"+attachObj.data("path")+"'>";
			          str += "<input type='hidden' name='attachList["+i+"].fileType' value='"+ attachObj.data("type")+"'>";
			          
			        });
			        formObj.append(str).submit();
		        }
				//form 이벤트를 취소했기에 다시 submit을 해준다.
				formObj.submit();
			});
		});
	</script>
<script>

$(document).ready(function() {
  (function(){
    
    var bno = '<c:out value="${board.bno}"/>';
    
    $.getJSON("/board/getAttachList", {bno: bno}, function(arr){
    
      console.log(arr);
      
      var str = "";


      $(arr).each(function(i, attach){
          
          //image type
          if(attach.fileType){
            var fileCallPath =  encodeURIComponent( attach.uploadPath+ "/s_"+attach.uuid +"_"+attach.fileName);
            
            str += "<li data-path='"+attach.uploadPath+"' data-uuid='"+attach.uuid+"' "
            str +=" data-filename='"+attach.fileName+"' data-type='"+attach.fileType+"' ><div>";
            str += "<span> "+ attach.fileName+"</span>";
            str += "<button type='button' data-file=\'"+fileCallPath+"\' data-type='image' "
            str += "class='btn btn-warning btn-circle'><i class='fa fa-times'></i></button><br>";
            str += "<img src='/display?fileName="+fileCallPath+"'>";
            str += "</div>";
            str +"</li>";
          }else{
              
            str += "<li data-path='"+attach.uploadPath+"' data-uuid='"+attach.uuid+"' "
            str += "data-filename='"+attach.fileName+"' data-type='"+attach.fileType+"' ><div>";
            str += "<span> "+ attach.fileName+"</span><br/>";
            str += "<button type='button' data-file=\'"+fileCallPath+"\' data-type='file' "
            str += " class='btn btn-warning btn-circle'><i class='fa fa-times'></i></button><br>";
            str += "<img src='/resources/img/attach.png'></a>";
            str += "</div>";
            str +"</li>";
          }
       });

      
      $(".uploadResult ul").html(str);
      
    });//end getjson
  })();//end function
  
  
  $(".uploadResult").on("click", "button", function(e){
	    
    console.log("delete file");
    
    var targetFile = $(this).data("file");
    var type = $(this).data("type");
    var targetLi = $(this).closest("li");
      
    if(confirm("파일을 삭제하시겠습니까?")){
      
      $.ajax({
          url: '/deleteFile',
          data: {fileName: targetFile, type:type},
          beforeSend: function(xhr) {
         	  xhr.setRequestHeader(csrfHeaderName, csrfTokenValue);
           },
          dataType:'text',
          type: 'POST',
            success: function(result){
               targetLi.remove();
             }
        }); 
      
    }
  });  
  
  var regex = new RegExp("(.*?)\.(exe|sh|zip|alz)$");
  var maxSize = 5242880; //5MB
  
  function checkExtension(fileName, fileSize){
    
    if(fileSize >= maxSize){
      alert("파일 사이즈 초과");
      return false;
    }
    
    if(regex.test(fileName)){
      alert("해당 파일의 형식은 업로드할 수 없습니다.");
      return false;
    }
    return true;
  }
  
  var csrfHeaderName ="${_csrf.headerName}"; 
  var csrfTokenValue="${_csrf.token}";
  
  
  $("input[type='file']").change(function(e){

    var formData = new FormData();
    
    var inputFile = $("input[name='uploadFile']");
    
    var files = inputFile[0].files;
    
    for(var i = 0; i < files.length; i++){

      if(!checkExtension(files[i].name, files[i].size) ){
        return false;
      }
      formData.append("uploadFile", files[i]);
      
    }
    
    $.ajax({
      url: '/uploadAjaxAction',
      processData: false, 
      contentType: false,
      beforeSend: function(xhr) {
     	  xhr.setRequestHeader(csrfHeaderName, csrfTokenValue);
       },
      data:formData,
      type: 'POST',
      dataType:'json',
        success: function(result){
          console.log(result); 
		  showUploadResult(result); //업로드 결과 처리 함수 

      }
    }); //$.ajax
    
  });    

  function showUploadResult(uploadResultArr){
	    
    if(!uploadResultArr || uploadResultArr.length == 0){ return; }
    
    var uploadUL = $(".uploadResult ul");
    
    var str ="";
    
    $(uploadResultArr).each(function(i, obj){
		
		if(obj.fileType){
			var fileCallPath =  encodeURIComponent( obj.uploadPath+ "/s_"+obj.uuid +"_"+obj.fileName);
			str += "<li data-path='"+obj.uploadPath+"'";
			str +=" data-uuid='"+obj.uuid+"' data-filename='"+obj.fileName+"' data-type='"+obj.fileType+"'"
			str +" ><div>";
			str += "<span> "+ obj.fileName+"</span>";
			str += "<button type='button' data-file=\'"+fileCallPath+"\' "
			str += "data-type='image' class='btn btn-warning btn-circle'><i class='fa fa-times'></i></button><br>";
			str += "<img src='/display?fileName="+fileCallPath+"'>";
			str += "</div>";
			str +"</li>";
		}else{
			var fileCallPath =  encodeURIComponent( obj.uploadPath+"/"+ obj.uuid +"_"+obj.fileName);			      
		    var fileLink = fileCallPath.replace(new RegExp(/\\/g),"/");
		      
			str += "<li "
			str += "data-path='"+obj.uploadPath+"' data-uuid='"+obj.uuid+"' data-filename='"+obj.fileName+"' data-type='"+obj.fileType+"' ><div>";
			str += "<span> "+ obj.fileName+"</span>";
			str += "<button type='button' data-file=\'"+fileCallPath+"\' data-type='file' " 
			str += "class='btn btn-warning btn-circle'><i class='fa fa-times'></i></button><br>";
			str += "<img src='/resources/img/attach.png'></a>";
			str += "</div>";
			str +"</li>";
		}

    });
    
    uploadUL.append(str);
  }
  
});

</script>

<%@include file="../includes/footer.jsp" %>