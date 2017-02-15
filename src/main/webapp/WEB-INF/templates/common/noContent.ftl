<#assign app_path=PropertiesLoader.get('app.ncts.path') >
<#if app_path == '/ncts/lego'>
	<#assign project="lego" />
<#else>
	<#assign project="default" />
</#if>

<#macro noContentFtl msg='' top='' height='' minHeight='' size='big'>
<div class="no-content-${project}-${size} admin" style="<#if top != ''>margin-top:${top }px;</#if><#if height != ''>height:${height }px;</#if>" <#if minHeight!=''>min-height=${minHeight}px;</#if>>
    <p class="txt">
		<#if msg != ''>
			${msg}
		<#else>
			暂无数据
		</#if>
    </p>
</div>
</#macro>