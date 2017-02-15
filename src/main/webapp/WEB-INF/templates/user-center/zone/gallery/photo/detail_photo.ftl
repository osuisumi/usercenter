<#global app_path=PropertiesLoader.get('app.usercenter.path') >
<#import "/common/image.ftl" as image/>
<@photoGalleryPhotoDirective id=id commentRelationId=commentRelationId isGetattitude="Y">
<div class="tp">
	<div class="tp-info">
		<a href="javascript:;" class="fig"> <@image.imageFtl url="${(photo.creator.avatar)!}" default="${app_path}/images/defaultAvatarImg.png" /> </a>
		<p class="info">
			<a href="javascript:;" class="name"><span id="uname"></span></a>的<a href="javascript:;" class="p-name">
				<#if photo.name??>
					${photo.name}
				<#else>
					${(photo.fileInfo.fileName)!}
				</#if>
			</a>
		</p>
		<p class="time">
			${TimeUtils.formatDate(photo.createTime,'yyyy-MM-dd HH:mm')}
		</p>
	</div>
	<div class="detail-opa clearfix">
		<div class="cmnt-opa t-handle">
			<a href="javascript:void(0);" class="comment-opa"> <i class="comment1-ico cmnt-ico"></i> 评论(${commentNum!0}) </a>
			<span class="l">|</span>
			<#if myAttitudeUserMap??>
				<#if myAttitudeUserMap[photo.id]??>
					<a onclick="attitudeCancelSupport('${photo.id}',this)"><i class="au-praise un-praise"></i>取消赞(<span id="sup_num">${supportNum!0}</span>)</a>
				<#else>
				<a href="javascript:void(0);" onclick="attitude_support('${photo.id}','photo',this)" class="share-opa"> <i class="arrows-ico cmnt-ico"></i> 点赞（<span id="sup_num" class="sup_num">${supportNum!0}</span>） </a>
				</#if>
			<#else>
				<a href="javascript:void(0);" onclick="attitude_support('${photo.id}','photo',this)" class="share-opa"> <i class="arrows-ico cmnt-ico"></i> 点赞（<span id="sup_num" class="sup_num">${supportNum!0}</span>） </a>
			</#if>
		</div>
	</div>
</div>
<div class="logTxt-detail ">
	<ul class="detailTxt-comment-list">
		<#if comments??>
			<#list comments as comment>
				<li class="block" type="comment" commentId="${comment.id}">
					<div class="detailText-comment-block">
						<div class="infor">
							<p class="i-text">
								<a href="ta/index.html" class="u-name">${(comment.creator.realName)!}:</a>
								<span class="txt">${(comment.content)!}</span>
							</p>
							<div class="t clearfix">
								<span class="time">昨天 <em>19:36</em></span>
								<a href="javascript:void(0);" class="comment-reply-btn "></a>
							</div>
						</div>
						<div class="detailTxt-comment-reply">
							<#if comment.childComments??>
								<ul class="reply-list">
									<#list comment.childComments as childComment>
										<li type="childComment" commentId = "${childComment.id}">
											<div class="reply-block">
												<div class="r-infor">
													<p class="i-text">
														<a href="ta/index.html" class="u-name">${(childComment.creator.realName)!}</a>
														<span class="l">回复</span>
														<a href="ta/index.html" class="u-name">${(childComment.parentComment.creator.realName)!}</a>
														<span class="txt">${(childComment.content)!}</span>
													</p>
													<div class="t clearfix">
														<span class="time">昨天 <em>19:36</em></span>
														<a href="javascript:void(0);" class="comment-reply-btn"></a>
													</div>
												</div>
											</div>
										</li>
									</#list>
								</ul>
							</#if>
						</div>
					</div>
					<div class="reply-box">
						<div class="textarea-input">
							<textarea  name="" id=""></textarea>
						</div>
						<div class="btn-block clearfix">
							<a href="javascript:void(0);" class="face-btn cmnt-ico"></a>
							<input onclick="saveChildComment(this)"  type="submit" value="回复" class="comment-btn btn">
							<input type="botton" value="取消" class="cancel-btn gray-btn btn">
						</div>
					</div>
				</li>
			</#list>
		</#if>
	</ul>
	<div class="reply-box m-phL-say">
		<div class="textarea-input">
			<textarea name="" id="" placeholder="我也说一句"></textarea>
		</div>
		<div class="btn-block clearfix">
			<a href="javascript:void(0);" class="face-btn cmnt-ico"></a>
			<input type="submit" onclick="saveComment(this)" value="回复" class="comment-btn btn">
			<input type="botton" value="取消" class="cancel-btn gray-btn btn">
		</div>
	</div>

</div>

<script>
	$(function(){
	$('#uname').text($('#realName').val());
    logTxtReply();
    function logTxtReply(){
        var $prt = $(".detailTxt-comment-list");
        var $replyBox = $prt.find(".reply-box");
        $prt.find(".block").each(function(){
            var _ts = $(this);
            _ts.find(".comment-reply-btn").on("click",function(){
            	var parentId = $(this).closest('li').attr('commentId');
            	var mainId = _ts.attr('commentId');
                $prt.find(".reply-box").hide();
                $prt.siblings('.m-phL-say').find("textarea").height(15).val("");
                $prt.siblings('.m-phL-say').find(".btn-block").css("display","none");
                _ts.find(".reply-box").show();
                _ts.find(".reply-box").find(".textarea-input textarea").attr("placeholder","回复" + $(this).parent().parent().find(".u-name").eq(0).text()).focus();
                _ts.find(".reply-box").find(".textarea-input textarea").attr('parentId',parentId).attr('mainId',mainId);
            })
        })
        $replyBox.find(".comment-btn").on("click",function(){
            var _ts = $(this);
            _ts.parents(".reply-box").hide();
        })
        $replyBox.find(".cancel-btn").on("click",function(){
            var _ts = $(this);
            _ts.parents(".reply-box").hide();
        })
        $(".m-phL-say .textarea-input textarea").on("click",function(){
            $prt.find(".reply-box").hide();
            $(this).css({"height":"50px"}).focus().parent().siblings(".btn-block").css({"display":"block"});

        });
        $(".m-phL-say .btn-block .cancel-btn").on("click",function(){
            $(this).parents(".m-phL-say").find("textarea").height(15).val("");
            $(this).parents(".btn-block").css("display","none");

        });
    }
	})
	
	function saveComment(a){
		var textarea = $(a).closest('.reply-box').find('textarea').eq(0);
		if(textarea.val().trim() == ''){
			alert('发表内容不能为空');
			return false;
		}
		
		$.post('${ctx}/comment',{
			"relation.id":"${commentRelationId}",
			"content":$(textarea).val(),
			//"mainId":mainId,
			"relation.type":"photo"
    	},function(response){
    		if(response.responseCode == '00'){
    			alert('发表成功',function(){
    				loadPhotoDetail(photoPreview.nowPhotoId);
    			});
    		}
    	});
	}
	
	function saveChildComment(a){
		var textarea = $(a).closest('.reply-box').find('textarea').eq(0);
		if(textarea.val().trim() == ''){
			alert('发表内容不能为空');
			return false;
		}
		var parentId = textarea.attr('parentId');
		var mainId = textarea.attr('mainId');
		$.post('${ctx}/comment',{
			"relation.id":"${commentRelationId}",
			"content":$(textarea).val(),
			"mainId":mainId,
			"parentId":parentId,
			"relation.type":"photo"
    	},function(response){
    		if(response.responseCode == '00'){
    			alert('发表成功',function(){
    				loadPhotoDetail(photoPreview.nowPhotoId);
    			});
    		}
    	});
	}
	
	function attitude_support(id,type,a,attitude){
		if(!attitude){
			var attitude = 'support';
		}
		$.post("${ctx}/attitudes",{
			"attitude":attitude,
			"relation.id":id,
			"relation.type":type
		},function(response){
			if(response.responseCode == '00'){
				var count = $('#sup_num').text();
				$(a).replaceWith('<a onclick="attitudeCancelSupport(\''+id+'\',this)"><i class="au-praise un-praise"></i>取消赞(<span id="sup_num">'+(parseInt(count)+1)+'</span>)</a>');
			}
		})
	}
	
    function attitudeCancelSupport(id,a){
    	$.post('${ctx}/attitudes',{
    		"_method":'DELETE',
    		"relationId":id,
    		"attitude":'support'
    	},function(response){
    		if(response.responseCode == '00'){
    			var count = $('#sup_num').text();
				$(a).replaceWith('<a href="javascript:void(0);" onclick="attitude_support(\''+id+'\',\'photo\',this)" class="share-opa"> <i class="arrows-ico cmnt-ico"></i> 点赞（<span id="sup_num" class="sup_num">'+(parseInt(count)-1)+'</span>） </a>');
    		}
    	});
    }
</script>
</@photoGalleryPhotoDirective>