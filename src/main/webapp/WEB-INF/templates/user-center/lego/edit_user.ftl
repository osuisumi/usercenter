<form id="saveUserForm" action="/lego/user/save_user" method="put">	
	<div class="g-welcome-layer">
		<@userInfoDirective id=Session.loginer.id>
			<#assign userInfo=userInfo>
			<@userRegionsDirective userId=(Session.loginer.id)!''>
				<#assign userRegions=userRegions!>
			</@userRegionsDirective>
		</@userInfoDirective>
	    <div class="g-hd-tit">
	        <i></i>
	        <h2>欢迎进入教育部-乐高“创新人才培训计划”培训平台</h2>
	    </div>
	    <div class="g-con">
	        <p class="u-tips">以下信息与您的培训内容、证书打印及学时录入息息相关，请务必谨慎核实您的个人信息。避免因您未核实信息，导致您未能正常登录学习。</p>
	        <div class="form-wrap">
	            <ul class="g-addElement-lst">
	                <li class="m-addElement-item">
	                    <div class="ltxt">用 户 名：</div>
	                    <div class="center">
	                        <p class="txt">${userInfo.userName!}</p>
	                    </div>
	                </li>
	                <li class="m-addElement-item">
	                    <div class="ltxt"><em>*</em>姓　　名：</div>
	                    <div class="center">
	                        <div class="m-pbMod-ipt">
	                            <input type="text" name="realName" value="${userInfo.realName!}" class="u-pbIpt required">
	                        </div>
	                    </div>
	                </li>
	                <li class="m-addElement-item">
	                    <div class="ltxt"><em>*</em>所属区域：</div>
	                    <div class="center">
	                        <div class="m-slt-row space">
	                            <div class="block">
	                                <div class="m-selectbox style1">
	                                    <strong><span class="simulateSelect-text">请选择省</span><i class="trg"></i></strong>
	                                    <select id="province" name="userRegions.province">
	                                    	<option class="static" value="">请选择省</option>
	                                    	<#list RegionsUtils.getEntryList('1') as entry>
	                                    		<option value="${entry.regionsCode}">${entry.regionsName}</option>
	                                    	</#list>
	                                    </select>
	                                </div>
	                            </div>
	                            <div class="space"></div>
	                            <div class="block">
	                                <div class="m-selectbox style1">
	                                    <strong><span class="simulateSelect-text">请选择市</span><i class="trg"></i></strong>
	                                    <select id="city" name="userRegions.city">
	                                    	<option class="static" value="">请选择市</option>
	                                    	<#if (userRegions.province)??>
												<#list RegionsUtils.getEntryList('2', (userRegions.province)!'') as entry>
		                                    		<option class="cityOption" value="${entry.regionsCode}">${entry.regionsName}</option>
		                                    	</#list>
											</#if>
	                                    </select>
	                                </div>
	                            </div>
	                            <div class="space"></div>
	                            <div class="block">
	                                <div class="m-selectbox style1">
	                                    <strong><span class="simulateSelect-text">请选择区</span><i class="trg"></i></strong>
	                                    <select id="area" name="userRegions.counties">
	                                    	<option class="static" value="">请选择区</option>
	                                        <#if (userRegions.city)??>
												<#list RegionsUtils.getEntryList('3', (userRegions.city)!'') as entry>
		                                    		<option class="areaOption" value="${entry.regionsCode}">${entry.regionsName}</option>
		                                    	</#list>
											</#if>
	                                    </select>
	                                </div>
	                            </div>
	                        </div>
	                    </div>
	                </li>
	                <li class="m-addElement-item">
	                    <div class="ltxt"><em>*</em>所属单位：</div>
	                    <div class="center">
	                        <div class="m-pbMod-ipt">
	                            <input type="text" name="department.deptName" value="${(userInfo.department.deptName)!''}" class="u-pbIpt required">
	                        </div>
	                    </div>
	                </li>
	                <li class="m-addElement-item">
	                    <div class="ltxt"><em>*</em>学科学段：</div>
	                    <div class="center">
	                        <div class="m-slt-row section">
	                            <div class="block">
	                                <div class="m-selectbox style1">
	                                    <strong><span class="simulateSelect-text">请选择学科</span><i class="trg"></i></strong>
	                                    <select id="subject" name="subject">
	                                    	<option class="static" value="">请选择学科</option>
	                                    	<#list TextBookUtils.getEntryList('SUBJECT') as entry>
	                                    		<#if entry.textBookName != '全学科'>
	                                    			<option value="${entry.textBookValue}">${entry.textBookName}</option>
	                                    		</#if>
	                                    	</#list>
	                                    </select>
	                                </div>
	                            </div>
	                            <div class="space"></div>
	                            <div class="block">
	                                <div class="m-selectbox style1">
	                                    <strong><span class="simulateSelect-text">请选择学段</span><i class="trg"></i></strong>
	                                    <select id="stage" name="stage">
	                                    	<option class="static" value="">请选择学段</option>
	                                        <#list TextBookUtils.getEntryList('STAGE') as entry>
	                                    		<#if entry.textBookName != '全学段'>
	                                    			<option value="${entry.textBookValue}">${entry.textBookName}</option>
	                                    		</#if>
	                                    	</#list>
	                                    </select>
	                                </div>
	                            </div>
	                        </div>
	                    </div>
	                </li>
	                <li class="m-addElement-item">
	                    <div class="ltxt"><em>*</em>邮　　箱：</div>
	                    <div class="center">
	                        <div class="m-pbMod-ipt">
	                            <input type="text" name="email" value="${userInfo.email!}" class="u-pbIpt required">
	                        </div>
	                    </div>
	                </li>
	                <#--<li class="m-addElement-item">
	                    <div class="ltxt"><em>*</em>手 机 号：</div>
	                    <div class="center">
	                        <p class="txt">13800013800<a href="javascript:;" class="post-yzm">发送短信验证码</a></p>
	                    </div>
	                </li>
	                <li class="m-addElement-item">
	                    <div class="center">
	                        <div class="write-yzm">
	                            <div class="lt">
	                                <div class="m-pbMod-ipt">
	                                    <input type="text" placeholder="填写验证码" class="u-pbIpt">
	                                </div>
	                            </div>
	                            <div class="rt">
	                                <a href="javascript:;" class="u-btn-theme">确认</a>
	                                <span class="tip-txt">请在60秒内输入验证码！</span>
	                            </div>
	                        </div>
	                        <p class="txt1"><i class="ico-tips"></i>提示：手机号非本人使用或需要改手机号请与客服人员联系。</p>
	                    </div>
	                </li>-->
	            </ul>
	            <a onclick="saveUser()" href="javascript:;" class="check-info active">本人已核实以上信息属实</a>
	            <!-- <a href="javascript:;" class="check-info active">本人已核实以上信息属实</a> --><!-- 加上active，按钮处于激活状态 -->
	        </div>
	    </div>
	</div>
</form>
<script>
	$(function(){
		//模拟下拉框
	    $("#province").simulateSelectBox({
	    	byValue: '${(userRegions.province)!""}'
	    });
	    $("#city").simulateSelectBox({
	    	byValue: '${(userRegions.city)!""}'
	    });
	    $("#area").simulateSelectBox({
	    	byValue: '${(userRegions.counties)!""}'
	    });
	    $("#stage").simulateSelectBox({
	    	byValue: '${(userInfo.stage)!""}'
	    });
	    $("#subject").simulateSelectBox({
	    	byValue: '${(userInfo.subject)!""}'
	    });
	
		//省市区联动
	    $('#province').on('change',function(){
	    	var _this = $(this);
	    	$.get('${ctx}/regions/entities',{
	    		"level":'2',
	    		"parentCode":_this.val(),
	    	},function(regions){
	    		$('#city .cityOption').remove();
	    		$('#city .static').attr('selected','selected');
	    		$('#city').parent().find('.simulateSelect-text').text($('#city').find('option:selected').text());
	    		$('#city').trigger('change');
	    		$.each(regions,function(i,n){
	    			$('#city').append('<option class="cityOption" value="'+n.regionsCode+'" >'+n.regionsName+'</option>');
	    		});
	    	});
	    });
	    
	    $('#city').on('change',function(){
	    	var _this = $(this);
	    	$.get('${ctx}/regions/entities',{
	    		"level":'3',
	    		"parentCode":_this.val(),
	    	},function(regions){
	    		$('#area .areaOption').remove();
	    		$('#area .static').attr('selected','selected');
	    		$('#area').parent().find('.simulateSelect-text').text($('#area').find('option:selected').text());
	    		$.each(regions,function(i,n){
	    			$('#area').append('<option class="areaOption" value="'+n.regionsCode+'" >'+n.regionsName+'</option>');
	    		});
	    	});
	    });
		
	});
    
    function saveUser(){
    	if(!$('#saveUserForm').validate().form()){
    		return false;
    	}
    	var province = $('#province option[selected="selected"]').attr('value') || $('#province').val();
    	if(province.length == 0){
    		alert('请选择省份');
    		return false;
    	}
    	var stage = $('#stage option[selected="selected"]').attr('value') || $('#stage').val();
    	if(stage.length == 0){
    		alert('请选择学段');
    		return false;
    	}
    	var subject = $('#subject option[selected="selected"]').attr('value') || $('#subject').val();
    	if(subject.length == 0){
    		alert('请选择学科');
    		return false;
    	}
    	confirm('确定已核实所有信息? 请注意一旦确认将无法更改', function(){
    		$('.check-info').removeClass('active');
    		var data = $.ajaxSubmit('saveUserForm');
    		var json = $.parseJSON(data);
    		if(json.responseCode == '00'){
    			window.location.reload();
    		}
    	});
    }
</script>