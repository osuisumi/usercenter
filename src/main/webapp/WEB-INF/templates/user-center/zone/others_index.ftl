<!DOCTYPE html>
<#import "/user-center/common/inc.ftl" as inc />
<@inc.incFtl />
<#import "/common/image.ftl" as image/>
<body class="zone-bd">
	<div id="g-wrap">
		<input type="hidden" value="${userId}" id="userId">
		<@userInfoFromBaseUserViewDirective id=userId>
		<input type="hidden" value="${userInfo.realName}" id="realName">
			<div class="g-mzone-header">
				<div class="m-user-info">
					<a href="javascript:void(0);" class="u-img">
						<@image.imageFtl url="${(userInfo.avatar)!}" default="${app_path}/images/defaultAvatarImg.png" />
					</a>
					<p class="u-name">
						<span class="name">${userInfo.realName}</span>
						<i class="u-ico-sex woman"></i>
					</p>
					<p class="u-txt">
						${(userInfo.department.deptName)!}
					</p>
					<div id="followDiv" class="u-opa" userId="${userId}" loginId="${ThreadContext.getUser().getId()}">
		               
		            </div>
				</div>
			</div>
		</@userInfoFromBaseUserViewDirective>
		<div class="g-userInner-bd">
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
											<a href="javascript:void(0);"> <img src="images/headimg/headImg1.jpg" alt=""> <span>赵伊一</span> </a>
											<a href="javascript:void(0);"> <img src="images/headimg/headImg2.jpg" alt=""> <span>钱二二</span> </a>
											<a href="javascript:void(0);"> <img src="images/headimg/headImg3.jpg" alt=""> <span>孙珊珊</span> </a>
											<a href="javascript:void(0);"> <img src="images/headimg/headImg4.jpg" alt=""> <span>李诗诗</span> </a>
											<a href="javascript:void(0);"> <img src="images/headimg/headImg5.jpg" alt=""> <span>周午舞</span> </a>
											<a href="javascript:void(0);"> <img src="images/headimg/headImg6.jpg" alt=""> <span>吴溜溜</span> </a>
										</li>
										<li>
											<a href="javascript:void(0);"> <img src="images/headimg/headImg9.jpg" alt=""> <span>赵伊一</span> </a>
											<a href="javascript:void(0);"> <img src="images/headimg/headImg10.jpg" alt=""> <span>钱二二</span> </a>
											<a href="javascript:void(0);"> <img src="images/headimg/headImg11.jpg" alt=""> <span>孙珊珊</span> </a>
											<a href="javascript:void(0);"> <img src="images/headimg/headImg12.jpg" alt=""> <span>李诗诗</span> </a>
											<a href="javascript:void(0);"> <img src="images/headimg/headImg13.jpg" alt=""> <span>周午舞</span> </a>
											<a href="javascript:void(0);"> <img src="images/headimg/headImg14.jpg" alt=""> <span>吴溜溜</span> </a>
										</li>
									</ul>
									<script type="text/javascript">
										//最近访客切换
										$("#visitorChangeBox").dsTab({
											itemEl : '.m-sFig-lst li',
											prev : '.u-sPrev',
											next : '.u-sNext',
											maxSize : 5,
											overStop : true,
											changeType : 'fade',
											changeTime : 3000
										});
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
		</div>
	</div>
</body>
</html>
	<script>
		$(function(){
			loadContent('zoneDynamic');
			setFollowStat();
		})
		
		function setFollowStat(){
			var userId = "${userId}";
			var loginId = "${ThreadContext.getUser().getId()}";
			var followDiv = $('#followDiv');
        	if(userId != loginId){
				$.get('${ctx}/follows/isFollow', {
					'userId' : loginId,
					'relationIds' : userId,
					'type' : 'user_center_user'
				}, function(response) {
					var isFollow = response[userId];
					if (isFollow) {
						addUnFollowBtn(followDiv);
					} else {
						addFollowBtn(followDiv);
					}
	
				}); 
            }
		}
		
		function addFollowBtn(div){
			$(div).append('<a onclick="follow(this)" href="javascript:void(0);" class="uf">关注</a>');
		}
		
		function addUnFollowBtn(div){
			$(div).append('<a onclick="cancelFollow(this)" href="javascript:void(0);" class="uf">取消关注</a>');
		}
		
		function follow(a){
			var followDiv = $('#followDiv');
			var userId = followDiv.attr('userId');
			var loginId = followDiv.attr('loginId');
			$.post('${ctx}/follows', {
				'followEntity.id' : userId,
				'followEntity.type' : 'user_center_user'
			}, function(response) {
				if (response.responseCode == '00') {
					alert('关注成功',function(){
						$(a).remove();
						addUnFollowBtn(followDiv);
					});
				}
			});
		}
		
		function cancelFollow(a){
			var followDiv = $('#followDiv');
			var userId = followDiv.attr('userId');
			var loginId = followDiv.attr('loginId');
			confirm("确定取消关注吗？",function(){
				$.post("${ctx}/follows/deleteByUserAndFollowEntity",{
					"_method":"DELETE",
					"creator.id":loginId,
					"followEntity.id":userId,
					"followEntity.type":"user_center_user"
				},function(response){
					if(response.responseCode == '00'){
						alert('取消成功',function(){
							$(a).remove();
							addFollowBtn(followDiv);
						});
					}
				});
			});
		}

		
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
