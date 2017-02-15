<#macro zlayout>
<#include "../include/layout.ftl"/>
<#import "../../common/image.ftl" as image/>
<@layout>
<div class="g-userInner-bd">
	<#assign userId=userId!>
	<input type="hidden" name="userId" value="${userId!}">
	<div class="g-auto1">
		<div class="g-zone-begin">
			<div class="g-zone-frame c-fb">
				<div class="g-zone-sd">
					<ul class="m-zone-mod m-zone-menu">
						<li class="item1">
							<a href="${ctx}/userCenter/zone/zoneDynamic?userId=${userId}"><strong>个人动态</strong></a>
						</li>
						<li class="item2">
							<a href="${ctx}/userCenter/zone/schedule?userId=${userId}"><strong>学习计划</strong></a>
						</li>
						<li class="item3">
							<a href="${ctx}/userCenter/zone/diary?userId=${userId}"><strong>学习日志</strong><span>10</span></a>
						</li>
						<li class="item4">
							<a href="${ctx}/userCenter/zone/resource?userId=${userId}"><strong>我的资源</strong><span>10</span></a>
						</li>
						<li class="item5">
							<a href="${ctx}/userCenter/zone/gallery/photoGallery?userId=${userId}"><strong>我的相册</strong><span>10</span></a>
						</li>
						<li class="item6">
							<a href="${ctx}/userCenter/zone/follow/fans?userId=${userId}"><strong>我的粉丝</strong><span>10</span></a>
						</li>
						<li class="item7">
							<a href="${ctx}/userCenter/zone/follow/follows?userId=${userId}"><strong>我的关注</strong><span>10</span></a>
						</li>
						<li class="item8 last">
							<a href="###"><strong>我的足迹</strong></a>
						</li>
					</ul><!--end zone menu -->
					<div class="m-zone-mod m-sd-fig" id="visitorChangeBox">
						<div class="t-tp">
							<h3 class="title">最近访客</h3>
							<a href="javascript:void(0);" class="u-sPrev"></a>
							<a href="javascript:void(0);" class="u-sNext"></a>
						</div>
						<div class="t-dt">
							<ul class="m-sFig-lst">
								<li>
									<a href="javascript:void(0);"> <@image.imageFtl url="${ThreadContext.getUser().avatar! }" default="${app_path}/images/defaultAvatarImg.png" /> <span>赵伊一</span> </a>
								</li>
							</ul>
							<script type="text/javascript">
								//最近访客切换
								/*$("#visitorChangeBox").dsTab({
									itemEl : '.m-sFig-lst li',
									prev : '.u-sPrev',
									next : '.u-sNext',
									maxSize : 5,
									overStop : true,
									changeType : 'fade',
									changeTime : 3000
								});*/
							</script>
							<a href="javascript:void(0);" class="more">查看更多</a>
						</div>
					</div>
		
				</div><!--end zone frame side -->
				<div id="zoneContext" class="g-zone-mn">
					<#nested>
				</div><!--end zone frame main -->
			</div><!--end zone frame -->
		</div>
	</div>
</div>
</@layout>
<script>
	$(function(){
		changeTab('zone');
	})
	
	function changeZoneItem(index){
		$('.m-zone-menu li').eq(index).addClass('z-crt');
	}
</script>
</#macro>