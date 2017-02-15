<#global app_path=PropertiesLoader.get('app.usercenter.path') >
<#import "../../../../common/image.ftl" as image/>
<dl class="m-dynamic">
<@followUserDirective type="follow" userId=userId pageBounds=pageBounds followName=followName!''>
<dt class="m-zone-mod m-all-dynamic">
		<h3 class="u-tit">我的关注<span>(<em class="followNum"></em>人)</span></h3>
		<label class="m-srh">
				<input id="followName" onkeypress="reloadFollow(event)" name="followName" value="${followName!}" type="text" class="ipt" placeholder="搜索">
			<i class="u-srh1-ico"></i> 
		</label>
	</dt>
	<dd class="m-zone-mod m-person-dynamic">
		<!-- start g-fllow-lst -->
		<div class="g-fllow-lst">
			<ul class="m-fllow-lst">
				<#if userInfos?? && (userInfos?size >0)>
					<#list userInfos as userInfo>
						<li>
							<div class="m-block">
								<a class="m-info" href="javascript:void(0);"> 
									<@image.imageFtl url="${(userInfo.avatar)! }" default="${app_path}/images/defaultAvatarImg.png" userId=userInfo.id userName=userInfo.realName />
									<span class="txt"> <b>${(userInfo.realName)!}</b> <!--<span>心若彩虹的中学教师</span>--> </span> 
								</a>
								<!--
								<div class="m-btm" userId="${(userInfo.id)!}">
									<a onclick="cancleFollow(this)" href="javascript:void(0);"><i class="u-ico-hasfllow"></i>取消关注</a>
								</div>
								-->
							</div>
						</li>
					</#list>
				<#else>
					<div class="g-no-notice-Con">
			        	<p class="txt">暂时没有数据！</p>
			    	</div>
				</#if>
			</ul>
			<form id="listFollowsForm" action="${ctx}/userCenter/zone/follow/follow">
				<input type="hidden" name="followName" value="${followName!}">
				<input type="hidden" name="userId" value="${userId}">
				<#if paginator??>
					<#import "../../../../common/pagination_ajax.ftl" as p/>
					<@p.paginationAjaxFtl formId="listFollowsForm" divId="followPage" paginator=paginator contentId="zoneContent"/>
				</#if>
			</form>
			<div id="followPage" class="m-laypage"></div>
		</div>
	</dd>
	</@followUserDirective>
</dl>
	<script>
	$(function(){
		changeZoneItem('follow');
		$('.followNum').text($('#followNum').text());
		//
		$(".m-info img").showUserInfor();
	})
		
		
	function cancleFollow(a){
		confirm("确定取消关注吗？",function(){
			var warpDiv = $(a).closest("div");
			$.post("${ctx}/follows/deleteByUserAndFollowEntity",{
				"_method":"DELETE",
				"creator.id":"${ThreadContext.getUser().getId()}",
				"followEntity.id":$(warpDiv).attr('userId'),
				"followEntity.type":"user_center_user"
			},function(response){
				if(response.responseCode == '00'){
					$(a).closest('li').remove();
				}
			});
		});
	}
	
	function reloadFollow(event){
		if(event.keyCode =='13'){
			$('#zoneContent').load('${ctx}/userCenter/zone/follow/follows?userId=${userId}&followName='+$('#followName').val());
		}
	}
	</script>
