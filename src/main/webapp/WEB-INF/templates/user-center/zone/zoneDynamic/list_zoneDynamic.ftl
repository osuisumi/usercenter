<#global app_path=PropertiesLoader.get('app.usercenter.path') >
<#import "/common/image.ftl" as image/>
<dl class="m-dynamic">
	<dt class="m-zone-mod m-all-dynamic">
		全部动态 <i onclick="window.location.reload();" class="u-all-dynamic-con"></i>
	</dt>
	<@zoneDynamicsDirective userId=userId pageBounds=pageBounds>
	<#if zoneDynamics?? && (zoneDynamics?size >0)>
	<#list zoneDynamics as zoneDynamic>
		<dd class="m-zone-mod m-person-dynamic" id="${zoneDynamic.id}">
			<div class="m-person-txt">
				<h3 class="m-person-tl"><span class="m-person-tl-who">${(zoneDynamic.creator.realName)!}</span>
					<p class="m-person-tl-time">
						<!--<i></i>
						<a href="javascript:;">浏览(${(zoneDynamic.browseNum)!})</a>-->
						<span>${TimeUtils.formatDate(zoneDynamic.createTime,'yyyy年MM月dd日 HH:mm')}</span>
					</p>
				</h3>
				<#if zoneDynamic.dynamicSourceType == "schedule">
					<p class="m-person-descr">
						添加了${zoneDynamic.dynamicSourceEntity?size}条计划
						<#list zoneDynamic.dynamicSourceEntity as schedule>
							<a href="<#if schedule.url??>${ctx}${schedule.url}<#else>javascript:;</#if>">“${TimeUtils.formatDate(schedule.scheduleRelation.timePeriod.startTime,'yyyy-MM-dd')}参与 ${(schedule.title)!}”</a>
						</#list>
					</p>
				<#elseif zoneDynamic.dynamicSourceType == "galleryPhoto">
					<p class="m-person-descr">上传了${zoneDynamic.dynamicSourceEntity?size}张照片到相册：
						<@photoGalleryDirective id=zoneDynamic.dynamicSourceRelation.id>
							<a onclick="viewGalleryPhoto('${zoneDynamic.dynamicSourceRelation.id}','${(photoGallery.photoNumber)!}')" href="javascript:;">
								${(photoGallery.name)!}
							</a>
						</@photoGalleryDirective>
					</p>
				<#elseif zoneDynamic.dynamicSourceType == 'diary'>
					<h4 class="m-person-subhead"><a href="javascript:;">${(zoneDynamic.dynamicSourceEntity.title)!}</a></h4>
					<p class="m-person-descr-txt">${(zoneDynamic.dynamicSourceEntity.content)!}<a href="javascript:;">&lt;展开全文&gt;</a></p>
				<#elseif zoneDynamic.dynamicSourceType == 'resource'>
                    <p class="m-person-descr">分享资源：<a>${(zoneDynamic.dynamicSourceEntity.title)!}</a></p>
				</#if>
			</div>
			<#if zoneDynamic.dynamicSourceType == 'resource'>
	        	<div class="m-user-share">
	                <div class="m-user-share-pic ${FileTypeUtils.getFileTypeClass((zoneDynamic.dynamicSourceEntity.fileInfos[0].fileName)!, 'suffix') }"></div>
	                <p class="m-user-share-loading">
	                    <a onclick="downloadFile('${(zoneDynamic.dynamicSourceEntity.fileInfos[0].id)!}','${(zoneDynamic.dynamicSourceEntity.fileInfos[0].fileName)!}')" class="load">下载</a>
	                    <!-- <span class="see">|</span>
	                    <a class="line">预览</a>
	                    -->
	                </p>
	            </div> 
			</#if>
			<div class="m-person-com">
				<div class="user-comment">
					<a href="javascript:;" class="u-user-com-cl"><i class="au-comment"></i>评论(${(zoneDynamic.replyNum)!})</a>
					<i class="line">|</i>
						<!--我的点赞情况-->
						<#if myAttitudeUserMap??>
							<#if myAttitudeUserMap[zoneDynamic.id]??>
								<a onclick="attitudeCancelSupport('${zoneDynamic.id}',this)"><i class="au-praise un-praise"></i>取消赞(<span id="supportNum_${zoneDynamic.id}">${(zoneDynamic.supportNum)!}</span>)</a>
							<#else>
							<a onclick="attitudeSupport('${zoneDynamic.id}',this)"><i class="au-praise "></i>赞(<span id="supportNum_${zoneDynamic.id}">${(zoneDynamic.supportNum)!}</span>)</a>
							</#if>
						<#else>
						<a onclick="attitudeSupport('${zoneDynamic.id}',this)"><i class="au-praise un-praise"></i>赞(<span id="supportNum_${zoneDynamic.id}">${(zoneDynamic.supportNum)!}</span>)</a>
						</#if>
					<i class="line">|</i>
					<!--<a href="javascript:;"><i class="au-retransmit"></i>转发(1584)</a>-->
					<#if ThreadContext.getUser().getId() == zoneDynamic.creator.id>
						<i class="line">|</i>
						<a onclick="deleteDynamic(this)" class="delete"><i class="au-delete"></i>删除</a>
					</#if>
				</div>
				<div class="user-visitor">
					<i><ins></ins></i>
					<#if attitudeUserMap??>
						<#if attitudeUserMap[zoneDynamic.id]??>
							<#list attitudeUserMap[zoneDynamic.id] as au>
								<a href="javascript:;" creator="${(au.creator.id)!}"> 
									<@image.imageFtl url="${(au.creator.avatar)! }" default="${app_path}/images/defaultAvatarImg.png" />
								</a>
							</#list>
						</#if>
					</#if>
					<a href="javascript:;" class="u-more">更多</a>
				</div>
				<#if zoneDynamic.dynamicSourceType == "galleryPhoto">
					<div class="m-user-sharePhoto">
						<input type="hidden" class="galleryId" value="${zoneDynamic.dynamicSourceRelation.id}">
						<#if zoneDynamic.dynamicSourceEntity??>
						<input type="hidden" class="photoIds" value="<#list zoneDynamic.dynamicSourceEntity as p>${p.id},</#list>" />
						<input type="hidden" class="total" value="${zoneDynamic.dynamicSourceEntity?size}">
							<#assign size = (zoneDynamic.dynamicSourceEntity?size -1)/>
	                        <ul >
	                        	<#if (0 <= size)>
	                        		<li><a href="javascript:;"><img photoId="${zoneDynamic.dynamicSourceEntity[0].id}" src="${FileUtils.getFileUrl(zoneDynamic.dynamicSourceEntity[0].fileInfo.url)}" alt="" /></a></li>
	                        	</#if>
	                        	<#if (1 <= size)>
	                        		<li><a href="javascript:;"><img photoId="${zoneDynamic.dynamicSourceEntity[1].id}" src="${FileUtils.getFileUrl(zoneDynamic.dynamicSourceEntity[1].fileInfo.url)}" alt="" /></a></li>
	                        	</#if>
	                        	<#if (2 <= size)>
	                        		<li><a href="javascript:;"><img photoId="${zoneDynamic.dynamicSourceEntity[2].id}" src="${FileUtils.getFileUrl(zoneDynamic.dynamicSourceEntity[2].fileInfo.url)}" alt="" /></a></li>
	                        	</#if>
	                        </ul>
	                        <ul >
	                        	<#if (3 <= size)>
	                        		<li><a href="javascript:;"><img photoId="${zoneDynamic.dynamicSourceEntity[3].id}" src="${FileUtils.getFileUrl(zoneDynamic.dynamicSourceEntity[3].fileInfo.url)}" alt="" /></a></li>
	                        	</#if>
	                        	<#if (4 <= size)>
	                        		<li><a href="javascript:;"><img photoId="${zoneDynamic.dynamicSourceEntity[4].id}" src="${FileUtils.getFileUrl(zoneDynamic.dynamicSourceEntity[4].fileInfo.url)}" alt="" /></a></li>
	                        	</#if>
	                        	<#if (5 <= size)>
	                        		<li><a href="javascript:;"><img photoId="${zoneDynamic.dynamicSourceEntity[5].id}" src="${FileUtils.getFileUrl(zoneDynamic.dynamicSourceEntity[5].fileInfo.url)}" alt="" /></a></li>
	                        	</#if>
	                        </ul>
	                        <ul >
	                        	<#if (6 <= size)>
	                        		<li><a href="javascript:;"><img photoId="${zoneDynamic.dynamicSourceEntity[6].id}" src="${FileUtils.getFileUrl(zoneDynamic.dynamicSourceEntity[6].fileInfo.url)}" alt="" /></a></li>
	                        	</#if>
	                        	<#if (7 <= size)>
	                        		<li><a href="javascript:;"><img photoId="${zoneDynamic.dynamicSourceEntity[7].id}" src="${FileUtils.getFileUrl(zoneDynamic.dynamicSourceEntity[7].fileInfo.url)}" alt="" /></a></li>
	                        	</#if>
	                        	<#if (8 <= size)>
	                        		<li><a href="javascript:;"><img photoId="${zoneDynamic.dynamicSourceEntity[8].id}" src="${FileUtils.getFileUrl(zoneDynamic.dynamicSourceEntity[8].fileInfo.url)}" alt="" /></a></li>
	                        	</#if>
	                        </ul>
                        </#if>                                        
                    </div>
				</#if>
				<div class="user-reply">
					<#if commentsMap??>
						<#if commentsMap[zoneDynamic.id]??>
							<#list commentsMap[zoneDynamic.id] as comment>
								<div class="pr-user-reply" id="${comment.id}">
									<a href="javascript:;"> <@image.imageFtl url="${(comment.creator.avatar)! }" default="${app_path}/images/defaultAvatarImg.png" userId=comment.creator.id userName=comment.creator.realName /> </a>
									<p>
										<i class="commentCreatorName">${(comment.creator.realName)!}</i><span>:</span>${(comment.content)!}
									</p>
									<p class="u-reply-time">
										${TimeUtils.prettyTime(comment.createTime)} <ins class="u-user-com-cl" onclick="replyUser(this)"></ins>
										<#if ThreadContext.getUser().getId() == comment.creator.id>
											<i onclick="deleteReply('${comment.id}',this)" class="u-reply-del">x</i>
										</#if>
									</p>
								</div>
								<ul class="other-user-reply">
									<#if comment.childComments??>
										<#list comment.childComments as childComment>
											<li class="pr-user-reply" id="${childComment.id}">
												<a href="javascript:;"> <@image.imageFtl url="${(childComment.creator.avatar)! }" default="${app_path}/images/defaultAvatarImg.png" userId=childComment.creator.id userName=childComment.creator.realName /> </a>
												<p>
													<i class="commentCreatorName">${(childComment.creator.realName)!}</i><span>:</span>${(childComment.content)!}
												</p>
												<p class="u-reply-time">
													${TimeUtils.prettyTime(childComment.createTime)} <ins onclick="replyChildUser(this)" class="u-user-com-cl"></ins>
													<#if ThreadContext.getUser().getId() == comment.creator.id>
														<i onclick="deleteReply('${childComment.id}',this)" class="u-reply-del">x</i>
													</#if>
												</p>
											</li>
										</#list>
									</#if>
								</ul>
							</#list>
						</#if>
					</#if>
				</div>
				<div class="m-dis-det-spok">
					<div class="am-comment-box am-ipt-mod">
						<label> 
							<textarea  class="au-textarea " placeholder="我也来说一句"></textarea>
						</label>
						<div class="am-cmtBtn-block f-cb">
							<a onclick="saveComment(this)" href="javascript:void(0);" class="au-cmtPublish-btn au-confirm-btn1">发表</a>
						</div>
					</div>
				</div>
			</div>
		</dd>
	</#list>
	<#else>
	<div class="m-zone-mod">
		<div class="g-no-notice-Con">
        	<p class="txt">暂时没有数据！</p>
    	</div>
    </div>
	</#if>
	<form id="listZoneDynamicForm" action="${ctx}/userCenter/zone/zoneDynamic">
		<input type="hidden" value="${limit!}" name="limit">
		<input type="hidden" name="userId" value="${userId}">
		<#if paginator??>
			<#import "../../../common/pagination_ajax.ftl" as p/>
			<@p.paginationAjaxFtl formId="listZoneDynamicForm" divId="zoneDynamicPage" paginator=paginator contentId="zoneContent"/>
		</#if>
	</form>
	<div id="zoneDynamicPage" class="m-laypage"></div>
	</@zoneDynamicsDirective>
</dl>

<div id="detailList">
</div>

<div style="display:none">
	<div class="pr-user-reply" id="replyModel">
		<a href="javascript:;"> <@image.imageFtl url="${(ThreadContext.getUser().getAvatar())!''}" default="${app_path}/images/defaultAvatarImg.png" /> </a>
		<p>
			<i class="commentCreatorName">${ThreadContext.getUser().getRealName()}</i><span>:</span>
		</p>
		<p class="u-reply-time">
			片刻之前 <ins class="u-user-com-cl" onclick="replyUser(this)"></ins>
				<i class="u-reply-del">x</i>
		</p>
	</div>
	
	<li id="childReplyModel" class="pr-user-reply">
		<a href="javascript:;"> <@image.imageFtl url="${(ThreadContext.getUser().getAvatar())!''}" default="${app_path}/images/defaultAvatarImg.png" /> </a>
		<p>
			<i class="commentCreatorName">${ThreadContext.getUser().getRealName()}</i><span>:</span>
		</p>
		<p class="u-reply-time">
			片刻之前 <ins onclick="replyChildUser(this)" class="u-user-com-cl"></ins>
		</p>
	</li>
	
	<a id="supportModel" href="javascript:;" creator="${(ThreadContext.getUser().getId())!}"> 
		<@image.imageFtl url="${(ThreadContext.getUser().getAvatar())!'' }" default="${app_path}/images/defaultAvatarImg.png" />
	</a>
</div>
<script>
	$(function(){
		$(".pr-user-reply a img").showUserInfor();
	})

	$(function(){
	    //点击图片弹出预览列表
	    $(".m-user-sharePhoto").on('click','img',function(){
	    	$this = $(this);
        	var galleryId = $(this).closest('.m-user-sharePhoto').find('.galleryId').eq(0).val();
        	var photoIds = $(this).closest('.m-user-sharePhoto').find('.photoIds').eq(0).val();  
        	$('#detailList').load('${ctx}/userCenter/zone/gallery/photo/detailList/'+galleryId+'?photoIds='+photoIds+'&page=1',function(){
		        var $Pli = $this.parents("li");
		        var indexs = $this.closest('.m-user-sharePhoto').find('li').index($Pli);
            	photoPreview.init(indexs,$this.closest('.m-user-sharePhoto').find('.total').eq(0).val()); 
        	});
		});
	})

	$(function(){
		changeZoneItem('zoneDynamic');
		usercommentfocus();
	})

	 function usercommentfocus(){ //点击评论框获取焦点
        $(".m-person-dynamic").each(function(index,element){
            $(this).addClass(""+index+"");
        });

        $(".m-person-dynamic").on("click",".u-user-com-cl,.au-textarea",function(){
            var $userParent = $(this).parents(".m-person-dynamic"),
                $otherComm = $userParent.siblings('.m-person-dynamic').find(".au-textarea"),
                $textarea = $(".au-textarea"),
                $usrerComm = $userParent.find(".au-textarea");
            // $usrerComm.focus();
            // $otherComm.blur();
            $usrerComm.addClass('bigarea');
            var big_val = $('.bigarea').val();
            
            var val_one = $(".0").find(".au-textarea").val(),
                val_tw = $(".1").find(".au-textarea").val()||"",
                val_th = $(".2").find(".au-textarea").val()||"",
                val_fou = $(".3").find(".au-textarea").val()||"",
                val_fin = $(".4").find(".au-textarea").val()||"";
           
                if(val_one==""&&val_tw==""&&val_th==""&&val_fou==""&&val_fin==""){
                    // alert($(this).val())
                     $('.bigarea').stop().animate({height : "76px"
                        },200,function(){
                            $(this).parent().siblings('.am-cmtBtn-block').show();
                        }).focus(); 
                    $otherComm.stop().animate({height : "22px"
                            },200,function(){
                            $(this).parent().siblings('.am-cmtBtn-block').hide();
                            resetTextarea(this);
                        });
                    // alert($usrerComm.attr("class"))
                    $usrerComm.removeClass('bigarea');              
                }else{
                    $textarea.each(function(){
                        if(!$(this).val()==""){
                            $(this).addClass('in')
                        }
                    });
                    var hasComm = confirm('您正在发表，是否关闭该条发表？',function(){
	                  $('.in').stop().animate({height : "22px"
                            },200,function(){
                                $(this).parent().siblings('.am-cmtBtn-block').hide();
                                resetTextarea(this);
                            }).val("");      
                        $('.bigarea').stop().animate({height : "76px"
                                },200,function(){
                                $(this).parent().siblings('.am-cmtBtn-block').show();
                            }).focus();
                        $usrerComm.removeClass('bigarea');
                        $textarea.removeClass('in') 
                    },function(){
                        $('.in').stop().animate({height : "76px"
                            },200,function(){
                                $(this).parent().siblings('.am-cmtBtn-block').show();
                            }).focus();      
                        $('.bigarea').stop().animate({height : "22px"
                                },200,function(){
                                $(this).parent().siblings('.am-cmtBtn-block').hide();
                               // resetTextarea(this);
                            }).blur();
                        $usrerComm.removeClass('bigarea');  
                        $textarea.removeClass('in')  
                    });
                         
                }


        });


    };

    function del_replay(){
        $(".u-reply-del").on("click",function(){
            var $replay_pa = $(this).parents(".pr-user-reply"),
                $replay_sib = $replay_pa.siblings('.other-user-reply');
                $replay_pa.remove();
                $replay_sib.remove();
        });
    }
    
    
    function saveComment(a){
    	var dd = $(a).closest('dd');
    	var textArea = $(dd).find("textarea").eq(0);
    	if(textArea.val().trim() == ''){
    		alert('发表内容不能为空');
    		return false;
    	}
    	var relationId = $(dd).attr('id');
    	var content = '';
    	var mainId = '';
    	var parentId = $(textArea).attr('parentId')||'';
    	//当textarea中有mainId时为子回复
    	if(textArea.attr('mainId')){
    		content = $(textArea).attr('placeholder') + ':' + $(textArea).val();
    		mainId = textArea.attr('mainId');
    	}else{
    		content = $(textArea).val();
    	}
    	$.post('${ctx}/comment',{
    		"relation.id":relationId,
    		"content":$(textArea).val(),
    		"mainId":mainId,
    		"parentId":parentId,
    		"relation.type":"dynamic"
    	},function(response){
    		if(response.responseCode == '00'){
    			alert('发表成功');
    			if(textArea.attr('mainId')){
    				appendChildReply(textArea,response);
    			}else{
    				appendReply(textArea,response);
    			}
    			//重置textarea
    			$(textArea).removeAttr('mainId');
    			$(textArea).attr('placeholder','我也来说一句');
    			$(textArea).val('');
    		}
    	});
    }
    
    function replyUser(a){
    	var commentCreatorName = $(a).closest('.pr-user-reply').find('.commentCreatorName').text();
    	var mainId = $(a).closest('.pr-user-reply').attr('id');
    	var textarea = $(a).closest('dd').find('textarea');
    	textarea.attr('placeholder','回复	'+commentCreatorName);
    	textarea.attr('mainId',mainId);
    	textarea.attr('parentId',mainId);
    }
    
    function replyChildUser(a){
    	var commentCreatorName = $(a).closest('.pr-user-reply').find('.commentCreatorName').text();
    	var mainId = $(a).closest('ul').prev('.pr-user-reply').attr('id');
    	var textarea = $(a).closest('dd').find('textarea');
    	textarea.attr('placeholder','回复	'+commentCreatorName);
    	textarea.attr('mainId',mainId);
    	textarea.attr('parentId',$(a).closest('li').attr('id'));
    }
    
    function appendReply(textarea,response){
    	var appendDiv = $('#replyModel').clone();
    	var dd = $(textarea).closest('dd');
    	var replyDiv = dd.find('.user-reply').eq(0);
    	var content = $(textarea).val();
    	//设置内容
    	appendDiv.find('p').eq(0).append(content);
    	appendDiv.attr('id',response.responseData.id);
    	replyDiv.append(appendDiv);
    	$('#'+response.responseData.id).after('<ul class="other-user-reply"></ul>');
    }
    
    function appendChildReply(textarea,response){
    	var appendDiv = $('#childReplyModel').clone();
    	appendDiv.attr('id',response.responseData.id);
    	var mainId = $(textarea).attr('mainId');
    	var dd = $(textarea).closest('dd');
    	var replyDiv = dd.find('.user-reply').eq(0);
    	var content = $(textarea).val();
    	appendDiv.find('p').eq(0).append(content);
    	$('#'+mainId).next('ul').append(appendDiv);
    }
    
    function deleteDynamic(a){
    	var dynamicId = $(a).closest('dd').attr('id');
    	confirm("确定要删除该动态吗？",function(){
    		$.post('${ctx}/userCenter/zone/zoneDynamic',{
    			"_method":"DELETE",
    			"id":dynamicId
    		},function(response){
    			if(response.responseCode == '00'){
    				alert("删除成功",function(){
    					$(a).closest('dd').remove();
    				});
    			}
    		});
    	});
    }
    
	function attitudeSupport(zoneDynamicId,a){
			$.post("${ctx}/attitudes",{
				"attitude":"support",
				"relation.id":zoneDynamicId,
				"relation.type":"zoneDynamic"
			},function(response){
				if(response.responseCode == '00'){
					var count = $('#supportNum_'+zoneDynamicId).text();
					//$('#supportNum_'+zoneDynamicId).text(parseInt(count) + 1);
					alert('点赞成功');
					$(a).replaceWith('<a onclick="attitudeCancelSupport(\''+zoneDynamicId+'\',this)"><i class="au-praise un-praise"></i>取消赞(<span id="supportNum_'+zoneDynamicId+'">'+(parseInt(count)+1)+'</span>)</a>');
					//添加到赞列表
					appendSupportUser(zoneDynamicId,a);
				}else{
					alert('已经赞过');
				}
			});
	}
	
	function appendSupportUser(zoneDynamicId,a){
		var dd = $('#'+zoneDynamicId);
		var prepareAdd = $('#supportModel').clone();
		prepareAdd.removeAttr('id');
		var moreDiv = $(dd).find('.u-more').eq(0);
		console.log(moreDiv);
		prepareAdd.insertBefore(moreDiv);
	}
	
    function attitudeCancelSupport(id,a){
    	$.post('${ctx}/attitudes',{
    		"_method":'DELETE',
    		"relationId":id,
    		"attitude":'support'
    	},function(response){
    		if(response.responseCode == '00'){
    			alert('取消成功');
    			var count = $('#supportNum_'+id).text();
				$(a).replaceWith('<a onclick="attitudeSupport(\''+id+'\',this)"><i class="au-praise un-praise"></i>赞(<span id="supportNum_'+id+'">'+(parseInt(count)-1)+'</span>)</a>');
				removeSupportUser(id,a);
    		}
    	});
    }
    
    function removeSupportUser(id,a){
    	var dd = $('#'+id);
    	dd.find('.user-visitor').find('a[creator=${ThreadContext.getUser().getId()}]').remove();
    
    }
    
    
    function resetTextarea(a){
    	$.each($(a),function(i,n){
			$(n).attr('placeholder','我也来说一句').removeAttr('mainId').removeAttr('parentId');
    	})
    }
    
    function deleteReply(id,a){
    	confirm('确定删除该评论？',function(){
    		$.post('${ctx}/comment/'+id,{
    			"_method":"DELETE"
    		},function(response){
    			if(response.responseCode == '00'){
    				alert('删除成功',function(){
			            var $replay_pa = $(a).parents(".pr-user-reply"),
		                $replay_sib = $replay_pa.next('.other-user-reply').eq(0).remove();
		                $replay_pa.remove();
		                $replay_sib.remove();
    				});
    			}
    		});
    	});
    }
    
    function viewGalleryPhoto(galleryId,total){
    	$('#detailList').load('${ctx}/userCenter/zone/gallery/photo/detailList/'+galleryId,function(){
	    	photoPreview.init(0,total); 
		});
    }
    
</script>
