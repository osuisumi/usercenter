<#macro imageFtl url default userId='' userName=''>
	<#if url != ''>
		<img src=${FileUtils.getFileUrl(url)} userId="${userId!}" userName="${userName!}" ctx="${ctx}" loginId="${ThreadContext.getUser().getId()}">
		<#else>
		<img src=${default} userId="${userId!}" userName="${userName!}" ctx="${ctx!}" loginId="${ThreadContext.getUser().getId()}">
	</#if>
</#macro>