<#include "../include/layout.ftl"/>
<@layout>
<@ucCourseDirective id=courseId>
<div class="g-userInner-bd">
	<div class="g-auto">
		<div class="g-course-begin">
			<div class="g-courseDt-cont g-inner-box g-couDl-inner">
				<div class="g-cDetail-tp">
					<span class="fig">
						<#import "/common/image.ftl" as image/>
						<@image.imageFtl url="${course.image! }" default="${app_path }/images/defaultCourseImg.png" />
					</span>
					<h2 class="title">${(course.title)!}</h2>
					<ul class="m-cDt-dl">
						<li class="i1">
							<span>${course.studyHours!0 }学时</span>
						</li>
						<li class="i2">
							<span>
								<#if course.type == 'lead'>
									引领式
									<#elseif course.type == 'mic'>
									微课
									<#else>
									自主式
								</#if>
							</span>
						</li>
						<li class="i3">
							<span>${DictionaryUtils.getEntryName('SUBJECT',course.subject!)} / ${DictionaryUtils.getEntryName('STAGE',course.stage!)}</span>
						</li>
						<li class="i4">
							<span>${(course.organization)!}</span>
						</li>
					</ul>
					<@courseRegisterStateDirective courseId=course.id relationId=relationId>
						<#if states??>
							<#if states[course.id] == 'pass'>
								<a href="${ctx}/study/course/${course.id}" class="btn u-main-btn selectBtn">进入学习</a>
							<#elseif states[course.id] == 'submit'>
								<a href="javascript:;" onclick="deleteCourseRegister('${registerIds[course.id]}')" class="btn u-main-btn selectBtn">取消选课</a>
							</#if>
						<#else>
							<#if train.electivesTime??>
								<#if !TimeUtils.hasBegun((train.electivesTime.startTime)!'')>
									<a  href="javascript:;" class="btn u-main-btn selectBtn disabled">选课尚未开始</a>
								<#elseif TimeUtils.hasEnded((train.electivesTime.endTime)!'')>
									<a  href="javascript:;" class="btn u-main-btn selectBtn disabled">选课已结束</a>
								<#else>
									<a onclick="createCourseRegister('${course.id}')" href="javascript:;" class="btn u-main-btn selectBtn">立即选课</a>
								</#if>
							<#else>
								<a onclick="createCourseRegister('${course.id}')" href="javascript:;" class="btn u-main-btn selectBtn">立即选课</a>	
							</#if>
						</#if>
					</@courseRegisterStateDirective>
					<!-- <div class="m-cDt-info">
						<div class="tp">
							课程已进行至<strong><span>0</span>/4周</strong>
						</div>
						<p class="tiem">
							开课时间：<span>2015年12月24日</span>
						</p>
						<p class="tiem">
							结束时间：<span>2016年1月24日</span>
						</p>
						<div class="grade">
							<div class="m-grade">
								<span class="star in"></span>
								<span class="star in"></span>
								<span class="star in"></span>
								<span class="star in"></span>
								<span class="star"></span>
							</div>
							<p>
								满意度评分
							</p>
						</div>
					</div> -->
				</div><!--end course detail top -->
				<div class="g-cDt-nav">
					<div class="m-cDt-nav">
						<a href="javascript:;" class="z-crt">课程简介</a>
						<a href="#courseContent">课程内容</a>
						<a href="#faqQuestions" class="last">常见问题(<em id="faqCount"></em>)</a>
					</div>
					<!--
					<div class="c-share">
						<div class="bdsharebuttonbox bdshare-button-style0-24" data-tag="share_1" data-bd-bind="1461220565832">
							<a class="bds_tsina" data-cmd="tsina" href="#" title="分享到新浪微博"></a>
							<a class="bds_qzone" data-cmd="qzone" href="#" title="分享到QQ空间"></a>
							<a class="bds_sqq" data-cmd="sqq" href="#" title="分享到QQ好友"></a>
							<a class="bds_weixin" data-cmd="weixin" href="#" title="分享到微信"></a>
						</div>
						<span>分享到：</span>
						<script type="text/javascript">
							window._bd_share_config = {
								share : [{
									"tag" : "share_1",
									"bdSize" : 24,
								}]
							}
							//以下为js加载部分
							with (document)
							0[(getElementsByTagName('head')[0] || body).appendChild(createElement('script')).src = 'http://bdimg.share.baidu.com/static/api/js/share.js?cdnversion=' + ~(-new Date() / 36e5)];
						</script>
					</div>-->
				</div><!--end course detail nav -->
				<div class="g-cDt-frame f-cb">
					<div class="g-cDt-mn">
						<div class="g-cDt-mnMod">
							<div class="m-intro-text">
								<P>${(course.summary)!}</P>
							</div>
						</div>
						<div class="g-cDt-mnMod">
							<div class="title-block">
								<h3 class="title"><a id="courseContent" name="courseContent">课程内容</a></h3>
							</div>
							<div class="dt">
								<#if course.type == 'lead' || course.type == 'self'>
									<ol class="g-cDt-directory">
										<#if course.contentObject??>
											<#list course.contentObject as section>
											<li class="t-item">
												<dl class="m-cDt-directory">
													<dt class="t-chapter">
														<div class="num">
															<span>模块${section_index+1}</span>
														</div>
														<span class="title">${section.title!}</span>
														<!--<a href="javascript:;" class="in-icos">进行中</a>-->
													</dt>
													<#list section.childSections as childSection>
														<dd class="t-section">
															<a href="javascript:;"><span>${childSection_index+1}.${childSection.title!}；</span></a>
															<!--<i class="finish" title="已完成"></i>-->
														</dd>
													</#list>
												</dl>
											</li>
											</#list>
										</#if>
									</ol>
								<#else>
									${content!}
								</#if>
							</div>
						</div>
						<div class="g-cDt-mnMod">
							<div class="title-block">
								<h3 class="title"><a id="faqQuestions" name="faqQuestions">常见问题</a></h3>
								<!--<a href="javascript:;" class="more">更多&gt;</a>-->
							</div>
							<form id="faqForm" action="${ctx}/userCenter/course/faqQuestions">
								<input type="hidden" name="relation.id" value="${course.id}">
								<input type="hidden" name="relation.type" value="course_config">
								<div class="dt">
									<ul id="faqQuestionList" class="g-cDt-qaLst">
										<script>
											$(function(){
												loadFaqQuestions();
											})
										</script>
									</ul>
									<div id="pageDiv">
										<input class="page" type="hidden" name="page" value="" />
										<input class="limit" type="hidden" name="limit" value="" />
										<input class="totalCount" type="hidden" name="totle" value="">
										<a onclick="loadMoreFaqQuestion(this)" href="javascript:;"class="m-course-Mo">加载更多 <i></i></a>
									</div>
								</div>
							</form>
						</div>
					</div><!--end course detail frame main -->
					<div class="g-cDt-sd">
						<div class="g-cDt-sdMod" id="teacherSlideBox">
							<div class="title-block">
								<h3 class="title">师资团队</h3>
								<a href="javascript:;" class="u-prev2"></a>
								<a href="javascript:;" class="u-next2"></a>
							</div>
							<div class="dt">
								<@courseTeachersDirective>
									<ul class="m-teacherSlide-lst">
										<#if teachersUserInfo??>
											<#list teachersUserInfo as userInfo>
												<li <#if userInfo_index==0>style="display: list-item;"<#else>style="display: none;"</#if>>
													<a href="javascript:;" class="fig">
														<@image.imageFtl url=userInfo.avatar! default="${app_path}/images/defaultAvatarImg.png" />
													</a>
													<div class="info">
														<strong class="name">${userInfo.realName!}</strong>
													</div>
													<div class="intro">
														<p style="min-width:200px">
															${userInfo.summary!}
														</p>
													</div>
												</li>
											</#list>
										</#if>
									</ul>
								</@courseTeachersDirective>
							</div>
						</div>
						<div class="g-cDt-sdMod">
							<div class="title-block">
								<h3 class="title">相关课程</h3>
								<a href="${ctx}/userCenter/course" class="more">更多&gt;</a>
							</div>
							<div class="dt">
								<ul class="m-rcmCourse-lst">
									<@coursesDirective limit="3" subject="${course.subject!}" state="published"  >
										<#list courses as c>
											<li>
												<a href="${ctx}/userCenter/course/${c.id}" class="fig">
													<@image.imageFtl url="" default="${app_path }/images/defaultCourseImg.png" />
												</a>
												<h4 class="title"><a href="detail.html">${c.title!}</a></h4>
												<p>
													<!--<em>188</em>人已参与-->
												</p>
											</li>
										</#list>
									</@coursesDirective>
								</ul>
							</div>
						</div>
					</div><!--end course detail frame side -->
				</div><!--end course detail frame -->
			</div>
			<!--end inner content box module -->
		</div>
	</div>
</div>
</@ucCourseDirective>
<script>
$(function(){
    //最近访客切换
    $("#teacherSlideBox").dsTab({
        itemEl        : '.m-teacherSlide-lst li',
        prev          : '.u-prev2',
        next          : '.u-next2',
        maxSize       : 5,
        overStop      : true,
        changeType    : 'fade',
        changeTime    : 3000
    });
}); 

	$(function() {
		changeTab('course');
	})
	function createCourseRegister(cid) {
		$.post('${ctx}/courseRegister', {
			"course.id" : cid,
			"user.id" : "${ThreadContext.getUser().getId()}",
			"state" : 'submit',
			"relation.id":"${relationId!}"
		}, function(response) {
			if (response.responseCode == '00') {
				alert('选课成功',function(){
					window.location.reload();
				});
			}else{
				if(response.responseMsg != ''){
					alert(response.responseMsg);
				}else{
					alert('操作失败');
				}
			}
		});
	}

	function updateCourseRegisterState(id, state, btn) {
		$.put('${ctx}/courseRegister', {
			'id' : id,
			'state' : state,
			'user.id' : "${ThreadContext.getUser().getId()}"
		}, function(response) {

		})
	}

	function deleteCourseRegister(id) {
		confirm('确定要取消这门选课?', function(){
			$.ajaxDelete('${ctx}/courseRegister/' + id, {
			}, function(response) {
				if (response.responseCode == '00') {
					alert('取消成功', function(){
						window.location.reload();
					});
				}
			});
		});
	}
	
	//重新加载
	function loadFaqQuestions() {
		$.ajaxQuery('faqForm', 'faqQuestionList');
	}
	
	function loadMoreFaqQuestion(a) {
		//判断是否已经到底
		var limit = $(a).closest('div').find('.limit');
		var totalCount = $(a).closest('div').find('.totalCount');
		var page = $(a).closest('div').find('.page');
		if(parseInt(limit.val()) * parseInt(page.val()) >= parseInt(totalCount.val())){
			alert('到底了');
			return;
		}
		page.val(parseInt(page.val()) + 1);
		var param = $('#faqForm').serialize();
		
		$.get('${ctx}/userCenter/course/faqQuestions?'+param,{},function(response){
			$('#faqQuestionList').append(response);
			setFollowStat();
		});		
	}

</script>
</@layout>