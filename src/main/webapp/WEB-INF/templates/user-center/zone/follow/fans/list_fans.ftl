<#global app_path=PropertiesLoader.get('app.usercenter.path') >
<#import "../../../../common/image.ftl" as image/>
<dl class="m-dynamic">
	<@followUserDirective type="fans" userId=userId pageBounds=pageBounds fansName=fansName!''>
	<dt class="m-zone-mod m-all-dynamic">
		<h3 class="u-tit">我的粉丝<span>(<em class="fansNum"></em>人)</span></h3>
		<label class="m-srh">
				<input id="fansName" onkeypress="reloadFans(event)" name="fansName" value="${fansName!}" type="text" class="ipt" placeholder="搜索">
			<i class="u-srh1-ico"></i> 
		</label>
	</dt>
	<dd class="m-zone-mod m-person-dynamic">
		<!-- start g-fllow-lst -->
		<div class="g-fllow-lst">
			<ul class="m-fllow-lst">
				<#if userInfos?? && (userInfos?size>0)>
					<#list userInfos as userInfo>
						<li>
							<div class="m-block">
								<a class="m-info" href="javascript:void(0);">
									<@image.imageFtl url="${(userInfo.avatar)! }" default="${app_path}/images/defaultAvatarImg.png" userId=userInfo.id userName=userInfo.realName /> 
									<span class="txt"> <b>${(userInfo.realName)!}</b> <!--<span>心若彩虹的中学教师</span>--> </span>
								 </a>
								 <!--
								<div class="m-btm" userId="${(userInfo.id)!}">
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
			<form id="listFansForm" action="${ctx}/userCenter/zone/follow/fans">
				<input type="hidden" name="fansName" value="${fansName!}">
				<input type="hidden" name="userId" value="${userId}">
			<#if paginator??>
				<#import "../../../../common/pagination_ajax.ftl" as p/>
				<@p.paginationAjaxFtl formId="listFansForm" divId="fansPage" paginator=paginator contentId="zoneContent"/>
			</#if>
			</form>
			<div id="fansPage" class="m-laypage"></div>
		</div>
		<!-- end g-fllow-lst -->
	</dd>
	</@followUserDirective>
</dl>
<script>
	$(function(){
		changeZoneItem('fans');
		//setFollowStat();
		$('.fansNum').text($('#fansNum').text());
		$(".m-info img").showUserInfor();
	})
	
	//关注按钮点击事件
	function follow(a) {
		var warpDiv = $(a).closest("div");
		$.post('${ctx}/follows', {
			'followEntity.id' : $(warpDiv).attr('userId'),
			'followEntity.type' : 'user_center_user'
		}, function(response) {
			if (response.responseCode == '00') {
				alert('关注成功',function(){
					$(a).remove();
					addUnfollowBtn(warpDiv);
				});
			}
		});
	}
	
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
					alert('取消成功',function(){
						$(a).remove();
						addFollowBtn(warpDiv);
					});
				}
			});
		});
	}
	
	function addUnfollowBtn(warpDiv){
		warpDiv.append('<a onclick="cancleFollow(this)" href="javascript:void(0);"><i class="u-ico-fllow"></i>取消关注</a>');
	}
	
	function addFollowBtn(warpDiv){
		warpDiv.append('<a onclick="follow(this)" href="javascript:void(0);"><i class="u-ico-fllow"></i>关注</a>');
	}
	
	function setFollowStat(){
		var followList = $('.m-fllow-lst li');
		var ids = '';
		$(followList).each(function(i) {
			//如果已经加载过是否关注  则不处理
			var followDiv = $(this).find('.m-btm').eq(0);//关注部分的div
			if(followDiv.find('a').size()<1){
				var userId = $(followDiv).attr('userId');
				if (ids == '') {
					ids = userId;
				} else {
					ids = ids + ',' + userId;
				}
			}
		});
		if(ids == ''){
			return ;
		}
		$.get('${ctx}/follows/isFollow', {
			'userId' : '${(Session.loginer.id)!}',
			'relationIds' : ids,
			'type' : 'user_center_user'
		}, function(response) {
			$.each(response, function(key, value) {
				var followDiv = $('.m-btm[userId='+key+']');
				if (value == true) {
					addUnfollowBtn(followDiv);
				} else {
					addFollowBtn(followDiv);
				}
			})
		});
	}
	
	function reloadFans(event){
		if(event.keyCode == '13'){
			$('#zoneContent').load('${ctx}/userCenter/zone/follow/fans?userId=${userId}&fansName='+$('#fansName').val());
		}
	}
	
</script>
