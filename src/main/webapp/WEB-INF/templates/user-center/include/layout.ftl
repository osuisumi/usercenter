<#macro layout isHome=false>
<!DOCTYPE html>
<html lang="zh-CN">
	<head>
		<meta charset="UTF-8">
		<meta name="renderer" content="webkit">
		<meta http-equiv="X-UA-Compatible" content="IE=Edge,chrome=1">
		<meta name="author" content="smile@kang.cool">
		<meta name="description" content="hello">
		<meta name="keywords" content="a,b,c">
		<meta http-equiv="Window-target" content="_top">
		<#import "../common/inc.ftl" as inc />
		<@inc.incFtl isHome=isHome />
		<title>个人中心首页</title>
	</head>
	<body class="userbg">
		<div id="g-wrap">
			<div id="loadHeaderFrame">
			<#import "top.ftl" as top />
			<@top.topFtl />
			</div>
			<div class="g-user-bd">
					<div id="content">
						<#nested>
					</div>
				</div>
			</div>
			<div id="loadFooterFrame">
				<#import "${app_path }/include/footer.ftl" as footer />
				<@footer.footerFtl />
			</div>
		</div>
		<form id="downloadFileForm" action="/file/downloadFile" method="post" target="_blank">
			<input type="hidden" name="id">
			<input type="hidden" name="fileName">
			<input type="hidden" name="fileRelations[0].type"> 
			<input type="hidden" name="fileRelations[0].relation.id"> 
		</form>
		<form id="updateFileForm" target="_blank">
			<input type="hidden" name="id">
			<input type="hidden" name="fileName">
		</form>
		<form id="deleteFileRelationForm" target="_blank">
			<input type="hidden" name="fileId">
			<input type="hidden" name="relation.id">
			<input type="hidden" name="type">
		</form>
		<form id="deleteFileInfoForm" target="_blank">
			<input type="hidden" name="id">
		</form>
	</body>
</html>
</#macro>
