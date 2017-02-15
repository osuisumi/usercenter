<form id="saveDiaryForm" action="${ctx!}/userCenter/zone/diary" method="post">
	<#if (diary.id)??>
		<input id="id" type="hidden" name="id" value="${(diary.id)!}">
		<script>
			$('#saveDiaryForm').attr('method', 'put');
		</script>
	</#if>
		<div class="g-layer-wrap">
	    <ul class="g-addElement-lst">
	        <li class="m-addElement-item">
	            <div class="ltxt">
	                <em>*</em>标题：
	            </div>
	            <div class="center">
	                <div class="m-pbMod-ipt">
	                    <input name="title" type="text" value="${(diary.title)!}" placeholder="输入日志名称..." class="u-pbIpt">
	                </div>
	            </div>
	        </li>
	        <li class="m-addElement-item">
	            <div class="ltxt">
	                <em>*</em>内容：
	            </div>
	            <div class="center">
	                <!-- 加载编辑器的容器 -->
	                <div class="m-editor">
	                    <script id="editor"  type="text/plain" style="min-height:260px;">
	                    </script>                        
						<input id="diaryContent" name="content" type="hidden">
	                </div>
	            </div>
	        </li>
	        <li class="m-addElement-item">
	            <div class="ltxt">分类：</div>
	            <div class="center">
	                <div class="m-slt-row date">
	                    <div class="block w_auto">
	                        <div class="m-selectbox style1">
	                            <strong><span class="simulateSelect-text"></span><i class="trg"></i></strong>
	                            <select id="selectDiaryCategory" name="diaryCategory.id">
	                            	<#assign optionId = (diary.diaryCategory.id)!'1'>
	                            	<option value="${optionId}" style="display:none"></option>
	                                <option value="1" <#if optionId == "1">selected="selected"</#if> >教学设计</option>
	                                <option value="2" <#if optionId == "2">selected="selected"</#if> >课堂实录</option>
	                            </select>
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
	                            <strong><span class="simulateSelect-text"></span><i class="trg"></i></strong>
	                            <select id="selectDiaryVisitPermission" name="visitPermission">
	                            	<#assign permission = (diary.visitPermission)!'public'>
	                            	<option value="${permission}" style="display:none"></option>
	   	                            <option value="public" <#if permission == 'public'>selected="selected"</#if> >公开 </option>
	                           		<option value="private" <#if permission == 'private' >selected="selected"</#if> >隐私</option>
	                            </select>
	                        </div>
	                    </div>
	                    <!-- <div class="share"><label><input type="checkbox">分享到校本研修</label></div> -->
	                </div>
	            </div>
	        </li>
	        <li class="m-addElement-item">
	            <div class="ltxt">附件：</div>
	            <div class="center">
	                <div class="m-slt-row date">
	                    <div class="file-ipt">
	                    	<div id="fileDiv" class="center">
                        		<#import "/common/upload_file_list.ftl" as uploadFileList />
								<@uploadFileList.uploadFileListFtl relationId="${(diary.id)!}" relationType="diary" paramName="fileInfos" btnTxt="添加附件" fileNumLimit=5 />
	                    	</div>
	                    </div>
	                </div>
	            </div>
	        </li>
	        <li class="m-addElement-btn">
	            <a onclick="saveDiary()" class="btn u-main-btn" id="confirmAddChapter">确定</a>
	            <a onclick="cancle()" class="btn u-inverse-btn u-cancelLayer-btn">取消</a>
	        </li>
	    </ul>
	</div>
</form>
<script>
	$(function(){
			$(".m-selectbox select").simulateSelectBox();
		}
	);

	var ue = initProduceEditor('editor', '${(diary.content)!}', '${(Session.loginer.id)!}');

	function cancle(){
		$('.mylayer-wrap').remove();
	};
	
	function saveDiary(){
		if(!$('#saveDiaryForm').validate().form()){
			return false;
		}
		var content = ue.getContent();
		if(content.length == 0){
			alert("内容不能为空");
			return false;
		}
		$('#diaryContent').val(content);
		var data = $.ajaxSubmit('saveDiaryForm');
		var json = $.parseJSON(data);
		if(json.responseCode == '00'){
			alert("保存成功!");
			loadContent('diary');
			cancle();
		}
	};

</script>