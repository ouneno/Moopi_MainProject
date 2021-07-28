	<%@ page language="java" contentType="text/html; charset=UTF-8"
	    pageEncoding="UTF-8"%>
	<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
	
	<!DOCTYPE html>
	<html>
	<head>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1">
	
	<title>Insert title here</title>
	
		<jsp:include page="../../common/commonCDN.jsp"></jsp:include>
		
		<script src="/javascript/summernote-lite.js"></script>
		<script src="/javascript/lang/summernote-ko-KR.js"></script>
		<link rel="stylesheet" href="/css/summernote-lite.css">
	 	<link rel="preconnect" href="https://fonts.googleapis.com">
		<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
		<link
			href="https://fonts.googleapis.com/css2?family=Gaegu:wght@300&display=swap"
			rel="stylesheet">	
	
	  
	<style>
	html  { background-color: #ffffff; background-image:none;}	
	body {
	padding-top: 100px;
	margin: auto;
	font-family: 'Gaegu', cursive;
}
	.hrLine { position: relative; padding: 0px 0; }
	.hrLine hr{ border: 0; border-top:3px solid #3073ac; height:1px;width: 100%; margin-top: 10px;    margin-bottom: 10px; }			
	.replyHr hr{ border: 0; border-top:1px solid #3073ac; height:1px;width: 100%; margin-top: 10px;    margin-bottom: 10px; }
			
	
	.board_title	{
     	border-top: 2px solid #2f5285;
   		background-color: #e1eeff;
	    padding: 2px 8px;
	    align-items: center;
	}

	.board_title{
	
	}
			
	.reply_head{
		background-color: #e8e8e8;
	    border-radius: 4px;
		display: flex;
	    justify-content: space-between;
	    padding: 5px;	   
	}
					
	.board_content{
		min-height:200px;
		padding:10px;
	
	}
	.reply_content{
	
		padding:5px;
	}
						
	@media ( min-width : 768px) {
		.container {
			width: 750px;
		}
	}
	
	@media ( min-width : 992px) {
		.container {
			width: 1000px;
		}
	}
	
	/*사실 이 블럭은 없어도 된다*/
	@media ( min-width : 1200px) {
		.container {
			width: 1000px;
		}
	}					
	
	
	
	
	
	</style>
	</head>
	<body>
	<!-- ToolBar Start /////////////////////////////////////-->
		<jsp:include page="../../layout/toolbar.jsp" />
	<!-- ToolBar End /////////////////////////////////////-->
	<form class="form-horizontal" name="detailForm" enctype="multipart/form-data">
<!-- 	<div class="col-xs-12 col-sm-12 col-md-12"> -->
<!-- 			    <h3 class="head_title" data-edit="true" data-selector="h3.head_title" ><span class="fsize20" ><strong>QnA게시판조회</strong></span></h3> -->
<!-- 		   </div> -->
	<article>
		
	 	
	 	
		<div class="container hrLine"> 
		
	
		
		
			<div class="row">
				<div class="col-xs-8 col-sm-12 col-md-12">
					<h2 class="head_title" data-edit="true" data-selector="h3.head_title" style="margin:0px"><span class="fsize20" ><strong>QnA게시판조회</strong></span></h2><br><br>
				
				<section clsss="board">
				<div style="font-size:25px; margin:0px"> ${board.boardName}</div>	
				<div class="board_title">
				
				<div style="display:inline-block; float:right;">${board.boardRegDate}
				</div>
				
				<input class="board" type="hidden" id="boardNo" name="boardNo" value="${board.boardNo}">
				
				<div style="text-align:left;">
					<pattern id="comment-write-image" patternUnits="userSpaceOnUse" width="40" height="40">									
						<image xlink:href="//storage.googleapis.com/i.addblock.net/member/profile_default.jpg?_1627201858221" width="40" height="40"></image>								
					</pattern>${board.boardWriter.nickname} </div>
					</div>
					<div class="board_content" >
					${board.boardContent}
					</div>
					<div style="float:right;">
						<button type="button" class="btn btn-primary updateBoard" >수정</button>
						<button type="button" class="btn btn-primary deleteBoard" >삭제</button>
						<button type="button" class="btn btn-primary addReportBoard" >신고</button>
					</div>
					<br>
					<br>
				</section>
				
<!-- 				리플리스트 시작 -->
				<section class="reply-content">
					<div class="container replyHr">
						<c:forEach var="reply" items="${list}">
							<div id="${reply.replyNo }">
								<input type="hidden" class="reply" name="replyNo" value="${reply.replyNo}">
								<div class="reply_head">
								<div style="display: inline-block">
									${reply.replyWriter.nickname}
								</div>
								<div style="display: inline-block; float:right;">
								    작성시간 : ${reply.replyRegDate}
								</div>
								</div>
								<div class="reply_content" style="min-height:70px">
								${reply.replyContent}
								</div>
								<div style="float:right;">
									<button type="button" class="btn btn-primary updateReply">수정</button>
									<button type="button" class="btn btn-primary deleteReply">삭제</button>
									<button type="button" class="btn btn-primary addReportReply">신고</button>
								</div>
								<br><br>
							</div>	
							
						</c:forEach>
						<div class="reply">
						</div>
					</div>								
<!-- 				<div class="row"> -->
						
 <!-- 					리플리스트 끝.	 -->
 				</section>
 				
 				<section class="replyWrite">
					<form name="detailForm" enctype="multipart/form-data">
							<div id="addReplyForm">		
								<div style="padding-left:100px; width:800px">
									<textarea id="summernote" placeholder="댓글을 입력해주세요." name="replyContent" id="replyContent" ></textarea>						
								</div>					
									<input type="hidden" id = "replyWriter" value="${dbUser.userId}"> 
		  							<input type="hidden" id = "boardNo" value="${board.boardNo }"> 
								<div class="btn btn-submit btn-round" style=" float:right; border-color: rgba(0, 0, 0, 0.4); color: rgba(0, 0, 0, 0.8);" id="addReply"> 
									등록
								</div>
							</div>
					</form>	
				</section>
				</div>	
	</article>
	<p></p>
	
		 
	
	</form>	
	
	
	
	<jsp:include page="../../layout/searchbar.jsp"></jsp:include>
	</body>
	<script type="text/javascript">
	 $(document).ready(function() {
    	 $('#summernote').summernote({
				height: 150,                 // 에디터 높이
				minHeight: null,             // 최소 높이
				maxHeight: null,             // 최대 높이
				focus: true,                  // 에디터 로딩후 포커스를 맞출지 여부
				lang: "ko-KR",					// 한글 설정
				placeholder: ' ',	//placeholder 설정
				  toolbar: [
					    // [groupName, [list of button]]
					    ['fontname', ['fontname']],
					    ['fontsize', ['fontsize']],
					    ['style', ['bold',  'underline']],
					    ['color', ['forecolor']],
					    ['table', ['table']],
					    ['para', ['ul', 'ol', 'paragraph']],
					    ['insert',['picture']],
					  ],
					fontNames: ['Arial', 'Arial Black', 'Comic Sans MS', 'Courier New','맑은 고딕','궁서','굴림체','굴림','돋움체','바탕체'],
					fontSizes: ['8','9','10','11','12','14','16','18','20','22','24','28','30','36','50','72'],
				callbacks: {	//여기 부분이 이미지를 첨부하는 부분
					onImageUpload : function(files) {
						uploadSummernoteImageFile(files[0],this);
					},
					onPaste: function (e) {
						var clipboardData = e.originalEvent.clipboardData;
						if (clipboardData && clipboardData.items && clipboardData.items.length) {
							var item = clipboardData.items[0];
							if (item.kind === 'file' && item.type.indexOf('image/') !== -1) {
								e.preventDefault();
							}
						}
					}
				}
	});
			  });
     
     function uploadSummernoteImageFile(file, editor) {
         data = new FormData();
         data.append("file", file);
         $.ajax({
             data : data,
             type : "POST",
             url : "/board/uploadImage",
             contentType : false,
             processData : false,
             success : function(data) {
                 //항상 업로드된 파일의 url이 있어야 한다.
                 $(editor).summernote('insertImage', data.url);
             }
         });
     }
     
     $("div.note-editable").on('drop',function(e){
         for(i=0; i< e.originalEvent.dataTransfer.files.length; i++){
         	uploadSummernoteImageFile(e.originalEvent.dataTransfer.files[i],$("#summernote")[0]);
         }
        e.preventDefault();
   })
   
		$(function() {
			//==> DOM Object GET 3가지 방법 ==> 1. $(tagName) : 2.(#id) : 3.$(.className)
			$( ".updateBoard" ).on("click" , function() {
				fncUpdateView();
			});
		});	
		
		
		function fncUpdateView(){
			alert("게시글수정");
			alert(${board.boardNo});
			var boardNo = ${board.boardNo};
		// 	var boardCategory	=$("input[name='boardCategory']").val();
		// 	var boardWriter		=$("input[name='boardWriter']").val();
		// 	var boardName		=$("input[name='boardName']").val();
		// 	var boardContent	=$("input[name='boardContent']").val();
			
			$("form.form-horizontal").attr("method" , "GET").attr("action" , "/board/updateView").submit();
		}
		
		
		$(function() {
			//==> DOM Object GET 3가지 방법 ==> 1. $(tagName) : 2.(#id) : 3.$(.className)
			$( "#deleteBoard" ).on("click" , function() {
				fncDeleteBoard();
			});
		});	
		
		function fncDeleteBoard(){
			alert("게시글삭제");
			alert(${board.boardNo});
			var boardNo = ${board.boardNo};
			
			$("form.form-horizontal").attr("method" , "GET").attr("action" , "/board/deleteBoard").submit();
			
		}
		
		$(function() {
			//==> DOM Object GET 3가지 방법 ==> 1. $(tagName) : 2.(#id) : 3.$(.className)
			$( "#addReply" ).on("click" , function() {
				alert("addReply");
				alert($("#summernote").val()) 
				
				fncAddReply();
			});
		});	

		function fncAddReply(){
			
			
			var replyContent=$("#summernote").val()
			var replyWriter = $("#replyWriter").val();
			var boardNo = $("#boardNo").val();
			
			
			$.ajax({
				url: "/reply/json/addReply",
				type: "POST",
				dataType: "json",
				contentType : "application/json",
				data :  JSON.stringify ({ "boardNo": boardNo, "replyWriter": {"userId" :replyWriter}, "replyContent":replyContent}),		
				success: function(data, state){
// 					alert(state)
					var displayValue =
					
					 ' 	<div class='+data.replyNo+'>'		
					+'  <input type="hidden" class="reply" name="replyNo" value='+data.replyNo+'>'
					+'	<div class="reply_head">'
					+'	<div style="display: inline-block">'
					+	 data.replyWriter.nickname
					+'	</div>'
					+'	<div style="display: inline-block; float:right;">'
					+'    작성시간 : '+ data.replyRegDate
					+'	</div>'
					+'	</div>'
					+'	<div class="reply_content" style="min-height:70px">'
					+   data.replyContent
					+'	</div>'
					+'	<div style="float:right;">'
					+'	<button type="button" class="btn btn-primary updateReply">수정</button>'
					+'	<button type="button" class="btn btn-primary deleteReply">삭제</button>'
					+'	<button type="button" class="btn btn-primary ReportReply">신고</button>'
					+'	</div>'
					+'	</div>'
					+'	<br><br>'
					
						$(".reply").append(displayValue);
				}
		

		});
		
		}
		
		$(function() {
			//==> DOM Object GET 3가지 방법 ==> 1. $(tagName) : 2.(#id) : 3.$(.className)
			$( ".updateReply" ).on("click" , function() {
// 				alert("test")

				replyNo = $(this).parent().parent().find("input[name=replyNo]").val()
				fncGetReply(replyNo);
				
				
			});
		});	
		
		function fncGetReply(replyNo){
			alert("게시글수정");
			$.ajax({
				url: "/reply/json/getReply/"+replyNo,
				type: "GET",
				dataType: "json",
				contentType : "application/json",
				data :  JSON,
			    success : function(data , status) {
		               //alert(JSONData.memberRole);	
		                alert(status);
		                var displayValue = 
						'<div style="padding-left:100px; width:800px">'
					+	'	<textarea id="summernote" name="replyContent" id="replyContent" ></textarea>'						
					+	'</div>	'
					+	'	<input type="hidden" id = "replyWriter" value="'+data.replyWriter.userId+'">' 
  					+	'	<input type="hidden" id = "boardNo" value="'+data.boardNo+'"> '
					+	'<div class="btn btn-submit btn-round" style=" float:right; border-color: rgba(0, 0, 0, 0.4); color: rgba(0, 0, 0, 0.8);" id="updateReply">' 
					+	'수정'
					+	'</div>'
		    			
					
					
					
					
					
					
					
					
					
					
					
					
					
					
					
					
					
					
					
		    			
						$("#"+replyNo).remove();
// 						$("#addReplyForm").remove();
// 						$("#addReplyForm").append(displayValue);
// 						$(".note-editable").append(data.replyContent);
						
						
		                }
			
			            }
         
			)};
			
			
		$(function(){
			
			$("#updateReply]").on("click", function(){
				replyNo = $(this).parent().parent().find("input[name=replyNo]").val()
				replyContent = $(this).parent().parent().find("textarea[name=replyNo]").val()
				
				fncUpdateReply(replyNo, replyContent)
			})
		})
		
		
		
		function fncUpdateReply(replyNo, replyContent){
			alert("리플업데이트");
// 			replyNo = $(this).parent().parent().find("input[name=replyNo]").val()
			alert(replyNo)			
			
			$.ajax({
				url: "/reply/json/updateReply",
				type: "POST",
				dataType: "json",
				contentType : "application/json",
				data : JSON.stringify ({ "replyNo": replyNo , "replyContent":replyContent}),
			    success : function(data , status) {
			    	
		                alert(status);
			            console.log(data);
			            
		            	var displayValue = 
		            		 ' 	<div class='+data.replyNo+'>'		
		 					+'  <input type="hidden" class="reply" name="replyNo" value='+data.replyNo+'>'
		 					+'	<div class="reply_head">'
		 					+'	<div style="display: inline-block">'
		 					+	 data.replyWriter.nickname
		 					+'	</div>'
		 					+'	<div style="display: inline-block; float:right;">'
		 					+'    작성시간 : '+ data.replyRegDate
		 					+'	</div>'
		 					+'	</div>'
		 					+'	<div class="reply_content" style="min-height:70px">'
		 					+   data.replyContent
		 					+'	</div>'
		 					+'	<div style="float:right;">'
		 					+'	<button type="button" class="btn btn-primary updateReply">수정</button>'
		 					+'	<button type="button" class="btn btn-primary deleteReply">삭제</button>'
		 					+'	<button type="button" class="btn btn-primary ReportReply">신고</button>'
		 					+'	</div>'
		 					+'	</div>'
		 					+'	<br><br>'	
								
		 				var displayValue2 = 
		 						'<div style="padding-left:100px; width:800px">'
							+	'	<textarea id="summernote" name="replyContent" id="replyContent" ></textarea>'						
							+	'</div>	'
							+	'	<input type="hidden" id = "replyWriter" value="'+data.replyWriter.userId+'">' 
		  					+	'	<input type="hidden" id = "boardNo" value="'+data.boardNo+'"> '
							+	'<div class="btn btn-submit btn-round" style=" float:right; border-color: rgba(0, 0, 0, 0.4); color: rgba(0, 0, 0, 0.8);" id="addReply">' 
							+	'등록'
							+	'</div>'	
		 					
		    			$("#"+replyNo).append(displayValue);
		            	$("#addReplyForm").remove();
		            	$("#addReplyForm").append(displayValue2);
		                }
			
			});
				
		};
		
		$(function() {
			//==> DOM Object GET 3가지 방법 ==> 1. $(tagName) : 2.(#id) : 3.$(.className)
			$( ".deleteReply" ).on("click" , function() {
				alert("deleteReply")
				replyNo = $(this).parent().parent().find("input[name=replyNo]").val()
				fncDelteReply(replyNo);
			});
		});	
		
		function fncDelteReply(replyNo){
			alert('#replyNo'+replyNo)
			
			alert("리플삭제");
			$.ajax({
				url: "/reply/json/deleteReply/"+replyNo,
				type: "GET",
				dataType: "json",
				contentType : "application/json",
				data : JSON,
			    success : function(JSONData , status) {
			    	
		                alert(status);
		                
						$('#'+replyNo).remove();
		                }
		             
			});
				
		};
		
		$(function() {
			//==> DOM Object GET 3가지 방법 ==> 1. $(tagName) : 2.(#id) : 3.$(.className)
			$(  ".addReportBoard"  ).on("click" , function() {
				
				
				fncAddBoardReport();
				
			});
		});	
		
		
		function fncAddBoardReport(){
			alert("AddBoardReport 실행");
			
			
			var reportTarget = $("#boardNo").val();
			
			
			self.location ="/report/addReportView?reportCategory=1&reportTargetBd.boardNo="+reportTarget;
			
		}
			
		$(function() {
			//==> DOM Object GET 3가지 방법 ==> 1. $(tagName) : 2.(#id) : 3.$(.className)
			$(  ".addReportReply"  ).on("click" , function() {
				
				replyNo = $(this).parent().parent().find("input[name=replyNo]").val()
				fncAddReplyReport(replyNo);
				
			});
		});	
		
		
		function fncAddReplyReport(replyNo){
			alert("AddReplyReport 실행");
			
			self.location ="/report/addReportView?reportCategory=2&reportTargetRe.replyNo="+replyNo;
			
		}				
				
	</script>
	</html>
	
