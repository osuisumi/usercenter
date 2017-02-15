<#include "/user-center/include/layout.ftl"/>
<@layout>
<div class="g-auto">
	<div class="m-teach-workshop">
		<@workshopsDirective masterNameOrTitle=(masterNameOrTitle[0])! state=state! userId=userId!'' wuState='passed' isTemplate=isTemplate!"N" page=(pageBounds.page)!1 orders=orders!'CREATE_TIME.DESC' limit=(pageBounds.limit)!10 withStat="Y" getMemberNum="Y" getStudentNum="Y" getActivityNum="Y" getResourceNum="Y" getTrainName='Y' getSolutionNum='Y'>
		<div class="m-teach-wsl">
			<div class="m-teach-wsTl">
				<h3 class="m-user-tl"><i></i>教师工作坊</h3>
				<#if app_path != '/user-center/lego'>
					<a href="${PropertiesLoader.get('wsts.domain') }workshop/create" class="m-bulid-wsbtn"><i class="u-bulid-ws"></i>创建个人工作坊</a>
				</#if>
				<label class="m-srh">
                    <input id="masterNameOrTitle" class="ipt" name="masterNameOrTitle" value="${(masterNameOrTitle[0])!}" placeholder="搜索" type="text">
                    <i class="u-srh1-ico"></i>
                </label>
			</div>
			<div class="m-teach-inwsTl">
				<@workshopNumDirective getNotTemplateNum='Y' getMyRelativeNum='Y'>
				<ul class="tl">
					<li <#if userId?? && userId != ''>class="crt"</#if> >
						<a onclick="reload('my')" href="javascript:;">与我相关的（${(myRelativeNum)!}）</a>
					</li>
					<li <#if !(userId??) || userId = ''>class="crt"</#if> >
						<a onclick="reload('all')" href="javascript:;">全部（${(notTemplateNum)!}）</a>
					</li>
				</ul>
				</@workshopNumDirective>
			</div>
			<#assign workshopIds = []>
			<#if workshops??>
				<#list workshops as workshop>
					<#assign workshopIds = workshopIds + [workshop.id]/>
				</#list>
			</#if>
			<#if (workshopIds?size>0)>
				<@workshopUsersMapDirective workshopIds=workshopIds!>
					<#assign workshopUserMap=workshopUserMap>
				</@workshopUsersMapDirective>
			</#if>

			<ul class="m-user-selectList">
					<#if workshops?? && (workshops?size>0)>
						<#list workshops as workshop>
						<#assign role='guest' />
							<#if (workshopUserMap[workshop.id])??>
								<#list workshopUserMap[workshop.id] as wu>
									<#if (wu.user.id) == Session.loginer.id>
										<#assign role=((wu.role)!'') />
										<#assign workshopUser = wu>
									</#if>
								</#list>
							</#if>
							<li>
								<#if role='guest'>
									<a href="javascript:alert('您不是坊内成员无权查看内容，请查看与我相关的工作坊');"  class="img">
								<#else>
									<a href="${PropertiesLoader.get('wsts.domain') }workshop/${workshop.id}" target="_blank" class="img">
								</#if>
									<#import "/common/image.ftl" as image/>
									<@image.imageFtl url="${(workshop.imageUrl)! }" default="${app_path }/images/defaultWorkshop.png" />
									<#if ((workshop.type)!'') = 'train'>
										<#if ((workshop.isTemplate)!'') = 'Y'>
											<span class="tip-ws example-ws">示范性工作坊</span>
											<#assign wtype='template'>
										<#else>
											<span class="tip-ws item-ws">项目工作坊</span>
											<#assign wtype='train'>
										</#if>
									<#else>
										<span class="tip-ws person-ws">个人工作坊</span>
										<#assign wtype='personal'>
									</#if>
								</a>
								<div class="m-user-selectList-txt">
									<div class="link-tl ">
										<#if (role!'') = 'master'>
											<ins class="unpass">坊主</ins>
										<#elseif (role!'') = 'student'>
											<ins class="verifying">学员</ins>
										<#elseif (role!'') = 'member'>
											<ins class="pass">助理</ins>
										</#if>
										<#if (wtype!'') != 'train'>
											<#if userId?? && userId != ''>
												<#if ((workshop.workshopRelation.solutionNum!0) <=0) >
													<ins class="verifying">待提交方案</ins>
												<#else>
													<#if ((workshop.state)!'editing') == 'editing'>
														<ins class="verifying">待审核</ins>
													<#elseif ((workshop.state)!'') == 'published'>
														<ins class="pass">已通过</ins>
													<#elseif ((workshop.state)!'') == 'reject'>
														<ins class="unverify">审核不通过</ins>
													</#if>
												</#if>
											</#if>
										</#if>
										<h4>
											<#if role='guest'>
												<a href="javascript:alert('您不是坊内成员无权查看内容，请查看与我相关的工作坊');">${(workshop.title)!}</a>
											<#else>
												<a href="${PropertiesLoader.get('wsts.domain') }workshop/${workshop.id}" target="_blank">${(workshop.title)!}</a>
											</#if>
										</h4>
									</div>
									
									<p>
										<span class="con1">
											<i class="u-user-sl-ico u-teach-wswho"></i>
											<strong>
												<a href="javascript:;">
													<#if (workshopUserMap[workshop.id])??>
														<#list workshopUserMap[workshop.id] as master>
															<#if (master.role) == 'master'>
																${(master.userInfo.realName)!}
															</#if>
														</#list>
													</#if>
												</a> 
											</strong>
											坊主
										</span>
									</p>
									
									<p>
										<#if wtype='train'>
											<span class="con1"><i class="u-user-sl-ico u-assistant-ws"></i><strong>${(workshop.workshopRelation.memberNum)!}</strong>名助理坊主</span>
											<span class="con2"><i class="u-user-sl-ico u-teach-wswhoadd"></i><strong>${(workshop.workshopRelation.studentNum)!}</strong>名学员</span>
										<#else>
											<span class="con2"><i class="u-user-sl-ico u-teach-wswhoadd"></i><strong>${(workshop.workshopRelation.memberNum)!}</strong>名成员参与</span>
										</#if>
									</p>
									<!--培训名-->
									<#if wtype="train">
										<p>
											<span class="con1"><i class="u-user-sl-ico "></i>${(workshop.trainName)!}</span>
										</p>
									<#else>
										<p>
		                                    <span class="con1"><i class="u-user-sl-ico u-teach-wsactv"></i><strong>活动数</strong>${(workshop.workshopRelation.activityNum)!}</span>
		                                    <span class="con2"><i class="u-user-sl-ico u-teach-wsreco"></i><strong>资源数</strong>${(workshop.workshopRelation.resourceNum)!}</span>
		                                </p>
		                                <p>
		                                    <span class="con1"><i class="u-user-sl-ico u-user-sl-ico03"></i><strong><ins>${TimeUtils.formatDate(workshop.createTime,'yyyy/MM/dd')}</ins></strong>创建</span>
		                                </p>
									</#if>
									<!--本人的成绩-->
									<#if (role!'') = 'student'>
										<p>
											<span class="con1">
												<i class="u-user-sl-ico u-teach-wsgetscore"></i>
												<strong>
													<ins class="get-score">${(workshopUser.workshopUserResult.point)!}</ins> 
													/<ins class="qualified-score">${(workshop.qualifiedPoint)!}</ins>
												</strong>达标积分 
												<#if (workshopUser.workshopUserResult.point)??>
													<#if (workshopUser.workshopUserResult.point>=((workshop.qualifiedPoint)!0)) >
														<#if (workshopUser.workshopUserResult.workshopResult)??>
															<#if workshopUser.workshopUserResult.workshopResult = 'excellent'>
																<em class="u-get-tip u-excellent-tip">优秀</em>
															<#elseif workshopUser.workshopUserResult.workshopResult = 'qualified'>
																<em class="u-get-tip">合格</em>
															<#elseif workshopUser.workshopUserResult.workshopResult = 'fail'>
																<em class="u-get-tip u-runing-tip">不合格</em>
															</#if>
														<#else>
															<em class="u-get-tip u-runing-tip">待评价</em>
														</#if>
													<#else>
														<em class="u-get-tip u-no-tip">未达标</em>
													</#if>
												<#else>
													<em class="u-get-tip u-no-tip">未达标</em>
												</#if>
											</span>
										</p>
									</#if>
									<!--开展进度-->
									<#if (workshop.timePeriod.startTime)?? && (workshop.timePeriod.endTime)??>
										<#assign workshopStartTime=workshop.timePeriod.startTime>
										<#assign workshopEndTime=workshop.timePeriod.endTime>
										<#if !TimeUtils.hasBegun(workshopStartTime)>
											<p class="end"><i class="u-user-sl-ico u-teach-wsend"></i>尚未开始</p>
										<#elseif TimeUtils.hasEnded(workshopEndTime)>
											<p class="end"><i class="u-user-sl-ico u-teach-wsend"></i>已结束</p>
										<#else>
											<div class="tc-wsprogress">
												<div class="m-tc-wsprogress">
													<span class="m-tc-progressbar width" style="width:${(TimeUtils.getBetweenDaysFromNow(workshopStartTime)+1)/(TimeUtils.getBetweenDays(workshopStartTime,workshopEndTime)+1)*100}%" ></span>
												</div>
												<span class="tl">已开展到第${(TimeUtils.getBetweenDaysFromNow(workshopStartTime)+1)}天，共${(TimeUtils.getBetweenDays(workshopStartTime,workshopEndTime))+1}天</span>
											</div>
										</#if>
									</#if>
								</div>
								<#if role='guest'>
									<a href="javascript:alert('您不是坊内成员无权查看内容，请查看与我相关的工作坊');" class="m-user-selectList-go">进入工作坊&gt;</a>
								<#else>
									<a href="${PropertiesLoader.get('wsts.domain') }workshop/${workshop.id}" class="m-user-selectList-go" target="_blank">进入工作坊&gt;</a>
								</#if>
							</li>
						</#list>
					<#else>
                    	<div class="g-no-notice-Con admin">
	                        <p class="txt">暂时没有数据！</p>
	                    </div>
					</#if>
				
			</ul>
			<form id="listWorkshopForm" action="${ctx}/userCenter/workshop">
				<!--<input type="hidden" name="isTemplate" value="${isTemplate!}">
				<input type="hidden" name="userId" value="${userId!}">
				<input type="hidden" name="state" value="${(state)!}">
				-->
				<input type="hidden" name="masterNameOrTitle" value="${(masterNameOrTitle[0])!}">
				<input type="hidden" name="pageType" value="${pageType!}">
				<div id="coursworkshopPage" class="m-laypage"></div>
				<#import "/common/pagination.ftl" as p/>
				<@p.paginationFtl formId="listWorkshopForm" divId="coursworkshopPage" paginator=paginator />
			</form>

		</div>
		</@workshopsDirective>
		<div class="m-teach-wsr">
			<dl class="m-teach-ws-ilist m-teach-ws-ilist-no" id="interestedWorkshopDiv">
				<script>
					$(function(){
						$('#interestedWorkshopDiv').load('${ctx}/userCenter/workshop/interested');
					});
				</script>
			</dl>
		</div>

	</div>

</div>

<script>
	$(function(){
		changeTab('workshop');
        $('#masterNameOrTitle').bind('keypress',function(event){
            if(event.keyCode == "13")    
            {
            	console.log($('#masterNameOrTitle').val());
                $('#listWorkshopForm input[name="masterNameOrTitle"]').val($('#masterNameOrTitle').val());
                $('#listWorkshopForm').submit();
            }
        });
	});
	
	function reload(type){
		if(type == 'all'){
			$('#listWorkshopForm input[name="pageType"]').val('all');
			/*$('#listWorkshopForm input[name="isTemplate"]').val('N');
			$('#listWorkshopForm input[name="userId"]').val('');
			$('#listWorkshopForm input[name="state"]').val('published');*/
		}else if(type == 'my'){
			$('#listWorkshopForm input[name="pageType"]').val('my');
			/*$('#listWorkshopForm input[name="isTemplate"]').val('');
			$('#listWorkshopForm input[name="userId"]').val('${Session.loginer.id}');
			$('#listWorkshopForm input[name="state"]').val('');*/
		}
		$('#listWorkshopForm').submit();
	}
	
</script>
</@layout>