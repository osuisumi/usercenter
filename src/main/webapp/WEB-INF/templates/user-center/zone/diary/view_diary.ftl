<#global app_path=PropertiesLoader.get('app.usercenter.path') >
<#import "../../../common/image.ftl" as image/>
<@diaryViewDirective diary=diary op=(op[0])!'' userId=(userId[0])!''>
<dl class="m-dynamic">
    <dt class="m-zone-mod m-all-dynamic">
        <h3 class="u-tit">学习日志</h3>
        <div class="cmnt-tit-r">
            <a class="return" onclick="loadContent('diary')">&lt;返回日志列表</a>
        </div>
    </dt>
    <dd class="m-zone-mod m-person-dynamic">
        <div diaryId="${(diary.id)!}">
            <div id="study-logTxt" class="space-content-page">
                <div class="logTxt-content cmnt-mod">
                    <div class="cmnt-detail">
                        <div class="logTxt-detail">
                            <h2 class="detail-title">${(diary.title)!}</h2>
                            <div class="detail-opa clearfix">
                                <div class="cmnt-opa t-handle">
                                    <a class="comment-opa">
                                        <i class="comment1-ico cmnt-ico"></i>评论
                                    </a>
                                    <#-- <span class="l">|</span>
                                     <a class="share-opa">
                                        <i class="arrows-ico cmnt-ico"></i>分享
                                    </a> -->
                                    <#if (ThreadContext.getUser().getId()) == (diary.creator.id)>
                                    <span class="l">|</span>
                                    <a class="alter-opa">
                                        <i class="pen-ico cmnt-ico"></i>编辑
                                    </a>
                                    </#if>
                                </div>
                                <div class="cmnt-opa pn fr">
                                    <a onclick="viewDiary('${(diary.id)!}', 'createTimeGt')" class="prev " title="日久生情">上一篇 </a>
                                    <span class="l">|</span>
                                    <a onclick="viewDiary('${(diary.id)!}', 'createTimeLt')" class="next" title="三个故事">下一篇</a>
                                </div>
                            </div>
                            <div class="detail-text-cont">
                            ${(diary.content)!}
                            </div>
                            <div class="detail-opa clearfix">
                                <div class="cmnt-opa t-handle">
                                    <a class="comment-opa">
                                        <i class="comment1-ico cmnt-ico"></i>评论
                                    </a>
                                   <#-- <span class="l">|</span>
                                     <a class="share-opa">
                                        <i class="arrows-ico cmnt-ico"></i>分享
                                    </a> -->
                                    <#if (ThreadContext.getUser().getId()) == (diary.creator.id)>
                                    <span class="l">|</span>
                                    <a class="alter-opa">
                                        <i class="pen-ico cmnt-ico"></i>编辑
                                    </a>
                                    </#if>
                                </div>
                                <div class="cmnt-opa pn fr">
                                	<a onclick="viewDiary('${(diary.id)!}', 'createTimeGt')" class="prev " title="日久生情">上一篇 </a>
                                    <span class="l">|</span>
                                    <a onclick="viewDiary('${(diary.id)!}', 'createTimeLt')" class="next" title="三个故事">下一篇</a>
                                </div>
                            </div>
                            <div class="detail-txt-comment">
                                <div class="t-tit">
                                    <div class="block">评论</div>
                                </div>
                                <div class="detailTxt-comment-wrap">
                                    <div id="listDiaryCommentDiv"></div>
                                    <form id="diaryCommentForm" method="post" action="${ctx!}/comment">
                                        <input type="hidden" name="_method" value="POST">
                                    	<input type="hidden" name="creator.id" value="${(Session.loginer.id)!}">
                                    	<input type="hidden" name="relation.id" value="${(diary.id)!}">
                                    	<input type="hidden" name="relation.type" value="zoneDiary">
	                                    <div class="detailTxt-comment-box">
	                                        <div class="img">
	                                        	<a><@image.imageFtl url="${(ThreadContext.getUser().avatar)!}" default="/ncts/images/defaultAvatarImg.png" /></a>
	                                        </div>
	                                        <div class="conts">
	                                            <div class="b">
	                                                <a class="face-btn cmnt-ico"></a>
	                                            </div>
	                                            <div class="textarea-input">
	                                                <textarea name="content" placeholder="我也说一句..."></textarea>
	                                            </div>
	                                            <div class="btn-block clearfix">
	                                                <input onclick="saveComment()" type="button" value="发表" class="comment-btn btn">
	                                            </div>
	                                        </div>
	                                    </div>
                                    </form>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </dd>  
</dl> 
</@diaryViewDirective>
<script>
	$(function(){		
		listDiaryCommentDiv();
		
		//评论
		$(".comment-opa").on("click",function(){   
			$('.comment-opa').animate(0,1000);
			$('#diaryCommentForm textarea[name="content"]').focus();
	    });
	    
	    //编辑
		$(".alter-opa").on("click",function(){   
	        mylayerFn.open({
		        type: 2,
		        title: '编辑日志',
		        fix: false,
		        area: [900, 800],
		        content: '${ctx!}/userCenter/zone/diary/'+$(this).closest('[diaryId]').attr('diaryId')+'/edit',
		        shadeClose: true,
		        offset:[$(document).scrollTop()]
	    	});
	    });
	    
	});

	function listDiaryCommentDiv(){
		$('#listDiaryCommentDiv').load('${ctx!}/userCenter/zone/diary/comment','relationId=${(diary.id)!}&page=${(pageBounds.page)!1}&limit=${(pageBounds.limit)!10}&orders=${(param_orders)!"CREATE_TIME.DESC"}');
	};
	
	function viewDiary(id, op){
		$('#zoneContent').load('${ctx!}/userCenter/zone/diary/${(diary.id)!}/view?op=' + op + '&userId=${(userId[0])!}' );
	};

	function logTxtReply(){
	    var $prt = $(".detailTxt-comment-list");
	    var $replyBox = $prt.find(".reply-box");
	    $prt.find(".block").each(function(){
	        var _ts = $(this);
	        _ts.find(".comment-reply-btn").on("click",function(){
	            $prt.find(".reply-box").hide();
	            _ts.find(".reply-box").show();
	            _ts.find(".reply-box").find(".textarea-input textarea").attr("placeholder","回复" + $(this).parent().parent().find(".u-name").eq(0).text()).focus();
	            _ts.find('.comment-btn.btn').attr('parentId',$(this).closest('li').attr('commentId'));
	            _ts.find('.comment-btn.btn').attr('mainId',$(this).closest('li').attr('mainId'));
	        })
	    })
	    
	    $replyBox.find(".comment-btn").on("click",function(){
	    	var _ts = $(this);	    	
	   		if(_ts.parents('.reply-box').css('display') == 'block'){
		       	if(_ts.parents(".reply-box").find("textarea").val().trim() == ''){
		    		alert('发表内容不能为空');
		    		return false;
		    	}
		        $.post('${ctx!}/comment',{
		        	'_method':'POST',
		        	'creator.id':'${(Session.loginer.id)!}',
		        	'relation.id':'${(diary.id)!}',
		        	'relation.type':'zoneDiary',
		        	'content':_ts.parents(".reply-box").find("textarea").val(),
		        	'mainId':$(this).attr('mainId'),
		        	'parentId':$(this).attr('parentId')
		        },function(response){
		        	if(response.responseCode == '00'){
			        	alert('回复成功!');
			        	var page = $('#listDiaryCommentForm input[name="page"]').val();
			        	var limit = $('#listDiaryCommentForm input[name="limit"]').val();
			        	var orders = $('#listDiaryCommentForm input[name="orders"]').val();
			        	$('#listDiaryCommentDiv').load('${ctx!}/userCenter/zone/diary/comment?relationId=${(diary.id)!}&page='+page+'&limit='+limit+'&orders='+orders);
		        	}else{
		        		alert('回复失败!');
		        	}
		        });
		        _ts.parents(".reply-box").hide();
	   		}
	    })
	    
	    $replyBox.find(".cancel-btn").on("click",function(){
	        var _ts = $(this);
	        _ts.parents(".reply-box").find("textarea").val('');
	        _ts.parents(".reply-box").hide();
	    })
	};

	//保存评论
	function saveComment(){
	   	if($('#diaryCommentForm textarea[name="content"]').val().trim() == ''){
	    		alert('发表内容不能为空');
	    		return false;
	    }
		$.ajaxSubmit('diaryCommentForm');
		$('#zoneContent').load('${ctx!}/userCenter/zone/diary/${(diary.id)!}/view');
	};
	
	//删除评论
	function deleteComment(id){
		$.ajaxDelete('${ctx!}/comment/'+id,'',function(response){
			if(response.responseCode == '00'){
				var floorNum = $('li[commentId='+id+']').find('.floor ii').text();
				$('li[commentId='+id+']').remove();
				//评论楼层数对应减1
				if(parseInt(floorNum) >= 1 ){
					$('.floor ii').each(function(){
						if(parseInt($(this).text()) > parseInt(floorNum)){
							$(this).text(parseInt($(this).text())-1);
						}
					});
				}
				alert('删除成功!');
	    	}else{
	    		alert('删除失败!');
	    	}
		});
	};
</script>  