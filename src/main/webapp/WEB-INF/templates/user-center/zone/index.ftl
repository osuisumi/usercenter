<#include "/user-center/include/layout.ftl"/>
<#import "/common/image.ftl" as image/>
<@layout>
	<input type="hidden" value="${userId}" id="userId">
	<@userInfoFromBaseUserViewDirective id=userId>
		<input type="hidden" value="${userInfo.realName}" id="realName">
	</@userInfoFromBaseUserViewDirective>
	<div class="g-auto1">
		<div class="g-zone-begin">
			<div class="g-zone-frame c-fb">
				<div class="g-zone-sd">
					<ul class="m-zone-mod m-zone-menu">
						<li class="item1 zoneDynamic">
							<a onclick="loadContent('zoneDynamic')" ><strong>个人动态</strong></a>
						</li>
						<li class="item2 schedule">
							<a onclick="loadContent('schedule')" ><strong>学习计划</strong></a>
						</li>
						<li class="item3 diary">
							<a onclick="loadContent('diary')" ><strong>学习日志</strong><span class="diaryNum">${(zoneCountInfo.diaryNum)!}</span></a>
						</li>
						<li class="item4 resource">
							<a onclick="loadContent('resource')" ><strong>我的资源</strong><span class="resoucesNum">${(zoneCountInfo.resourceNum)!}</span></a>
						</li>
						<li class="item5 gallery">
							<a onclick="loadContent('gallery')" ><strong>我的相册</strong><span>${(zoneCountInfo.galleryNum)!}</span></a>
						</li>
						<li class="item6 fans">
							<a onclick="loadContent('fans')" ><strong>我的粉丝</strong><span id="fansNum">${(zoneCountInfo.fansNum)!}</span></a>
						</li>
						<li class="item7 follow">
							<a onclick="loadContent('follow')" ><strong>我的关注</strong><span id="followNum">${(zoneCountInfo.followNum)!}</span></a>
						</li>
						<li class="item8 last dynamic">
							<a onclick="loadContent('dynamic')"><strong>我的足迹</strong></a>
						</li>
					</ul>
					<!--
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
					-->
				</div>
				<div id="zoneContent" class="g-zone-mn">
					
				</div>
			</div>
		</div>
	</div>
</@layout>
<script>
	$(function(){
		changeTab('zone');
		loadContent('zoneDynamic');
	})
	
	function loadContent(type){
		if(type == 'zoneDynamic'){
			$('#zoneContent').load('${ctx}/userCenter/zone/zoneDynamic?userId=${userId}');
		}else if(type == 'schedule'){
			$('#zoneContent').load('${ctx}/userCenter/zone/schedule?userId=${userId}');
		}else if(type == 'diary'){
			$('#zoneContent').load('${ctx}/userCenter/zone/diary?userId=${userId}');
		}else if(type == 'resource'){
			$('#zoneContent').load('${ctx}/userCenter/zone/resource?userId=${userId}');
		}else if(type == 'gallery'){
			$('#zoneContent').load('${ctx}/userCenter/zone/gallery/photoGallery?userId=${userId}');
		}else if(type == 'fans'){
			$('#zoneContent').load('${ctx}/userCenter/zone/follow/fans?userId=${userId}');
		}else if(type == 'follow'){
			$('#zoneContent').load('${ctx}/userCenter/zone/follow/follows?userId=${userId}');
		}else if(type == 'dynamic'){
			$('#zoneContent').load('${ctx}/userCenter/zone/dynamic?userId=${userId}');
		}
	}
	
	function changeZoneItem(liClass){
		$('.m-zone-menu li').removeClass('z-crt');
		$('.'+liClass).addClass('z-crt');
	}
</script>
