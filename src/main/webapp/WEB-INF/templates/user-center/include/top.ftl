<#macro topFtl>
	<div id="g-hd">
        <div class="g-auto">
            <h1 id="m-logo">
                <a href="###">
                    <img src="${app_path }/images/logo.png" alt="${PropertiesLoader.get('app.name') }">
                    <span>${PropertiesLoader.get('app.name') }</span>
                </a>
            </h1>
            <ul class="m-tp-opt">
                <li class="user">
                    <a href="javascript:void(0);" class="show">
                    	<#import "/common/image.ftl" as image/>
						<@image.imageFtl url="${ThreadContext.getUser().avatar! }" default="${app_path}/images/defaultAvatarImg.png" />
                        <span>${(ThreadContext.getUser().realName)!}</span><i class="u-trg-ico"></i>
                    </a>
                    <div class="lst">
                        <i class="trg"><i></i></i>
						<a onclick="goEditUser('${(ThreadContext.getUser().id)!}')" href="javascript:void(0);"><i class="u-user1-ico"></i> 用户资料</a>                        
                        <a onclick="goChangePassword()" href="javascript:void(0);"><i class="u-user2-ico"></i>修改密码</a>
                        <a href="${ctx}/logout"><i class="u-exit2-ico"></i>退出登录</a>
                    </div>
                </li>
 				<li class="g-notice">
					<a id="messageBtn" onclick="loadMore()" href="javascript:void(0);" class="u-bell"><i class="u-bell-ico"></i>消息</a>
					<div class="m-mouse-news">
						<i class="arrow-icon"></i>
						<ul id="messageList" class="m-mouse-txt">
							
						</ul>
						<div class="m-h-more">
							<a onclick="loadMore()" href="javascript:void(0);" class="more"><i class="u-h-see"></i>查看更多</a>
						</div>
					</div>
				</li>
            </ul>
        </div>
        <div class="g-hd-border"></div>
    </div>
<!--end header -->
<!--begin user menu -->
<div class="g-user-menu">
	<ul id="topNavigation" class="m-user-menu g-auto">
		<li class="item1 index">
			<a href="${ctx}/userCenter">首页</a>
		</li>
		<li class="item2 zone">
			<a href="${ctx}/userCenter/zone/index?userId=${ThreadContext.getUser().getId()}">个人空间</a>
		</li>
		<#if app_path != '/user-center/lego' && app_path != '/user-center/nea'>
			<li class="item3 course">
				<a href="${ctx}/userCenter/course?state=pass">课程中心</a>
			</li>
		</#if>
		<li class="item4 workshop">
			<a href="${ctx}/userCenter/workshop?isTemplate=N&state=published" > 教师工作坊</a>
		</li>
		<li class="item5 community">
			<a href="${ctx }/userCenter/community" >社区</a> 
			<#-- <a href="http://sbt.gdjspx.cn" target="_blank" >社区</a>-->
		</li>
	</ul>
</div>
<#--<form id="goSbtForm" class="form-horizontal" action="http://sbtlogin.gdjspx.cn/login" onsubmit="return goSbt();"  method="post" target="ssoLoginFrame">
	<input type="hidden" name="service" value="http://sbt.gdjspx.cn/shiro-cas">
	<input name="username" id="J_Username" type="hidden" value="${Session.loginer.userName}" />
	<input name="password" id="J_Password" type="hidden" value="px123" />
	<div class="clearfix">
		<input type="hidden" name="isajax" value="true" />  
        <input type="hidden" name="isframe" value="true" />  
        <input type="hidden" name="lt" value="" id="J_LoginTicket"> 
        <input type="hidden" name="execution" id="J_Execution" value="" />  
        <input type="hidden" name="_eventId" value="submit" />  
	</div>
</form>-->
<script>
	function callback(){
	}
	
	function getTicket(){
	}

	$(document).ready(function(){   
	   /** var _services = 'service=' + encodeURIComponent('http://sbt.gdjspx.cn');
		$.ajax({
			type : "get",
			async : false,
			url : "http://sbtlogin.gdjspx.cn/login?" + _services + "&get-lt=true&n=" + new Date().getTime(),
			dataType : "jsonp",
			jsonp : "callback",// 传递给请求处理程序或页面的，用以获得jsonp回调函数名的参数名(一般默认为:callback)
			jsonpCallback : "getTicket",// 自定义的jsonp回调函数名称，默认为jQuery自动生成的随机函数名，也可以写"?"，jQuery会自动为你处理数据
			success : function(json) {
				$('#J_LoginTicket').val(json._loginTicket);
				$("#J_Execution").val(json.flowExecution);
				$('#goSbtForm').submit();
			},
			error : function(a,textStatus, b) {
				alert(textStatus);
			}
		});*/
	}); 
	
	function submitSbtForm(){
		$('#goSbtForm').submit();
	}
	
	function changeTab(type){
		$('#topNavigation li.'+type).addClass('z-crt');
	}
	
	function loadMore(){
		$('#content').load('${ctx}/message/list/more?orders=CREATE_TIME.DESC');
	}

	$(function(){
		$('#messageBtn').hover(function(){
			var li = $('#messageList li');
			if(li.size() <= 0){
				$('#messageList').load("${ctx}/message/list?orders=CREATE_TIME.DESC");
			}
		},function(){});
	});
	
	function goChangePassword(){
		mylayerFn.open({
	        type: 2,
	        title: '修改密码',
	        fix: false,
	        area: [620, 480],
	        content: '/ncts/account/edit_password',
	    });
	}
	
	function goEditUser(userId){
		mylayerFn.open({
	        type: 2,
	        title: '个人资料',
	        fix: false,
	        area: [650, $(window).height()],
	        content: '/ncts/users/'+userId+'/edit',
	        shadeClose: true
	    });
	};
</script>
</#macro>
