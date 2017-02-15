<#import "/common/image.ftl" as image/>
<@photoGalleryPhotosDirective galleryId=galleryId!>
<div class="g-photoPreview-wrap" id="photoPreviewBd">
	<div class="g-photoPreview-shade"></div>
	<div class="g-photoPreview-layer">
		<a href="javascript:;" class="close"></a>
		<div class="photo-preview-content">
			<div class="photo-preview-bArea" onselectstart="return false">
				<a href="javascript:void(0);" class="prev" id="photoPreiewPrev"></a>
				<a href="javascript:void(0);" class="next" id="photoPreiewNext"></a>
				<ul class="m-preview-bList">
					<#if photos??>
						<#list photos as p>
							<li><img src="${FileUtils.getFileUrl((p.fileInfo.url)!)}" alt="">
							</li>
						</#list>
					</#if>
				</ul>
			</div>
			<div class="photo-preview-sArea">
				<a href="javascript:void(0);" class="prev" id="photoPreiewFocusPrev" ></a>
				<a href="javascript:void(0);" class="next"  id="photoPreiewFocusNext" ></a>
				<div class="ofh">
					<ul class="m-preview-sList" style="width: 2200px">
						<#if photos??>
							<#list photos as p>
								<li class="z-crt">
									<span class="border"></span><img src="${FileUtils.getFileUrl((p.fileInfo.url)!)}" photoId="${p.id}" alt="">
								</li>
							</#list>
						</#if>
					</ul>
				</div>
			</div>
		</div>
		<div id="detailPhotoDiv" class="photo-preview-common zoon-phList">
			
		</div>
	</div>
</div>
<script>
	$(function(){
		loadPhotoDetail();
	})
	
	function loadPhotoDetail(){
		var photoId = photoPreview.nowPhotoId;
		$('#detailPhotoDiv').load('${ctx}/userCenter/zone/gallery/photo/detail','id='+photoId+'&galleryId=${galleryId}');
	}

	
</script>

</@photoGalleryPhotosDirective>
