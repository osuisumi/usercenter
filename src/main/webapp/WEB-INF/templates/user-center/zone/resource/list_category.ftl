<@resourcesDirective userId=userId!>
	<div class="g-layer-wrap">
		<ul class="m-manage-class">
			<#list categories as category>
		        <li categoryId="${(category.id)!}">
		            <div class="u-txt">
		                <span class="txt">${(category.name)!}</span>
		                <a class="u-view-btn btn u-btn-del"><i class="u-ico-del"></i>删除</a>
		                <a class="u-view-btn btn u-btn-edit"><i class="u-ico-edit2"></i>编辑</a>
		            </div>
		            <div class="u-ipt">
		                <input type="text" class="ipt">
		                <a class="u-view-btn btn btn1 u-btn-save">保存</a>
		                <a class="u-view-btn btn u-btn-cancel">取消</a>
		            </div>
		        </li>
			</#list>
	    </ul>
	</div>
</@resourcesDirective>
<script>
    $(function(){
        var btn_edit = $(".u-btn-edit"),            //获取编辑按钮
            btn_del = $(".u-btn-del"),              //获取删除按钮
            btn_save = $(".u-btn-save"),            //获取保存按钮
            btn_cancel = $(".u-btn-cancel");        //获取取消按钮
        
        //单击编辑按钮
        btn_edit.on("click",function(){
            var _ts = $(this),
            	categoryId = _ts.closest('li').attr('categoryId'),
                par = _ts.parent(".u-txt"),
                ipt = par.next(".u-ipt"),
                txt = _ts.siblings(".txt"),
                input = ipt.find(".ipt");
            par.hide();
            ipt.show();
            input.focus().val($.trim(txt.text()));

            //单击保存按钮
            btn_save.on("click",function(){
                par.show();
                ipt.hide();
                txt.text($.trim(input.val()));
                $.post('${ctx!}/userCenter/zone/resource/category',{
                	'_method':'PUT',
                	'name':txt.text(),
                	'id':categoryId
                });
            })

            //单击取消按钮
            btn_cancel.on("click",function(){
                par.show();
                ipt.hide();
            });
        })

        //单击删除按钮
        btn_del.on("click",function(){
            var _ts = $(this);
            	categoryId = _ts.closest('li').attr('categoryId'),
		    mylayerFn.confirm({
		        content: "确定删除此类别？",
		        icon: 3,
		        yesFn: function(){
	                $.post('${ctx!}/userCenter/zone/resource/category',{
	                	'_method':'DELETE',
	                	'id':categoryId,
	                	'IS_DELETED':'Y'
	                },function(response){
	                	if(response.responseCode == '00'){
	                		 _ts.closest('li').remove();
	                		 loadContent('resource');
	                	}
	                });
		        }
		    });
        });
    })
</script>