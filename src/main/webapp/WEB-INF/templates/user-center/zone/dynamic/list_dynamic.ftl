<div class="g-my-foot">
	<h2 class="u-tit"><span id="uname"></span>的足迹</h2>
	<@dynamicsDirective userId=userId pageBounds=pageBounds>
	<#if dynamics?? &&(dynamics?size >0)>
	<ul class="m-ft-lst">
		<#list dynamics as dynamic>
			<li>
				<span class="m-date"><b>${TimeUtils.formatDate(dynamic.createTime,'HH:mm')}</b><em>${TimeUtils.formatDate(dynamic.createTime,'yyyy/MM/dd')}</em><span class="u-tips"><!--（最近）--></span></span>
				<#if dynamic.dynamicSourceType == "schedule">
					<a href="javascript:void(0);" class="block">添加了${dynamic.dynamicSourceEntity?size}条计划</a>
				<#elseif dynamic.dynamicSourceType == "galleryPhoto">
					<a href="javascript:void(0);" class="block">上传了${dynamic.dynamicSourceEntity?size}张照片到相册：
							<@photoGalleryDirective id=dynamic.dynamicSourceRelation.id>
								${(photoGallery.name)!}
							</@photoGalleryDirective>
					</a>
				<#elseif dynamic.dynamicSourceType == 'diary'>
					<a href="javascript:void(0);" class="block">发表日志:${(dynamic.dynamicSourceEntity.title)!}</a>
				<#elseif dynamic.dynamicSourceType == 'resource'>
					<a href="javascript:void(0);" class="block">分享资源：<a>${(dynamic.dynamicSourceEntity.title)!}</a>
				<#else>
				</#if>
				<i class="u-circle"></i>
			</li>
		</#list>
	</ul>
	<form id="listDynamicForm" action="${ctx}/userCenter/zone/dynamic">
		<input type="hidden" value="${limit!}" name="limit">
		<input type="hidden" name="userId" value="${userId}">
		<#if paginator??>
			<#import "../../../common/pagination_ajax.ftl" as p/>
			<@p.paginationAjaxFtl formId="listDynamicForm" divId="dynamicPage" paginator=paginator contentId="zoneContent"/>
		</#if>
	</form>
	<div id="dynamicPage" class="m-laypage"></div>
	<#else>
    	<div class="g-no-notice-Con admin">
	        <p class="txt">暂时没有数据！</p>
	    </div>
	</#if>
	</@dynamicsDirective>
</div>

<script>
	$(function(){
		changeZoneItem('dynamic');
		$('#uname').text($('#realName').val());
	})
</script>