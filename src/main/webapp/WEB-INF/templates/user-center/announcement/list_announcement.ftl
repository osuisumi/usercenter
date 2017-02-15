<#include "../include/layout.ftl"/> 
<@layout>
<div class="g-auto">
	<div class="m-user m-notice-List">
		<p class="where">
			<span class="where-in">当前位置</span> 
			<a href="${ctx}/userCenter" class="u-h-home"></a> 
			<span>&gt;&nbsp;&nbsp;&nbsp;</span> <span>公告</span>
		</p>
		<@trainRegistersDirective userId=Session.loginer.id limit=999999999>
			<#assign relationIds=['system'] >
			<#if (trainRegisters)?? >
				<#list trainRegisters as trainRegister>
					<#if ((trainRegister.train.id)!'') != ''>
						<#assign relationIds = relationIds  + [trainRegister.train.id]>
					</#if>
				</#list>
			</#if>
		</@trainRegistersDirective>
		<#if (relationIds)?size gt 0 >
			<@announcementsDirective relationIds=relationIds userId=Session.loginer.id page=pageBounds.page limit=pageBounds.limit orders='CREATE_TIME.DESC'>
				<ul class="m-mouse-txt m-click-txt m-announ-txt">
					<#list announcements as announcement>
						<li>
							<div class="p-width m-announ-txtdl">
								<p>
									<span class="u-announ-dot">&bull;</span> 
									<span class="u-announ-tim">${TimeUtils.formatDate(announcement.createTime, 'yyyy/MM/dd')}</span> 
									<a href="${ctx }/userCenter/announcement/${announcement.id}/view?announcementRelations[0].relation.id=system">${announcement.title! }</a>
								</p>
								<#if !(announcement.announcementUser.id)??>
	                				<i class="u-new"></i>
	                			</#if>
							</div> 
						</li>
					</#list>
				</ul>
				<form id="listAnnouncementForm" action="${ctx}/userCenter/announcement">
					<div id="coursePage" class="m-laypage"></div>
					<#import "/common/pagination.ftl" as p/>
					<@p.paginationFtl formId="listAnnouncementForm" divId="coursePage" paginator=paginator />
				</form>
				<div id="myCoursePage" class="m-laypage3"></div>
			</@announcementsDirective>
		</#if>
	</div>
</div>
</@layout>
