<#global app_path=PropertiesLoader.get('app.usercenter.path') >
<@interestedWorkshopsDirective page=(pageBounds.page)!1 orders='CREATE_TIME.DESC'>
<dt>
	<h3>可能感兴趣的</h3>
	<#if interestedWorkshops?? && (interestedWorkshops?size >0) >
		<a href="javascript:;" onclick="changePage()"><i class="srh"></i>换一批</a>	
	</#if>
</dt>
	<#if interestedWorkshops?? && (interestedWorkshops?size>0)>
		<#list interestedWorkshops as workshop>
			<dd>
				<a href="${PropertiesLoader.get('wsts.domain') }workshop/${workshop.id}" target="_blank">
					<#import "/common/image.ftl" as image/>
					<@image.imageFtl url="${(workshop.imageUrl)! }" default="${app_path }/images/defaultWorkshop.png" />
				</a>
				<p class="tl">
					<a href="${PropertiesLoader.get('wsts.domain') }workshop/${workshop.id}" target="_blank">${(workshop.title)!}</a>
				</p>
				<p class="bulid">
					<strong><a href="${PropertiesLoader.get('wsts.domain') }workshop/${workshop.id}" target="_blank">${(workshop.creator.realName)!}</a> </strong><ins>创建于</ins>${TimeUtils.formatDate(workshop.createTime,'yyyy/MM/dd')}
				</p>
			</dd>
		</#list>
	<#else>
		<dd class="no-cont">
            <p>暂时没有内容</p>
        </dd>
	</#if>
<form id="interestedWorkshopsForm" action="${ctx}/userCenter/workshop/interested">
	<input type="hidden"  id = "interPage" value="${(paginator.page)!1}">
	<input type="hidden"  id="interTotalCount" value="${(paginator.totalCount)!0}">
	<input type="hidden" id="interLimit" value="${(pageBounds.limit)!5}">
</form>
</@interestedWorkshopsDirective>
<script>
	function changePage(){
		var nowPage = parseInt($('#interestedWorkshopsForm #interPage').val());
		var total = parseInt($('#interestedWorkshopsForm #interTotalCount').val());
		var limit = parseInt($('#interestedWorkshopsForm #interLimit').val());
		if(total>limit){
			if(nowPage*limit<total){
				$('#interestedWorkshopDiv').load('${ctx}/userCenter/workshop/interested','page='+(nowPage+1));
			}else{
				$('#interestedWorkshopDiv').load('${ctx}/userCenter/workshop/interested','page=1');
			}
		}
	}
	
</script>