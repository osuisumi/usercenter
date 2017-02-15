<#import "/user-center/common/inc.ftl" as inc />
<@inc.incFtl />
<title>选择相册</title>
<body>
	<div class="g-layer-wrap">
		<ul class="g-addElement-lst">
			<li class="m-addElement-item">
				<div class="ltxt">
					选择相册：
				</div>
				<form id="updatePhotoGalleryPhotoForm" method="put" action="${ctx}/userCenter/zone/gallery/photo/movePhotos">
					<div class="center">
						<input type="hidden" value="${photoIds}" name="photoIds">
						<input type="hidden" value="${galleryId}" name="from">
						<div class="m-slt-row date">
							<div class="block w_auto">
								<div class="m-selectbox style1">
									<strong><span class="simulateSelect-text"></span><i class="trg"></i></strong>
									<select name="to">
										<@photoGallerysDirective userId=ThreadContext.getUser().getId()>
											<#if photoGallerys??>
												<option value="${galleryId}" style="display:none"></option>
												<#list photoGallerys as pg>
													<option value="${pg.id}" <#if pg.id == galleryId>selected="selected"</#if> > ${(pg.name)!}</option>
												</#list>
											</#if>
										</@photoGallerysDirective>
									</select>
								</div>
							</div>
						</div>
					</div>
				</form>
			</li>
			<li class="m-addElement-btn">
				<a onclick="updateGalleryPhoto()" href="javascript:void(0);" data-href="index1.html" class="btn u-main-btn" id="confirmAddChapter">确定</a>
				<a onclick="mylayerFn.closelayer($('#updatePhotoGalleryPhotoForm'))" href="javascript:void(0);" class="btn u-inverse-btn u-cancelLayer-btn">取消</a>
			</li>
		</ul>
	</div>
</body>

<script>
	function updateGalleryPhoto(){
		var response = $.ajaxSubmit('updatePhotoGalleryPhotoForm');
		response = $.parseJSON(response);
		if(response.responseCode == '00'){
			alert('操作成功',function(){
				mylayerFn.closelayer($('#updatePhotoGalleryPhotoForm'),function(){
					loadContent('gallery');
				});
			});
		}
	}
	
</script>