<form id="saveResourceForm" action="${ctx!}/userCenter/zone/resource" method="post">
	<#if (resource.id)??>
		<input id="id" type="hidden" name="id" value="${(resource.id)!}">
		<script>
			$('#saveResourceForm').attr('method', 'put');
		</script>
	</#if>
	<input type="hidden" name="resourceRelations[0].relation.id" value="${(Session.loginer.id)!}">
	<input type="hidden" name="resourceRelations[0].relation.type" value="zone">
	<input type="hidden" name="belong" value="personal">
 <div class="g-layer-wrap">
    <ul class="g-addElement-lst">
        <li class="m-addElement-item">
            <div class="ltxt">
                <em>*</em>资源名称：
            </div>
            <div class="center">
                <div class="m-pbMod-ipt">
                    <input name="title" type="text" value="${(resource.title)!}" placeholder="输入资源名称..." class="u-pbIpt">
                </div>
            </div>
        </li>
        <li class="m-addElement-item">
            <div class="ltxt">
                <em>*</em>资源描述：
            </div>
            <div class="center">
                <div class="m-pbMod-ipt">
                    <textarea name="summary" class="u-textarea" placeholder="输入资源描述...">${(resource.summary)!}</textarea>
                </div>
            </div>
        </li>
        <li class="m-addElement-item">
            <div class="ltxt">分类：</div>
            <div class="center">
                <div class="m-slt-row date">
                    <div class="block w_auto">
                        <div class="m-selectbox style1">
                            <strong><span class="simulateSelect-text type"></span><i class="trg"></i></strong>
                            <select id="selectResourceType" name="type">
                            	<option value="" >请选择...</option>
	                            <@resourcesDirective userId=userId!>
	                            	<#list categories as category>
	                            		<option value="${(category.id)!}" >${(category.name)!}</option>
	                            	</#list>
	                            </@resourcesDirective>
                            </select>
                            <script>
                            	$(function(){
                            		var resourceType = '${(resource.type)!""}';
                            		$('#selectResourceType option').each(function(i){
                            			if(resourceType == $(this).val()){
                            				$(this).attr("selected",true);
                            			}
                            		});
                            	});
                            </script>
                        </div>
                    </div>
                </div>
            </div>
        </li>
        <li class="m-addElement-item">
            <div class="ltxt">权限：</div>
            <div class="center">
                <div class="m-slt-row date">
                    <div class="block w_auto">
                        <div class="m-selectbox style1">
                            <strong><span class="simulateSelect-text">公开</span><i class="trg"></i></strong>
                            <select id="selectResourcePrivilege" name="privilege">
                            	<#assign privilege = (resource.privilege)!'public'>
                            	<option value="${privilege}" style="display:none"></option>
	                            <option value="public" <#if privilege == 'public'>selected="selected"</#if> >公开 </option>
	                            <option value="private" <#if privilege == 'private'>selected="selected"</#if> >隐私</option>
                            </select>
                        </div>
                    </div>
                </div>
            </div>
        </li>
        <li class="m-addElement-item">
            <div class="ltxt">上传：</div>
            <div class="center">
                <div class="m-slt-row date">
                    <div class="file-ipt">
	                    <div id="fileDiv" class="center">
		                    <#import "/common/upload_file_list.ftl" as uploadFileList />
							<@uploadFileList.uploadFileListFtl relationId="${(resource.id)!}" relationType="resources" paramName="fileInfos" btnTxt="添加资源" fileNumLimit=1 />
	                    </div>                              
                    </div>
                </div>
            </div>
        </li>
        <li class="m-addElement-btn">
            <a onclick="submitResource()" class="btn u-main-btn" id="confirmAddChapter">确定</a>
            <a onclick="closeResource()" class="btn u-inverse-btn u-cancelLayer-btn">取消</a>
        </li>
    </ul>
 </div>
</form>
<script>
	$(function(){
			$("#saveResourceForm .m-selectbox select").simulateSelectBox();
	});

	function submitResource(){
		if (!$('#saveResourceForm').validate().form()) {
			return false;
		}
		var data = $.ajaxSubmit('saveResourceForm');
		var json = $.parseJSON(data);
		if(json.responseCode == '00'){
			if($('#saveResourceForm').attr('method') == 'post'){
				$('.resoucesNum').text(parseInt($('.resoucesNum').text())+1);
			}
			alert('上传成功');
			$.ajaxQuery('listResourceForm', 'zoneContent');
			closeResource();
		}
	};
	
	function closeResource(){
		$('.mylayer-wrap').remove();
	};


</script>