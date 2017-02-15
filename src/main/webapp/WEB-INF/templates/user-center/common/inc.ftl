<#macro incFtl isHome=false>
	<#global path="/user-center"> 
	<#global app_path=PropertiesLoader.get('app.usercenter.path') >
	
	<#if isHome>
		<link rel="Shortcut Icon" href="${app_path }/images/favicon.ico">
		<!-- common -->
		<link rel="stylesheet" href="${ctx }/common/css/common.base.min.css">
	
	 	<link rel="stylesheet" href="${app_path }/css/app.min.css">
		<script type="text/javascript" src="${ctx }/common/js/common.base.min.js"></script>
		
		<script type="text/javascript" src="${app_path }/js/laypage/laypage.js"></script>
		<script type="text/javascript" src="${ctx }/common/js/My97DatePicker/WdatePicker.js"></script>
		<script type="text/javascript" src="${path }/js/user_center.min.js"></script>
		<script type="text/javascript" src="${path }/js/sso.js"></script>
	<#else>
		<link rel="Shortcut Icon" href="${app_path }/images/favicon.ico">
		<!-- common -->
		<link rel="stylesheet" href="${ctx }/common/css/common.base.min.css">
	
	 	<link rel="stylesheet" href="${app_path }/css/app.min.css">
		<script type="text/javascript" src="${ctx }/common/js/common.base.min.js"></script>
		
		<script type="text/javascript" src="${app_path }/js/laypage/laypage.js"></script>
		<script type="text/javascript" src="${ctx }/common/js/My97DatePicker/WdatePicker.js"></script>
		<script type="text/javascript" src="${path }/js/user_center.min.js"></script>
		
		<!-- ueditor -->
		<script type="text/javascript" src="${ctx }/common/js/ueditor/ueditor.config.js"></script>
		<script type="text/javascript" src="${ctx }/common/js/ueditor/ueditor.all.min.js"></script>
		<script type="text/javascript" src="${ctx }/common/js/ueditor/lang/zh-cn/zh-cn.js"></script>
		<script type="text/javascript" src="${ctx }/common/js/ueditorUtils.js"></script>
	
		<!--calendar-->
		<script type="text/javascript" src="${path }/js/calendar/js/fullcalendar.min.js"></script>
		<script type="text/javascript" src="${path }/js/calendar/js/jquery.fancybox-1.3.1.pack.js"></script>
		<script type="text/javascript" src="${path }/js/calendar/js/jquery-ui-1.10.3.custom.min.js"></script>
		<script type="text/javascript" src="${path }/js/calendar/js/addplay.js"></script>
		<!--jqthumb-->
		<script type="text/javascript" src="${path }/js/jqthumb.min.js"></script>
	</#if>
</#macro>
