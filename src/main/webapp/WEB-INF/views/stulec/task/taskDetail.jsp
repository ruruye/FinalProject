<%@page import="org.apache.pdfbox.pdmodel.interactive.viewerpreferences.PDViewerPreferences.PRINT_SCALING"%>
<%@page import="com.ddit.proj.vo.TaskVO"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Date"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<style>
.custom-file-label::after {
    content: "파일 선택";
}
</style>


<% 
    Date today = new Date();
    SimpleDateFormat simpleDate = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
    String simDate = simpleDate.format(today);
    System.out.println("simDate"+simDate);
%>

<c:set var="Today" value="<%= simDate %>" />		
<fmt:parseDate value="${taskVO.taskDead}" pattern="yyyy-MM-dd" var="parsedDate" />
<fmt:parseDate value="${Today}" pattern="yyyy-MM-dd" var="Today" />
<c:set var="dateComparison" value="${parsedDate.compareTo(Today)}" />

<div class="col-12">
	<div class="card cardBasic" style="position: relative;">
		<div class="card-body">
			<h5>강의관리 > 과제 > 상세</h5>
			<div style="min-height: 530px;">
				<div>
					<div class="col-lg-12 mt-3 mt-lg-0 boardWrapper">
						<div class="mb-5 pt-3 pl-3 pr-3 pb-1 bg-my">
							<h4 class="text-white">${lecaNm}</h4>
						</div>
						<input type="hidden" name="taskDead" id="taskDead"
							value="${taskVO.taskDead}" /> <input type="hidden" name="taskCd"
							id="taskCd" value="${taskVO.taskCode}" /> <input type="hidden"
							name="lecCd" id="lecCd" value="${taskVO.lecCode}" /> <input
							type="hidden" id="fileId" value="${taskVO.fileId}" />

						<div class="mb-3 boardTitleWrap boardT">
							<h5 class="boardTitleH">${taskVO.taskNm}</h5>
						</div>
						<div class="mb-3 boardTitleWrap boardTInput"
							style="display: none; padding-top: 11px;">
							<input type="text" name="taskNm" value="${taskVO.taskNm}"
								id="taskNm" class="form-control boardTitle" maxlength="50"
								required data-toggle="maxlength" data-placement="top" />
						</div>

						<div class="boardDetail">
							<span>
								등록일&emsp;${taskVO.taskDe}&emsp;
							</span>
							<span>
								<strong>&emsp;마감일&emsp;${taskVO.taskDead}</strong>
							</span>
						</div>

						<hr class="hrwid">

						<div class="underMargin">
							<div class="notModifyMode" style="min-height: 150px;">
								<p>${taskVO.taskCon}</p>
							</div>
							<div>
								<div>
									<div id="divFileId"></div>
								</div>
							</div>
						</div>
					</div>
				</div>
				<hr>
				<!-- 학생 제출란 -->
				<form id="taskForm" method="post" action="/stu/taskSubmit" enctype="multipart/form-data">
					<input id="csrf" type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" /> 
					<input type="hidden" name="taskCode" value="${taskVO.taskCode }" /> 
					<input type="hidden" name="lecCode"	value="${taskVO.lecCode }" />
					<div>
						<div class="alert alert-light bg-light" role="alert" style="font-size: 0.9em;">
							과제 제출 시 <strong>마감일 이내에 수정이 가능</strong>합니다.<br> 
							<strong>마감일 이후</strong>에는 <strong>제출 또는 수정</strong>할 수 없으므로 기한을 잘 확인하여 불이익 없도록 주의하시길 바랍니다.
						</div>
						<table class="table mb-4" style="border-bottom: 1px solid #eef2f7;">
							<tr style="border-bottom: 1px solid #eef2f7;">
								<th style="width: 15%; background: #f8f8f8;">내용</th>
								<td style="width: 85%;">
									<textarea class="form-control" rows="15" name="tsubCon" id="tsubCon" minlength="1" required></textarea>
								</td>
							</tr>
							<tr>
								<th style="width: 15%; background: #f8f8f8;">첨부파일</th>
								<td style="width: 85%;">
									<div class="custom-file">
										<label class="custom-file-label" for="inputFile">${taskSubmitVO.fileOriNm}</label>
										<input type="file" class="custom-file-input" id="inputFile"	name="uploadFile">
									</div>
									<p style="color: #999; font-size: 0.8em; margin-top: 15px;">
										&#8251;&nbsp;동영상	파일은 MP4,AVI등이 아닌 압축파일&#40;ZIP&#41;을 첨부해 주세요.
									</p>
								</td>
							</tr>
							<tr>
								<th style="width: 15%; background: #f8f8f8;">과제 점수</th>
								<td>
									<input type="text" name="tsubScore" id="taskScore" class="form-control col-sm-1 d-inline" value="${taskSubmitVO.codeTsubScore}" disabled />
									&nbsp;/&nbsp;${taskVO.taskScore}
								</td>
							</tr>
						</table>
						<div class="notModifyMode modiBtn">
							<a href="/stu/taskList?lecCode=${taskVO.lecCode}" class="btn btn-light btn-sm goList">목록</a>
							<c:if test="${ dateComparison < 0 }">
								<button type="button" class="btn btn-my btn-sm noSubmit" style="float: right;">과제 제출</button>
							</c:if>
							<c:if test="${ dateComparison >= 0 }">
								<button type="submit" class="btn btn-my btn-sm" style="float: right;">과제 제출</button>
							</c:if>

						</div>
					</div>
				</form>
			</div>
		</div>
	</div>
</div>
<!-- 학생 제출란 끝-->


<script>
	const header = '${_csrf.headerName}';
	const token = '${_csrf.token}';

	let fileId = document.querySelector("#fileId").value;

	let data = {
		"fileId" : fileId
	};

	console.log("data", data);

	//fileId를 파라미터로 던지면 List<AttachVO>를 받아옴
	$
			.ajax({
				url : "/attach/getAttachVOList",
				contentType : "application/json;charset=utf-8",
				data : JSON.stringify(data),
				type : "post",
				dataType : "json",
				beforeSend : function(xhr) {
					xhr.setRequestHeader(header, token);
				},
				success : function(result) {
					console.log("result : " + JSON.stringify(result));

					let str = "";
					$
							.each(
									result,
									function(i, attachVO) {
										console.log("attachVO.filePath : "
												+ attachVO.filePath);

										str += "<button type='button' class='btn mb-2 btn-outline-danger' onclick=\"download('"
												+ attachVO.fileId
												+ "')\">"
												+ attachVO.fileOriNm
												+ "</button>";

									});
					$("#divFileId").html(str);
				}
			});

	$(".noSubmit").on("click", function() {
		Swal.fire({
			title : '과제 마감일이 지났습니다.',
			icon : 'warning'
		});
	});

	//다운로드
	function download(fileId) {
		data = {
			fileId : fileId
		}

		$.ajax({
			url : "/attach/getAttachVOList",
			contentType : "application/json;charset=utf-8",
			data : JSON.stringify(data),
			type : "post",
			dataType : "json",
			beforeSend : function(xhr) {
				xhr.setRequestHeader(header, token);
			},
			success : function(result) {
				console.log("result : " + JSON.stringify(result));
				console.log("filePath : " + result[0].filePath);
				console.log("fileOriNm : " + result[0].fileOriNm);

				let aTag = document.createElement("a");
				aTag.href = result[0].filePath;
				aTag.download = result[0].fileOriNm;

				aTag.click(); // 강제 클릭
			}
		});
	}

	var fileTarget = $('#inputFile');

	//파일 선택
	fileTarget.on('change', function() {
		if (window.FileReader) {
			var filename = $(this)[0].files[0].name;
		} else {
			var filename = $(this).val().split('/').pop().split('\\').pop();
		}

		$("label[for = 'inputFile' ]").text(filename);

	});
	
	//fileId를 파라미터로 던지면 List<AttachVO>를 받아옴
	$.ajax({
		url:"/attach/getAttachVOList",
		contentType:"application/json;charset=utf-8",
		data:JSON.stringify(data),
		type:"post",
		dataType:"json",
		beforeSend: function(xhr) {
	    	xhr.setRequestHeader(header, token);
		},
		success:function(result){
			console.log("result : " + JSON.stringify(result));
			
			let str = "";
			$.each(result,function(i,attachVO){
				console.log("attachVO.filePath : " + attachVO.filePath);
				let fe = "";
				if(attachVO.fileExtsn == "application/pdf"){
					fe = "fe-file";
				}else{
					fe = "fe-image";
				}
				
				str += `
				<div class="col-md-3">
					<div class="card shadow text-center mb-4 shadow-lg">
						<div class="card-body file">
							<div class="file-action">
								<button type="button" class="btn btn-link more-vertical p-0 text-muted mx-auto"	onclick="download('\${attachVO.fileId}')">
									<span class="fe fe-24 fe-download"></span>
								</button>
							</div>
							<div class="circle circle-lg bg-light my-4">
								<span class="fe \${fe} fe-24 text-danger"></span>
							</div>
							<div class="file-info">
								<span class="badge badge-light text-muted mr-2">\${attachVO.fileSize}</span>
								<span class="badge badge-pill badge-light text-muted">\${attachVO.fileExtsn}</span>
							</div>
						</div>
						<!-- .card-body -->
						<div class="card-footer bg-transparent border-0 fname">
							<strong>\${attachVO.fileOriNm}</strong>
						</div>
						<!-- .card-footer -->
					</div>
					<!-- .card -->
				</div>
				`;
				
				
				
			});
			$("#divFileId").html(str);
		}
	});
</script>