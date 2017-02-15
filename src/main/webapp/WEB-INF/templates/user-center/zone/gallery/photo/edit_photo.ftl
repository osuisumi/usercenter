<#import "/user-center/common/inc.ftl" as inc />
<@inc.incFtl />
<title>编辑相片</title>
<body>
	<form id="editPhotoForm" action="${ctx}/userCenter/zone/gallery/photo/update" method="put">
		<@photoGalleryPhotoDirective id=id>
		<input type="hidden" name="id" value="${id}">
		    <div class="g-layer-wrap">
		        <ul class="g-addElement-lst">
		            <li class="m-addElement-item">
		                <div class="ltxt">
		                    <em>*</em>相片名称：
		                </div>
		                <div class="center">
		                    <div class="m-pbMod-ipt">
		                        <input name="name" type="text" value="<#if photo.name??>${photo.name}<#else>${(photo.fileInfo.fileName)!}</#if>" placeholder="输入相片名称..." class="u-pbIpt">
		                    </div>
		                </div>
		            </li>
		            <li class="m-addElement-item">
		                <div class="ltxt">
		                    <em>*</em>相片描述：
		                </div>
		                <div class="center">
		                    <div class="m-pbMod-ipt">
		                        <textarea name="description" class="u-textarea" placeholder="输入相册描述...">${(photo.description)!}</textarea>
		                    </div>
		                </div>
		            </li>
		            <li class="m-addElement-btn">
		                <a onclick="updatePhoto()" href="javascript:void(0);" data-href="index1.html" class="btn u-main-btn" id="confirmAddChapter">确定</a>
		                <a onclick="mylayerFn.closelayer($('#editPhotoForm'))" href="javascript:void(0);" class="btn u-inverse-btn u-cancelLayer-btn">取消</a>
		            </li>
		        </ul><!--end add element list -->
		    </div>
	    </@photoGalleryPhotoDirective>
    </form>
</body>
<script>
	function updatePhoto(){
		var response = $.ajaxSubmit('editPhotoForm');
		response = $.parseJSON(response);
		if(response.responseCode == '00'){
			alert('操作成功',function(){
				mylayerFn.closelayer($('#editPhotoForm'),function(){
					$('#zoneContent').load("${ctx}/userCenter/zone/gallery/photo/list/"+$('#galleryId').val(),"userId="+$('#userId').val());
				});
			});
		}
	}
</script>
