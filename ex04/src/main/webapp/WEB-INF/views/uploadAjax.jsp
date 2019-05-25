<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Upload Ajax</title>

</head>
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
	width: 60px;
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
<body>


	<div class = 'uploadDiv'>
		<input type="file" name="uploadFile" Multiple>
	</div>
	<button id="uploadBtn">upload</button>
	
	<div class="uploadResult">
		<ul>
			
		</ul>
	</div>
	<div class="bigPictureWrapper">
		<div class="bigPicture"></div>
	</div>
	
	<script src="https://code.jquery.com/jquery-3.3.1.min.js" integrity="sha256-FgpCb/KJQlLNfOu91ta32o/NMZxltwRo8QtmkMRdAu8=" crossorigin="anonymous"></script>
	<script>
	
	//img 클릭시 원본 view
	function showImage(fileCallPath) {
		//클릭시 img view
		$(".bigPictureWrapper").css("display","flex").show();
		$(".bigPicture").html("<img src='display?fileName="+encodeURI(fileCallPath)+"'>").animate({width:'100%', height:'100%'}, 800);
		
		//이미지 닫기
		$(".bigPictureWrapper").on("click", function(e){
			  $(".bigPicture").animate({width:'0%', height: '0%'}, 800);
			  setTimeout(function() { $('.bigPictureWrapper').hide(); }, 800);
			});
	}
	
	
	$(document).ready(function(){
		
		
		//파일 형식 제한
		var regex = new RegExp("(.*?)\.(exe|sh|zip|alz)$");
		var maxSize = 5242880;
		
		function checkRegex(fileName, fileSize) {
			if(fileSize >= maxSize) {
				alert('파일 사이즈 초과');
				return false;
			}
			
			if(regex.test(fileName)) {
				alert("해당 파일 형식은 업로드 불가");
				return false;
			}
			
			return true;
		}
		
		
		//파일 썸네일 및 리스트 노출
		var uploadResult = $('.uploadResult ul');
		
		function showUploadFileName(uploadResultArr) {
			var str="";
			
			//여기서 i는 인덱스 obj는 VO 객체를 뜻하여 필드명으로 접근한다.
			$(uploadResultArr).each(function(i, obj) {
				if(!obj.image) {
					var fileCallPath = encodeURIComponent(obj.uploadPath + "/" + obj.uuid + "_" + obj.fileName);
					str += "<li><a href='/download?fileName=" + fileCallPath + "'>" + "<img src='/resources/img/attach.png'>" + obj.fileName + "</a></li>";
					
				} else {
	
					var fileCallPath = encodeURIComponent(obj.uploadPath + "/s_" + obj.uuid + "_" + obj.fileName);
					
					var originPath = obj.uploadPath + "/" + obj.uuid + "_" + obj.fileName;
					
					originPath = originPath.replace(new RegExp(/\\/g),"/");
					str += "<li><a href=\"javascript:showImage(\'" + originPath + "\')\">" + "<img src='display?fileName=" + fileCallPath + "'></a>" + 
							"<span data-file=\'" + fileCallPath+"\' data-type='image'> x </span></li>";
					/* str += "<li><a href='/download?fileName=" + originPath + "'><img src='/display?fileName=" + fileCallPath + "'></a></li>";  */
				}
			});
			
			uploadResult.append(str);
		}
		
		
		//Ajax로 Controller 전달
		var cloneObj = $('.uploadDiv').clone();
		
		$("#uploadBtn").on('click', function(){
			
			//첨부파일 전송시 객체(가상 form태그)
			var formData = new FormData();
			var inputFile = $('input[name="uploadFile"]');
			var files = inputFile[0].files;
			
			console.log(files);
			
			for(var i = 0; i<files.length; i++) {
				
				if(!checkRegex(files[i].name, files[i].size)) {
					return false;					
				}
				
				formData.append("uploadFile", files[i]);
			}
			
			$.ajax({
				url: "/uploadAjaxAction",
				processData:false,
				contentType:false,
				data:formData,
				type:'POST',
				dataType:'json',
				success:function(result){
					console.log(result); 
					
					showUploadFileName(result);
					
					$('.uploadDiv').html(cloneObj.html());
				}
			});
			
		});
		
		//업로드 게시물 삭제
		$('.uploadResult').on('click','span',function() {
			var targetFile = $(this).data("file");
			var type = $(this).data("type");
			
			console.log(targetFile);
			
			$.ajax({
				url:"/deleteFile",
				data:{fileName:targetFile, type:type},
				dataType:'text',
				type:'POST',
				success: function(result) {
					alert(result);
				}
			})
		});
		
		//파일 업로드 결과
		function showUploadResult(uploadResultArr){
		    
			//화면의 result결과가 없을시 체크
		    if(!uploadResultArr || uploadResultArr.length == 0){ return; }
		    
		    var uploadUL = $(".uploadResult ul");
		    
		    var str ="";
		    
		    $(uploadResultArr).each(function(i, obj){
		    	
		    	if(obj.image){
					var fileCallPath =  encodeURIComponent( obj.uploadPath+ "/s_"+obj.uuid +"_"+obj.fileName);
					str += "<li data-path='"+obj.uploadPath+"'";
					str +=" data-uuid='"+obj.uuid+"' data-filename='"+obj.fileName+"' data-type='"+obj.image+"'"
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
					str += "data-path='"+obj.uploadPath+"' data-uuid='"+obj.uuid+"' data-filename='"+obj.fileName+"' data-type='"+obj.image+"' ><div>";
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
</body>
</html>