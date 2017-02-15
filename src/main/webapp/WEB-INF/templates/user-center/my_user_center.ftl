<#include "include/layout.ftl"/>
<@layout isHome=true>
<#assign showContent=true>
<#if app_path = '/user-center/lego'>
	<#if '2' = (Session.loginer.attributes.roleCode)!''>
		<@userRegionsDirective userId=(Session.loginer.id)!''>
			<#if ('Y' != (userRegions.isLogined)!'') || ('' = (userRegions.stage)!'')>
				<#assign showContent=false>
				<script>
					//乐高确认个人信息
				    mylayerFn.open({
				        type : 2,
				        title : '',
				        closeBtn : false,
				        area : [740, 680],
				        content : "/lego/user/edit_user",
				        shadeClose: false,
				        fix: true,
				        closeIcon: false,
				        shade: [0.9]
				    });
				</script>
			</#if>
		</@userRegionsDirective>
	</#if>
</#if>
<#if showContent>
<div class="g-auto">
	<div class="g-noselect-body">
		<div class="m-user">
			<@trainRegistersDirective userId=(Session.loginer.id)!'' state='pass'>
				<#if (trainRegisters?size>0)>
					<#list trainRegisters as trainRegister>
                		<#if trainRegister.train.id = (param_trainId!'') || '' = (param_trainId!'') && trainRegister_index = 0 >
                			<#assign train=trainRegister.train >
                		</#if>
                	</#list>
				</#if>
			</@trainRegistersDirective>
			<#assign relationIds=['system'] >
			<#assign relationIds = relationIds + [((train.id)!'')]>
			<@announcementsDirective relationIds=relationIds userId=Session.loginer.id limit=2 orders='CREATE_TIME.DESC'>
				<div class="m-user-notice" <#if !(announcements??) || (announcements?size <= 0)>style="display:none"</#if> >
	                <i class="u-notice"></i>
	                <ol>
	                	<#list announcements as announcement>
	                		<li title="${announcement.title! }">
	                			<a href="${ctx }/userCenter/announcement/${announcement.id}/view?announcementRelations[0].relation.id=system">&bull;<span>[${TimeUtils.formatDate(announcement.createTime, 'MM-dd')}]</span >
	                			${announcement.title! }</a>
	                			<#if !(announcement.announcementUser.id)??>
	                				<i class="u-new"></i>
	                			</#if>
	                		</li>
	                	</#list>
	                </ol>
	                <a href="${ctx }/userCenter/announcement" class="more">更多公告&gt;</a>
	            </div>
	        </@announcementsDirective>
        	<#if (trainRegisters?size>0)>
		        <div class="g-score-show">
	                <div class="m-place-select">
	                    <div class="place-slelect">
	                        <i class="ico"></i>
	                        <div class="m-selectbox style1">
	                            <strong>
	                            	<span class="simulateSelect-text">
		                            	${train.name}
	                            	</span>
	                            	<#if (trainRegisters?size>1)>
	                            		<i class="trg"></i>
	                            	</#if>
	                            </strong>
	                            <#if (trainRegisters?size>1)>
	                            	<select id="trainSelect">
		                            	<#list trainRegisters as trainRegister>
			                                <option onclick="changeTrain(this)" value="${trainRegister.train.id}" 
			                                	<#if trainRegister.train.id = (param_trainId!'') || ('' = (param_trainId!'') && trainRegister_index = 0) >selected="selected"</#if>>
			                                	${trainRegister.train.name}
			                                </option>
			                            </#list>
		                            </select>
	                            </#if>
	                        </div>
	                    </div>
	                    <!-- <span class="u-score"><b>24</b>获得学时</span> -->
	                </div>
	                <div class="m-con">
	                    <ul class="m-score-type">
	                    	<@trainResultDirective trainId=(train.id)!'' userId=Session.loginer.id>
	                    		<#assign trainResult=trainResult>
		                        <li class="study">
	                                <p class="tit">课程学习</p>
	                                <p class="info">
	                                	<#if 0 != (trainResult.courseStudyHours)!0>
	                                		<span class="hour">${(trainResult.courseStudyHours)!0}学时</span>
	                                	</#if>
	                                	<span>已选<b>${(trainResult.registerCourseNum)!0}</b>门课/合格<b>${(trainResult.passCourseNum)!0}</b>门</span>
	                                </p>
	                                <span class="u-ico">
	                                    <i class="bk1"></i>
	                                    <i class="bk2"></i>
	                                    <i class="bk3"></i>
	                                </span>
	                            </li>
	                            <#if ((train.type)!'')?contains('workshop')>
	                            	<span class="space"></span>
		                            <li class="workshop">
		                                <p class="tit">工作坊研修
		                                	<#if (((trainResult.wstsPoint)!0) != 0 && ((trainResult.wstsPoint)!0) <= ((trainResult.getWstsPoint)!0)) && (('qualified' = (trainResult.wstsState)!'') || ('excellent' = (trainResult.wstsState)!''))>	
			                                	<span class="u-state hg"><i></i>合格</span>
		                                	</#if>
		                                </p>
		                                <p class="info">
		                                	<#if 0 != (trainResult.wstsStudyHours)!0>
		                                		<span class="hour">${(trainResult.wstsStudyHours)!0}学时</span>
		                                	</#if>
		                                	<#if 0 != (trainResult.wstsPoint)!0>
		                                		<span>已获得<b>${(trainResult.getWstsPoint)!0}</b>/<b>${(trainResult.wstsPoint)!0}</b>积分</span></p>
		                                	</#if>
		                                <span class="u-ico">
		                                    <i class="wk1"></i>
		                                    <i class="wk2"></i>
		                                </span>
		                            </li>
	                            </#if>
	                            <#if ((train.type)!'')?contains('community')>
	                            	<span class="space"></span>
		                            <li class="community">
		                                <p class="tit">社区拓展
		                                	<#if (((trainResult.cmtsPoint)!0) != 0 && ((trainResult.cmtsPoint)!0) <= ((trainResult.getCmtsPoint)!0))>	
			                                	<span class="u-state hg"><i></i>合格</span>
		                                	</#if>
		                                </p>
		                                <p class="info">
		                                	<#if 0 != (trainResult.cmtsStudyHours)!0>
		                                		<span class="hour">${(trainResult.cmtsStudyHours)!0}学时</span>
		                                	</#if>
		                                	<#if 0 != (trainResult.cmtsPoint)!0>
		                                		<span>已获得<b>${(trainResult.getCmtsPoint)!0}</b>/<b>${(trainResult.cmtsPoint)!0}</b>积分</span></p>
		                                	</#if>
		                                <span class="u-ico">
		                                    <i class="cm1"></i>
		                                    <i class="cm2"></i>
		                                    <i class="cm3"></i>
		                                </span>
		                            </li>
	                            </#if>
	                        </@trainResultDirective>
	                    </ul>
	                    <span class="test-require">考核要求</span>
	                </div>
	            </div>
		        <#if ((train.type)!'')?contains('course')>
					<div class="m-user-ct my-course">
						<h3 class="m-user-tl course"><i></i>我的课程</h3>
						<#if (Session.loginer.id) ??>
							<@courseRegistersDirective relationId=(train.id)!'' userId=Session.loginer.id>
								<#if (courseRegisters?size>0)>
									<ul class="m-user-selectList">
										<#list courseRegisters as cr>
											<#if cr.state =  'pass' || cr.state = 'submit'>
												<li>
													<a href="javascript:;"> 
														<#import "/common/image.ftl" as image/>
														<@image.imageFtl url="${(cr.course.image)!}" default="${app_path }/images/defaultCourseImg.png" />
													</a>
													<div class="m-user-selectList-txt">
														<div class="link-tl">
															<#if (cr.course.timePeriod.startTime)?? && (cr.course.timePeriod.endTime)??>
																<#if !(TimeUtils.hasBegun(cr.course.timePeriod.startTime))>
																	<#assign progress='notBegun' />
																	<ins class="unverify">未开放</ins>
																<#elseif (TimeUtils.hasEnded(cr.course.timePeriod.endTime))>
																	<#assign progress='ended' />
																	<ins class="unverify">已结束</ins>
																<#else>
																	<#assign progress='ongoing' />
																	<ins class="pass">进行中</ins>
																</#if>
															<#elseif (cr.course.timePeriod.startTime)??>
																<#if !(TimeUtils.hasBegun(cr.course.timePeriod.startTime))>
																	<#assign progress='notBegun' />
																	<ins class="unverify">未开放</ins>
																<#else>
																	<#assign progress='ongoing' />
																	<ins class="pass">进行中</ins>
																</#if>
															<#elseif (cr.course.timePeriod.endTime)??>
																<#if !(TimeUtils.hasEnded(cr.course.timePeriod.endTime))>
																	<#assign progress='ended' />
																	<ins class="unverify">已结束</ins>
																<#else>
																	<#assign progress='ongoing' />
																	<ins class="pass">进行中</ins>
																</#if>
															<#else>
																<#assign progress='ongoing' />
																<ins class="pass">进行中</ins>											
															</#if>
															<h4><a href="${ctx}/userCenter/course/${(cr.course.id)!}?relationId=${(cr.relation.id)!}">${(cr.course.title)!}</a></h4>
														</div>
														<p>
															<#if cr.course.studyHours??>
																<span class="con1"><i class="u-user-sl-ico"></i><strong>${(cr.course.studyHours)!}学时</strong></span>
															</#if>
						                                </p>
						                                <p>
						                                    <span class="con2"><i class="u-user-sl-ico u-user-coursch"></i>${(cr.course.organization)!}</span>
						                                </p>
														<p>
						                                    <span class="con1"><i class="u-user-sl-ico u-user-sl-ico03"></i>开始时间：<span>${(cr.course.timePeriod.startTime?string('yyyy/MM/dd'))! }</span></span>
						                                </p>
													</div>
													<#if cr.state == 'submit'>
														<a href="javascript:;" class="m-user-selectList-go disable">选课审核中</a>
													<#else>
														<#if progress="notBegun">
															<a href="javascript:;" class="m-user-selectList-go disable">课程尚未开放</a>
														<#elseif progress='ended'>
															<a onclick="studyCourse('${cr.course.id}')" class="m-user-selectList-go">查看课程&gt;</a>
														<#else>
															<a onclick="studyCourse('${cr.course.id}')" class="m-user-selectList-go">开始学习&gt;</a>
														</#if>
													</#if>
												</li>
											</#if>
										</#list>
									</ul>
								<#else>
									<div class="no-open">暂未选课！</div> 
								</#if>
							</@courseRegistersDirective>
						</#if>
					</div>
				</#if>
				<#if ((train.type)!'')?contains('workshop')>
					<@ucCacheAlbeWorkshopsDirective role='student' type='train' relationId=(train.id)!'' userId=Session.loginer.id wuState='passed' getTrainName='Y'>
						<#assign workshopIds = []>
						<#if 0 < workshops?size>
							<#list workshops as workshop>
								<#assign workshopIds = workshopIds + [workshop.id]/>
							</#list>
						</#if>
						<#if (workshopIds?size>0)>
							<@workshopUsersMapDirective workshopIds=workshopIds!>
								<#assign workshopUserMap=workshopUserMap>
							</@workshopUsersMapDirective>
						</#if>
						<div class="m-user-ct m-teach-wsl workshop">
		                    <div class="m-user-workshop">
		                        <h3 class="m-user-tl workshop"><i></i>工作坊研修
		                        	<#if (workshops?size>0)>
					            		<#list workshops as workshop>
					            			<#if 0 = workshop_index>
					            				<#assign workshop=workshop>
						                		<#if '' != ((workshop.timePeriod.endTime)?string('yyyy-MM-dd'))!'' >
						                    		<span class="end-time"><i></i>结束日期：${(workshop.timePeriod.endTime)?string('yyyy-MM-dd')}</span>
						                    	</#if>
						                   	</#if>
						               </#list>
		                			</#if>
		                        </h3>
		                    </div>
		                    <#if 0 < workshops?size>
		                    	<ul class="m-user-selectList">
		                    		<#list workshops as workshop>
										<#if (workshopUserMap[workshop.id])??>
											<#list workshopUserMap[workshop.id] as wu>
												<#if (wu.user.id) == Session.loginer.id>
													<#assign role=((wu.role)!'') />
													<#assign workshopUser = wu>
												</#if>
											</#list>
										</#if>
		                        		<li>
				                            <a href="${PropertiesLoader.get('wsts.domain') }workshop/${workshop.id}" target="_blank" class="img">
												<#import "/common/image.ftl" as image/>
												<@image.imageFtl url="${(workshop.imageUrl)! }" default="${app_path }/images/defaultWorkshop.png" />
											</a>
						                    <div class="m-user-selectList-txt">
						                    	<h4><a href="${PropertiesLoader.get('wsts.domain') }workshop/${workshop.id}" target="_blank">${workshop.title!}</a></h4>
						                    	<#if 0 != (trainResult.wstsStudyHours)!0>
			                                		<p>
							                            <span class="con1"><i class="u-user-sl-ico u-user-sl-ico02"></i><strong>${(trainResult.wstsStudyHours)!0}学时</strong></span>
							                        </p>
			                                	</#if>
						                        <p>
						                            <span class="con1"><i class="u-user-sl-ico"></i>${(workshop.trainName)!}</span>
						                        </p> 
												<p>
													<span class="con1"><i class="u-user-sl-ico u-ico-score"></i>获得${(workshopUser.workshopUserResult.point)!0}/${(workshop.qualifiedPoint)!0}积分</span>
												</p>
						                    </div>
						                    <a href="${PropertiesLoader.get('wsts.domain') }workshop/${workshop.id}" target="_blank" class="m-user-selectList-go">进入工作坊&gt;</a>
						            	</li>
				            		</#list>
				           		</ul>
							<#else>
								<div class="no-open">工作坊研修暂未开始！</div>        
							</#if>
		                </div>
					</@ucCacheAlbeWorkshopsDirective>
				</#if>
				<#if ((train.type)!'')?contains('community')>
					<@communityRelationDirective relationId=(train.id)!>
						<#assign communityRelation=communityRelationModel!>
					</@communityRelationDirective>
					<@communityResultsDirective relationId=(train.id)! userId=Session.loginer.id>
						<#if (communityResults?size > 0)>
							<#list communityResults as communityResult>
								<#if 0 == communityResult_index>
									<#assign communityResult=communityResult>
								</#if>
							</#list>
						</#if>
						<div class="m-user-ct m-teach-wsl">
			                <div class="m-user-workshop">
			                    <h3 class="m-user-tl com"><i></i>
			                    	社区拓展
			                    	<#if '' != ((communityRelation.timePeriod.endTime)?string('yyyy-MM-dd'))!'' >
			                    		<span class="end-time"><i></i>结束日期：${(communityRelation.timePeriod.endTime)?string('yyyy-MM-dd')}</span>
			                    	</#if>
			                    </h3>
			                </div>
			                <ul class="m-user-selectList community">
			                    <li>
			                        <a href="${PropertiesLoader.get('cmts.domain') }" target="_blank" class="img">
			                            <img src="${path}/images/defaultCmtsImg.png" alt="" />
			                        </a>
			                        <div class="m-user-selectList-txt">
		                                <#if 0 != (trainResult.cmtsStudyHours)!0>
		                            		<p>
					                            <span class="con1"><i class="u-user-sl-ico u-user-sl-ico02"></i><strong>${(trainResult.cmtsStudyHours)!0}学时</strong></span>
					                        </p>
		                            	</#if>
		                                <#if 0 != (communityRelation.score)!0>
		                            		<p><span class="con1"><i class="u-user-sl-ico u-ico-score"></i>
		                            			获得${(communityResult.score)!0}/${(communityRelation.score)!0}积分
		                            		</span></p>
		                            	</#if>
			                            <#if 'excellent' = (communityResult.state)!''>
			                            	<p><span class="con1"><i class="u-user-sl-ico u-ico-prize"></i>优秀勋章1枚</span></p>
			                            </#if>
			                            <#if (communityRelation.timePeriod)?? >
			                            	<p><span class="con1"><i class="u-user-sl-ico u-ico-dt"></i>考核时间：
			                            		${((communityRelation.timePeriod.startTime)?string('yyyy-MM-dd'))!''}
			                            		至
			                            		${((communityRelation.timePeriod.endTime)?string('yyyy-MM-dd'))!''}
			                            	</span></p> 
			                            </#if>
			                        </div>
			                        <a href="${PropertiesLoader.get('cmts.domain') }" target="_blank" class="m-user-selectList-go">进入社区&gt;</a>
			                    </li>
			                </ul>  
			            </div>
			    	</@communityResultsDirective>
			    </#if>
			<#else>	
		    	<div class="g-no-notice-Con g-no-sign">
                    <p class="txt">您还没有报名培训！</p>
                </div>
		    </#if>
		</div>
	</div>
</div>
<#else>
	<div style="min-height:300px"></div>
</#if>
<script>
	$(function(){
		$("#trainSelect").simulateSelectBox({
	    	byValue: $('#trainSelect option[selected="selected"]').val()
	    });
		changeTab('index');
	})

	function studyCourse(id){
		window.open('${ctx}/study/course/'+id);
	}
	
	function changeTrain(obj){
		var trainId = $(obj).val();
		window.location.href = '/userCenter?trainId='+trainId
	}
</script>
</@layout>