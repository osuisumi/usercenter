<@resourcesDirective resource=resource userId=userId! pageBounds=pageBounds>
<dl class="m-dynamic">
    <dt class="m-zone-mod m-all-dynamic">
        <h3 class="u-tit">我的资源</h3>
       
        <#if ThreadContext.getUser().getId() == userId!>
        	<a href="javascript:void(0);" class="u-btn u-btn-upload"><i class="u-ico-upload"></i>上传资源</a>
        </#if>
    </dt>
    <dd class="m-zone-mod m-person-dynamic">
        <div class="g-resources-lst">
        
			<div class="g-resource-type">
			    <div class="type-lst" id="typePart">
			        <span class="u-tt">类别：</span>
			        <a class="tab searchResourceByType z-crt" resourceType="all" >全部</a>
			        <#list categories as c>
			        	<#if c_index < 5>
				        	<span class="u-line">|</span>
				        	<a class="tab searchResourceByType" resourceType="${(c.id)!}">${(c.name)!''}</a>
			        	</#if>
			        </#list>
			        <a href="javascript:;" class="open">展开全部<i class="u-ico-dp"></i></a>
			    </div>
			    <div class="type-lst all" id="typeAll">
			        <span class="u-tt">类别：</span>
			        <a class="tab searchResourceByType z-crt" resourceType="all" >全部</a>
			        <#list categories as c>
				    	<span class="u-line">|</span>
				    	<a class="tab searchResourceByType" resourceType="${(c.id)!}">${(c.name)!''}</a>
			        </#list>
			        <a href="javascript:;" class="open">收起<i class="u-ico-dp"></i></a>
			    </div>
			    <div class="u-opa">
			        <a class="u-view-btn btn" id="addClass">+ 添加分类</a>
			        <a class="u-view-btn btn" id="manageClass"><i class="u-ico-mag"></i>管理分类</a>
			    </div>
			</div>

            <ul class="g-fileType-lst" id="resourceList">
            	<#list resources as resource>
                <li>
                    <div class="m-fileType-block">
                    	<#if (FileTypeUtils.getFileTypeClass((resource.fileInfos[0].fileName)!, 'resourceZone')! != 'img')>
					   		<a class="${FileTypeUtils.getFileTypeClass((resource.fileInfos[0].fileName)!, 'resourceZone') }" ></a>
					    <#else>
						    <img src=${FileUtils.getFileUrl((resource.fileInfos[0].url)!'/ncts/images/logo2.png')} class="u-ico-file">
					    </#if>
                        <h3 class="tt"><a href="javascript:void(0);">${(resource.title)!}</a></h3>
                        <div class="btn-row">
                        	<#if resourceTypeNames?exists>
                        		<#if (resourceTypeNames[resource.type])?exists>
	                           		<a class="u-view-btn btn searchResourceByType" resourceType=${(resource.type)!}>${resourceTypeNames[resource.type]!''}</a>
								</#if>
							</#if>
                        </div>
                        <span class="size spc"><span class="date">${resource.createTime?number_to_datetime?string("yyyy/MM/dd  HH:mm:ss")!}</span>${(resource.fileInfos[0].fileSize /1024/1024)!0}MB</span>
                        <div class="optRow">
                            <a onclick="previewFile('${(resource.fileInfos[0].id)!}')" class="u-opt u-view"><i class="u-view-ico"></i><span class="tip">预览</span></a>
                            <a class="u-opt u-download" onclick="downloadFile('${(resource.fileInfos[0].id)!}','${(resource.fileInfos[0].fileName)!}')"><i class="u-download-ico"></i><span class="tip">下载</span></a>
                            <#if ThreadContext.getUser().getId() == userId!>
                            	<a class="u-opt u-alter"  resourceId="${(resource.id)!}"><i class="u-alter-ico"></i><span class="tip">编辑</span></a>
                            	<#-- <a class="u-opt u-issue"  resourceId=${(resource.id)!}><i class="u-issue-ico"></i><span class="tip">发布</span></a> -->
                            	<a class="u-opt u-delete" resourceId="${(resource.id)!}" resourceRelationId="${(resource.resourceRelations[0].id)!}"><i class="u-delete-ico"></i><span class="tip">删除</span></a>
                            </#if>
                        </div>
                    </div>
                </li>
                </#list>
            </ul>
            <form id="listResourceForm"  method="post" action="${ctx!}/userCenter/zone/resource" >	
				<input type="hidden" name="_method" value="get">
				<input type="hidden" name="orders" value="CREATE_TIME.DESC">
				<input class="limit" type="hidden" name="limit" value="10" >
				<input type="hidden" name="userId" value="${userId!}" >
				<input type="hidden" name="creator.id" value="${userId!}" >
				<input type="hidden" name="type" value="${(resource.type)!}">
				<div id="myCoursePage" class="m-laypage"></div>
			<#if paginator??>
				<#import "../../../common/pagination_ajax.ftl" as p/>
				<@p.paginationAjaxFtl formId="listResourceForm" divId="myCoursePage" paginator=paginator contentId="zoneContent"/>
			</#if>
			</form>
        </div>
    </dd>  
</dl>
</@resourcesDirective>
<script>
$(function(){

 	$.ajaxSetup({
 		cache:false
 	});
 	
	changeZoneItem('resource');
	
	//设置分类选中状态css
	var resourceType = $('#listResourceForm input[name="type"]').val().trim();
	$('.searchResourceByType').removeClass('z-crt');
	$('.searchResourceByType').each(function(){
		if($(this).hasClass('tab') && $(this).attr('resourceType') == resourceType){
			$(this).addClass('z-crt');
		}
		if(resourceType == 'all' || resourceType == ''){
			if($(this).attr('resourceType') == 'all'){
				$(this).addClass('z-crt');
			}
		}
	});
	
	//根据资源类别的位置是否展开类别
	$('#typeAll').find('.tab.searchResourceByType').each(function(i){
		if($(this).hasClass('z-crt')){
			if(i > 5){
				$("#typePart").hide();
				$("#typeAll").show();
			}
		}
	});
    
	//分类栏打开和缩起
    var open_par = $("#typePart"),
    close_par = $("#typeAll"),
    btn_open = open_par.find(".open"),
    btn_close = close_par.find(".open");
    
	btn_open.on("click",function(){
	    open_par.hide();
	    close_par.show();
    });
	btn_close.on("click",function(){
	    open_par.show();
	    close_par.hide();
	});
	
    //添加分类弹框
    $("#addClass").on("click",function(){
        mylayerFn.open({
            type: 2,
            title: "添加分类",
            fix: false,
            shade: 0.6,
            area: [700, 300],
            content: "${ctx!}/userCenter/zone/resource/category/create",
            shadeClose: true,
       		offset:[$(document).scrollTop()]
        });
    });
	
    //管理分类弹框
    $("#manageClass").on("click",function(){
        mylayerFn.open({
            type: 2,
            title: "管理分类",
            fix: false,
            shade: 0.6,
            area: [700, 590],
            content: "${ctx!}/userCenter/zone/resource/category?userId=${userId}",
            shadeClose: true,
       		offset:[$(document).scrollTop()]
        });
    });
        
	//新增
    $(".u-btn-upload").on("click",function(){    
        mylayerFn.open({
        type: 2,
        title: '上传资源',
        fix: false,
        area: [700, 590],
        content: '${ctx!}/userCenter/zone/resource/create?userId=${userId}',
        shadeClose: true,
        offset:[$(document).scrollTop()]
    	});
    });
    
    //修改
    $(".u-alter").on("click",function(){
        mylayerFn.open({
        type: 2,
        title: '编辑资源',
        fix: false,
        area: [700, 590],
        content: '${ctx!}/userCenter/zone/resource/'+$(this).attr('resourceId')+'/edit?userId=${userId}',
        shadeClose: true,
        offset:[$(document).scrollTop()]
    	});
    });
    
    //删除
    $(".u-delete").on("click",function(){
    	var data = 'id='+$(this).attr('resourceId');
    	data = data + '&resourceRelations[0].id=' + $(this).attr('resourceRelationId');
	    mylayerFn.confirm({
	        content: "确定删除？",
	        icon: 3,
	        yesFn: function(){
				$.ajaxDelete('${ctx!}/userCenter/zone/resource',data,function(data){
			    	if(data.responseCode == '00'){
			    		$('.resoucesNum').text(parseInt($('.resoucesNum').text())-1);
			    		alert('删除成功');
			    		$.ajaxQuery('listResourceForm', 'zoneContent');
			    	}
		    	}); 
	        }
	    });
    });
    
    //分类查询
    $(".searchResourceByType").on("click",function(){
        searchResource($(this).attr('resourcetype'));
    });
    
});
	
	function searchResource(type){
		if('all' == type){
			type = '';
		}
		$('#listResourceForm input[name="type"]').val(type);
		$('#listResourceForm').attr('action','${ctx!}/userCenter/zone/resource');
		$('#listResourceForm #currentPage').val(1);
		$.ajaxQuery('listResourceForm', 'zoneContent');
	};

</script>