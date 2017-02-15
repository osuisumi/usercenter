<!DOCTYPE html>
<html lang="zh-CN">
<head>
<meta charset="UTF-8">
<#global path="/user-center"> 
<#global app_path=PropertiesLoader.get('app.usercenter.path') >
<link rel="Shortcut Icon" href="${app_path}/images/favicon.ico">
<link rel="stylesheet" href="${app_path}/css/reset.css">
<link rel="stylesheet" href="${app_path}/css/style.css">
<link rel="stylesheet" href="${app_path}/css/zone.css">
<link rel="stylesheet" href="${app_path}/css/user-frame.css">
<link rel="stylesheet" href="${app_path}/css/user-style.css">
<script type="text/javascript" src="${ctx }/common/js/jquery.js"></script>
<title>${PropertiesLoader.get('app.name') }</title>
</head>
<body class="m-loginend-body">
	<div class="m-loginend">
		<dl class="m-loginend-role">
			<dt>
				<a href="javascript:;" class="who"> 
					<#import "/common/image.ftl" as image/>
					<@image.imageFtl url="${ThreadContext.getUser().avatar! }" default="/ncts/images/defaultAvatarImg.png" />
				</a>
				<p class="name">
					<a href="javascript:;">${Session.loginer.realName!}</a>
				</p>
				<div class="role-tl">
					<i class="left"></i> <span>角色选择</span> <i class="right"></i>
				</div>
			</dt>
			<dd>
				<ul>
					<#list enters as enter>
						<#if 'course_maker' = enter>
							<li onclick="window.open('/make/course')"><a href="###">课程制作</a></li>
						<#elseif 'course_teacher' = enter>	
							<li onclick="window.open('/teach/course')"><a href="###">课程助学</a></li>
						<#elseif 'user_center' = enter>	
							<li onclick="window.open('/userCenter')"><a href="###">个人中心</a></li>
						<#elseif 'super_manager' = enter>	
							<li onclick="window.open('/nts/manage')"><a href="###">后台管理</a></li>
						<#elseif 'workshop_member' = enter>	
							<li onclick="window.open('/userCenter/workshop/manage')"><a href="###">工作坊辅导</a></li>
						</#if>
					</#list>
				</ul>
			</dd>
		</dl>
	</div>
</body>
</html>
