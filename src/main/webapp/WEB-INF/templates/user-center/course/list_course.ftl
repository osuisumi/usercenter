<#include "../include/layout.ftl"/>
<@layout>
<@courseRelationTrainDirective timeParam='inElectivesTime' userId=Session.loginer.id stage=(courseRelation.course.stage)!'' subject=(courseRelation.course.subject)!''  page=(pageBounds.page)!1 limit=(pageBounds.limit)!16 orders='CREATE_TIME.DESC'>
<div class="g-auto">
	<div class="g-inner-box">
		<div class="g-inner-tp">
			<div class="m-innerMn-tt">
				<h3 class="tt">课程中心<!-- <span class="trg"><i></i></span> --></h3>
				<span class="ex">
					共有<em id="courseCount">
						${paginator.totalCount }
					</em>个课程信息
				</span>
			</div>
			<div class="g-select-box">
				<dl id="subjectSelectRow" class="m-select-row">
                    <dt>学&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;科:</dt>
                    <dd><a type="subject" value="" onclick="listCourse(this)">全部</a></dd>
                    <#list TextBookUtils.getEntryList('SUBJECT') as entry>
                    	<dd><a type="subject" value="${entry.textBookValue }" onclick="listCourse(this)">${entry.textBookName }</a></dd>
                    </#list>
                    <dd class="m-more">
                       <a href="javascript:;"><span class="down-more">展开+</span><span class="up-more">收起&nbsp;-</span></a> 
                    </dd>                                
                </dl>
				<dl id="stageSelectRow" class="m-select-row">
					<dt>
						学&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;段:
					</dt>
					<dd>
						<a type="stage" value="" onclick="listCourse(this)">全部</a>
					</dd>
					<#list TextBookUtils.getEntryList('STAGE') as entry>
						<dd>
							<a type="stage" value="${entry.textBookValue}" onclick="listCourse(this)">${entry.textBookName }</a>
						</dd>
					</#list>
                    <dd class="m-more">
                       <a href="javascript:;"><span class="down-more">展开+</span><span class="up-more">收起&nbsp;-</span></a> 
                    </dd>
				</dl>
			</div>
		</div>
		<div class="g-inner-dt">
				<ul class="m-course-lst small spc">
					<#list courseRelations as cr>
						<li>
							<div class="m-course-block">
								<a href="${ctx}/userCenter/course/${(cr.course.id)!}?relationId=${(cr.relation.id)!}" class="figure">
									<#import "../../common/image.ftl" as image/>
									<@image.imageFtl url="${(cr.course.image)! }" default="${app_path }/images/defaultCourseImg.png" />
								</a>
								<#if cr.course.studyHours??>
									<span class="period">${(cr.course.studyHours)!}学时</span>
								</#if>
								<p class="ex">
									${(cr.relationEntity.name)!}
								</p>
								<h3 class="tt"><a href="${ctx}/userCenter/course/${(cr.course.id)!}?relationId=${(cr.relation.id)!}">${(cr.course.title)!}</a></h3>
								<!--<div class="info">
									<div class="m-grade">
										<span class="star in"></span>
										<span class="star in"></span>
										<span class="star in"></span>
										<span class="star in"></span>
										<span class="star"></span>
									</div>
									<span class="name">${(cr.course.creator.realName)!}</span>
								</div>-->
							</div>
						</li>
					</#list>
				</ul>
				<form id="listCourseForm" action="${ctx}/userCenter/course">
					<input id="subject" type="hidden" name="course.subject" value="${(courseRelation.course.subject)!}">
					<input id="stage" type="hidden" name="course.stage" value="${(courseRelation.course.stage)!}">
					<input type="hidden" value="${pageBounds.limit!16}" name="limit">
					<div id="coursePage" class="m-laypage"></div>
					<#import "/common/pagination.ftl" as p/>
					<@p.paginationFtl formId="listCourseForm" divId="coursePage" paginator=paginator />
				</form>
			</div>
		</div>
	</div>
</@courseRelationTrainDirective>
<script>
	$(function() {
		changeTab('course');
		initSubject();
		initStage();
		initZ_CRTState();
		$('#courseCount').text($('.m-course-lst li').size());
		
	    more_discrible(".m-select-row:eq(0)",'.m-select-row');//展示更多
    	more_discrible(".m-select-row:eq(1)",'.m-select-row');//展示更多
	})
	function initSubject() {
		var subjects = $('#subjectsDiv option');
		$.each(subjects, function(i, n) {
			$('#subjectSelectRow').append('<dd><a value="' + $(n).attr("value") + '" type=subject onclick="listCourse(this)">' + $(n).text().trim() + '</a></dd>');
		});
	}

	function initStage() {
		var stages = $('#stagesDiv option');
		$.each(stages, function(i, n) {
			$('#stageSelectRow').append('<dd><a value="' + $(n).attr("value") + '" type="stage" onclick="listCourse(this)">' + $(n).text().trim() + '</a></dd>');
		});
	}

	function initZ_CRTState() {
		var subjectParam = "${(courseRelation.course.subject)!''}";
		var stageParam = "${(courseRelation.course.stage)!''}";
		if (subjectParam) {
			var selectedSubject = $('#subjectSelectRow a[value=' + subjectParam + ']');
			if (selectedSubject.size() > 0) {
				selectedSubject.addClass('z-crt');
			}
		} else {
			$('#subjectSelectRow a').eq(0).addClass('z-crt');
		}
		if (stageParam) {
			var selectedStage = $('#stageSelectRow a[value=' + stageParam + ']');
			if (selectedStage.size() > 0) {
				selectedStage.addClass('z-crt');
			}
		} else {
			$('#stageSelectRow a').eq(0).addClass('z-crt');
		}

	}

	function listCourse(a) {
		var type = $(a).attr('type');
		var value = $(a).attr('value');
		var form = $('#listCourseForm');
		$('#'+type).val(value);
		form.find('input[name="page"]').val('');
		form.submit();
	}
	
    function more_discrible(par,udown){
        var updown = true;
        var height_txt = $(par).height();
        if(height_txt<=44){
            $(par).find('.m-more').css({"display":"none"});
        }
        $(par).addClass('height-self');

        $(par).children('.m-more').on("click",function(){
            if(updown==true){
                $(this).parent(udown).addClass('Heightauto');
                $(this).find(".up-more").addClass('canfind').siblings('.down-more').addClass('notfind');
                updown=false;
            }else if(updown==false){
                $(this).parent(udown).removeClass('Heightauto');
                $(this).find(".up-more").removeClass('canfind').siblings('.down-more').removeClass('notfind');
                updown=true;
                
            }

        });      
    } 
</script>
</@layout>