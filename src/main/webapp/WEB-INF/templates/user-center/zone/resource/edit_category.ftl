<form id="saveCategoryForm" action="${ctx!}/userCenter/zone/resource/category" method="post">
	<#if (category.id)??>
		<input id="id" type="hidden" name="id" value="${(category.id)!}">
		<script>
			$('#saveCategoryForm').attr('method', 'put');
		</script>
	</#if>
	<input type="hidden" name="categoryRelation.category.id" value="${(category.id)!}">
	<input type="hidden" name="categoryRelation.relation.id" value="${(Session.loginer.id)!}">
	<input type="hidden" name="categoryRelation.relation.type" value="zone_resource">
	<div class="g-layer-wrap">
		<ul class="g-addElement-lst">
		    <li class="m-addElement-item">
		        <div class="ltxt">
		            类别名称：
		        </div>
		        <div class="center">
		            <div class="m-pbMod-ipt">
		                <input name="name" type="text" value="${(category.name)!}" placeholder="输入类别名称" class="u-pbIpt">
		            </div>
		        </div>
		    </li>
		    <li class="m-addElement-btn spc">
		        <a onclick="closeCategory()" class="btn u-inverse-btn u-cancelLayer-btn">取消</a>
		        <a onclick="submitCategory()" class="btn u-main-btn" id="confirmAddChapter">确定</a>
		    </li>
		</ul>
	</div>
</form>
<script>
	function submitCategory(){
		if (!$('#saveCategoryForm').validate().form()) {
			return false;
		}
		if($('#saveCategoryForm input[name=name]').val().length <= 0){
			return false;
		}
		var data = $.ajaxSubmit('saveCategoryForm');
		var json = $.parseJSON(data);
		if(json.responseCode == '00'){
			alert('保存成功');
			closeCategory();
			loadContent('resource');
		}
	};
	
	function closeCategory(){
		$('.mylayer-wrap').remove();
	};
</script>