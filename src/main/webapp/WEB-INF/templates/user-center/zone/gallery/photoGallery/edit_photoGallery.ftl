<#import "/user-center/common/inc.ftl" as inc />
<@inc.incFtl />
<title>创建相册</title>
<body>
	<form id="savePhotoGalleryForm" action="${ctx}/userCenter/zone/gallery/photoGallery" method="post">
		<#if id??>
			<@photoGalleryDirective id=id>
				<#assign photoGallery=photoGallery>
			</@photoGalleryDirective>
			<script>
				$(function(){
					$('#savePhotoGalleryForm').attr('action','${ctx}/userCenter/zone/gallery/photoGallery/${id}').attr('method','put');
				})
			</script>
		</#if>
		<div class="g-layer-wrap">
			<ul class="g-addElement-lst">
				<li class="m-addElement-item">
					<div class="ltxt">
						<em>*</em>相册名称：
					</div>
					<div class="center">
						<div class="m-pbMod-ipt">
							<input type="text" value="${(photoGallery.name)!}" name="name" placeholder="输入名称" class="u-pbIpt">
						</div>
					</div>
				</li>
				<li class="m-addElement-item">
					<div class="ltxt">
						<em>*</em>相册描述：
					</div>
					<div class="center">
						<div class="m-pbMod-ipt">
							<textarea id="description" class="u-textarea" name="description" placeholder="相册描述">${(photoGallery.description)!}</textarea>
						</div>
					</div>
				</li>
				<li class="m-addElement-item">
					<div class="ltxt">
						权限设置：
					</div>
					<div class="center">
						<div class="m-slt-row date">
							<div class="block w_auto">
								<div class="m-selectbox style1">
									<strong><span class="simulateSelect-text"> </span><i class="trg"></i></strong>
									<#assign privacy=(photoGallery.privacy)!'all'/>
									<select id="privacySelect" name="privacy">
										<option value="${privacy}" style="display:none"></option>
										<option value="all" <#if privacy=='all'>selected="selected"</#if> >所有人可见 </option>
										<option value="myFollowOnly" <#if privacy=='myFollowOnly'>selected="selected"</#if> >我关注的用户可见</option>
										<option value="myselfOnly" <#if privacy=='myselfOnly'>selected="selected"</#if> >仅自己可见</option>
									</select>
								</div>
							</div>
						</div>
					</div>
				</li>
				<li class="m-addElement-btn">
					<a href="javascript:void(0);" onclick="savePhotoGallery()" data-href="index1.html" class="btn u-main-btn" id="confirmAddChapter">提交</a>
					<a onclick="mylayerFn.closelayer($('#savePhotoGalleryForm'))" href="javascript:void(0);" class="btn u-inverse-btn u-cancelLayer-btn">取消</a>
				</li>
			</ul>
		</div>
	</form>
</body>

<script>
	function savePhotoGallery(){
		var response = $.ajaxSubmit('savePhotoGalleryForm');
		response = $.parseJSON(response);
		if(response.responseCode == '00'){
			mylayerFn.closelayer($('#savePhotoGalleryForm'),function(){
				alert('提交成功',function(){loadContent('gallery');});
			});
		}
	}
	
</script>
