<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ include file="../includes/header.jsp" %>
<style>
.uploadResult {
	width: 100%;
	background-color: gray;
}

.uploadResult ul {
	display: flex;
	flex-flow: row;
	justify-content: center;
	align-items: center;
}

.uploadResult ul li {
	list-style: none;
	padding: 10px;
}

.uploadResult ul li img {
	width: 100px;
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
}

.bigPicture {
  position: relative;
  display:flex;
  justify-content: center;
  align-items: center;
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
                    <form role="form" action="/board/register" method="post">
                        <div class="form-group">
                            <label>Title</label>
                            <input class="form-control" name="title">
                        </div>
                        <div class="form-group">
                            <label>Text Area</label>
                            <textarea class="form-control" rows="3" name="content">
                            
                            </textarea>
                        </div>
                        <div class="form-group">
                            <label>Writer</label>
                            <input class="form-control" name="writer">
                        </div>
                        <button type="submit" class="btn btn-default">Submit</button>
                        <button type="reset" class="btn btn-default">Reset</button>
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
            
          <!-- 파일첨부 div -->
          <div class="row">
  <div class="col-lg-12">
    <div class="panel panel-default">

      <div class="panel-heading">File Attach</div>
      <!-- /.panel-heading -->
      <div class="panel-body">
        <div class="form-group uploadDiv">
            <input type="file" name='uploadFile' multiple>
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
<!-- 파일첨부 /row -->


<script>
$(document).ready(function(e){

	/* 
  var formObj = $("form[role='form']");
  
  $("button[type='submit']").on("click", function(e){
    
    e.preventDefault();
    
    console.log("submit clicked");
    
  }); */

  
  var formObj = $("form[role='form']");
  
  //글 submit 했을때 처리
  $("button[type='submit']").on("click", function(e){
    
    e.preventDefault();
    
    console.log("submit clicked");
    
    var str = "";
    
    //객체의 bno, fileName, type, uploadpath, uuid 등 attach 객체 정보를 전송
    $(".uploadResult ul li").each(function(i, obj){
      
      var attachObj = $(obj);
      
      console.dir(attachObj);
      console.log("-------------------------");
      console.log(attachObj.data("filename"));
      
      
      str += "<input type='hidden' name='attachList["+i+"].fileName' value='"+attachObj.data("filename")+"'>";
      str += "<input type='hidden' name='attachList["+i+"].uuid' value='"+attachObj.data("uuid")+"'>";
      str += "<input type='hidden' name='attachList["+i+"].uploadPath' value='"+attachObj.data("path")+"'>";
      str += "<input type='hidden' name='attachList["+i+"].fileType' value='"+ attachObj.data("type")+"'>";
      
    });
    
    console.log(str);
    
    formObj.append(str).submit();
    
  });

  
  var regex = new RegExp("(.*?)\.(exe|sh|zip|alz)$");
  var maxSize = 5242880; //5MB
  
  function checkExtension(fileName, fileSize){
    
    if(fileSize >= maxSize){
      alert("파일 사이즈 초과");
      return false;
    }
    
    if(regex.test(fileName)){
      alert("해당 종류의 파일은 업로드할 수 없습니다.");
      return false;
    }
    return true;
  }
  
  //파일 input 변경시 이미지 썸네일 보여주기
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
	//인자의 값이 넘어오지 않았을때 처리
    if(!uploadResultArr || uploadResultArr.length == 0){ return; }
    
    var uploadUL = $(".uploadResult ul");
    
    var str ="";
    
    $(uploadResultArr).each(function(i, obj){
    
		if(obj.fileType){
			var fileCallPath =  encodeURIComponent( obj.uploadPath + "/s_" + obj.uuid + "_" + obj.fileName);
			str += "<li data-path='" + obj.uploadPath + "'";
			str += "data-uuid='" + obj.uuid + "' data-filename='"+ obj.fileName + "' data-type='" + obj.fileType + "'"
			str += "><div>";
			str += "<span> "+ obj.fileName + "</span>";
			str += "<button type='button' data-file=\'"+ fileCallPath + "\' "
			str += "data-type='image' class='btn btn-warning btn-circle'><i class='fa fa-times'></i></button><br>";
			str += "<img src='/display?fileName=" + fileCallPath + "'>";
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

   $(".uploadResult").on("click", "button", function(e){
	    
     console.log("delete file");
     
     
     var targetFile = $(this).data("file");
     var type = $(this).data("type");
    
     var targetLi = $(this).closest("li");
     //ajax 통신시 삭제할 fileName과, type을 data로 전송
     $.ajax({
       url: '/deleteFile',
       data: {fileName: targetFile, type:type},
       dataType:'text',
       type: 'POST',
         success: function(result){
  	        alert(result);
           
            targetLi.remove();
          }
     }); //$.ajax
    });


  
});
</script>

<%@include file="../includes/footer.jsp" %>