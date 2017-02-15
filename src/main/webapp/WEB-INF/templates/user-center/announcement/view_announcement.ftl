<#include "../include/layout.ftl"/> 
<@layout>
<div class="g-auto g-cont">
	<div class="g-inner-box">
		<div class="g-crm">
			<span>当前位置：</span> 
			<a href="/" title="首页" class="u-home-ico"></a> 
			<span class="line">&gt;</span> 
			<a href="${ctx }/userCenter/announcement">公告列表</a> 
			<span class="line">&gt;</span> 
			<strong>公告详情</strong>
		</div>
		<@announcementDirective id=announcement.id relationId=announcement.announcementRelations[0].relation.id>
			<div class="g-detail-cont">
				<h1 class="title">${announcement.title! }</h1>
				<p class="info">
					<span>发布日期：${TimeUtils.formatDate(announcement.createTime, 'yyyy/MM/dd')}</span>
				</p>
				<div class="cont">
					${announcement.content! }
					<#if (announcement.fileInfos)?size gt 0>
						<#list announcement.fileInfos as fileInfo>
							<p>点击此处下载：<a onclick="downloadFile('${fileInfo.id}', '${fileInfo.fileName}')">${(fileInfo.fileName)!''}</a></p>
						</#list>
					</#if>
				</div>
			</div>
		</@announcementDirective>
	</div>
</div>
</@layout>
