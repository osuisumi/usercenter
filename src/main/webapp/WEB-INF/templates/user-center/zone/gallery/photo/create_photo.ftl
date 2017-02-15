<#import "/user-center/common/inc.ftl" as inc />
<@inc.incFtl />
<title>相片上传</title>
<body>
	<div class="g-layer-wrap">
		<ul class="g-addElement-lst">
			<#if galleryId??>
				<input id="gallerySelect" type="hidden" value="${galleryId}">
			<#else>
				<li class="m-addElement-item">
					<div class="ltxt">
						选择相册：
					</div>
					<div class="center">
						<div class="m-slt-row date">
							<div class="block w_auto">
								<div class="m-selectbox style1">
									<strong><span class="simulateSelect-text"></span><i class="trg"></i></strong>
									<select id="gallerySelect" name="id">
										<@photoGallerysDirective userId=ThreadContext.getUser().getId()>
											<#if photoGallerys??>
												<option value="${photoGallerys[0].id}" style="display:none"></option>
												<#list photoGallerys as pg>
													<option value="${pg.id}" <#if pg_index == 0>selected="selected"</#if> >${(pg.name)!}</option>
												</#list>
											</#if>
										</@photoGallerysDirective>
									</select>
								</div>
							</div>
						</div>
					</div>
				</li>
			</#if>
			<#import "../../../common/upload_image_temp.ftl" as ui />
			<@ui.uploadImageTempFtl divId="imgDiv" relationId=(galleryId)! paramName="photos" paramType="" fileNumLimit=10 fileTypeLimit="jpg,jpeg,png" btnTxt='' uploadWhere='uploadTemp' />
			<form id="imgDiv" method="post">
				<li class="m-addElement-item">
					<div class="ltxt">
						选择相片：
					</div>
					<div class="center" id="imgDiv">
						<div class="m-slt-row date">
							<div class="file-ipt">
								<a href="javascript:void(0);" class="u-btn-add picker"><span>+</span>添加相片</a>
							</div>
						</div>
					</div>
				</li>
				<li class="m-addElement-item">
					<div class="ltxt">
						相片列表：
					</div>
					<div class="center">
						<div class="m-img-lst">
							<ul class="img-lst fileList">
								
							</ul>
						</div>
					</div>
				</li>
			</form>
			<li class="m-addElement-btn">
				<a onclick="addPhoto()" href="javascript:void(0);" data-href="index1.html" class="btn u-main-btn" id="confirmAddChapter">上传</a>
				<a href="javascript:void(0);" class="btn u-inverse-btn u-cancelLayer-btn">取消</a>
			</li>
		</ul><!--end add element list -->
	</div>
</body>

<script>
	function addPhoto(){
		initFileParam('imgDiv','photos');
		var id = $('#gallerySelect').val();
		$('#imgDiv').attr('action','${ctx}/userCenter/zone/gallery/photoGallery/'+id+'/addPhotos');
		var response = $.ajaxSubmit('imgDiv');
		response = $.parseJSON(response);
		if(response.responseCode=='00'){
			mylayerFn.closelayer($('#imgDiv'),function(){
				alert('创建成功',function(){
					var galleryId = "${galleryId!''}";
					if(galleryId){
						$('#zoneContent').load('${ctx}/userCenter/zone/gallery/photo/list/'+galleryId+'?userId=${ThreadContext.getUser().getId()}');
					}else{
						loadContent('gallery');
					}
				});
			});
		}
		
	}

    function initFileParam(divId, paramName) {
    	var $list = $('#'+divId).find(".fileList");
    	$list.find('.fileParam').remove();
    	$list.find('.fileLi.success').each(function(i) {
    		var fileId = $(this).attr('fileId');
    		var fileName = $(this).attr('fileName');
    		var url = $(this).attr('url');
			$(this).append('<input class="fileParam" name="'+paramName+'[' + i + '].fileInfo.id" value="' + fileId + '" type="hidden"/>');
			$(this).append('<input class="fileParam" name="'+paramName+'[' + i + '].fileInfo.fileName" value="' + fileName + '" type="hidden"/>');
			$(this).append('<input class="fileParam" name="'+paramName+'[' + i + '].fileInfo.url" value="' + url + '" type="hidden"/>');
    	});
    	initFileType($list);
    }
</script>
