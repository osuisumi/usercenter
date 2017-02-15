<#global app_path=PropertiesLoader.get('app.usercenter.path') >
<#import "../../../common/image.ftl" as image/>

<@commentsDirective relationId=(param_relationId)! page=(pageBounds.page)!1 limit=(pageBounds.limit)!10 orders=(param_orders)!'CREATE_TIME.DESC'>
	<#if (comments?size > 0)>
		<ul class="detailTxt-comment-list">
			<#list comments as comment>
		   		<li class="block mainCommentLi" commentId="${(comment.id)!}" mainId="${(comment.id)!}">
		    		<div class="detailText-comment-block">
		            	<div class="img">
		                	<a><@image.imageFtl url="${(comment.creator.avatar)!}" default="${(app_path)!}/images/defaultAvatarImg.png" /></a>
		            	</div>
		            	<div class="infor">
		                	<div class="t clearfix">
		                    	<strong class="floor"><ii>${((comment_index+1)+(((pageBounds.page)-1)*(pageBounds.limit)))!1}</ii>楼</strong>
		                    	<span class="time">评论时间: <em>${TimeUtils.formatDate(comment.createTime,'yyyy-MM-dd HH:mm:ss')}</em></span>
		                    	<#if (ThreadContext.getUser().getId()) == (comment.creator.id)>
		                     		<a class="comment-delete-btn" onclick="deleteComment('${(comment.id)!}')">删除</a>
		                    	</#if>
		                    	<a class="comment-reply-btn" onclick="logTxtReply();">回复</a>
		                	</div>
		                	<p class="i-text">
		                    	<a onclick="goUserCenter(this)" ctx="${ctx!}" userId="${(comment.creator.id)!}" class="u-name">${(comment.creator.realName)!}:</a>
		                    	<span class="txt">${(comment.content)!}</span>
		                	</p>
		             	</div>
		             	<div class="detailTxt-comment-reply">
			             	<ul class="reply-list">
		               		</ul>
	       				</div>
	       			</div>
			         <div class="reply-box">
			             <div class="textarea-input">
			                 <textarea></textarea>
			             </div>
			             <div class="btn-block clearfix">
			                 <#-- <a class="face-btn cmnt-ico"></a> -->
			                 <input type="botton" value="回复" class="comment-btn btn" parentId="" mainId="">
			                 <input type="botton" value="取消" class="cancel-btn gray-btn btn">
			             </div>
			         </div>
		   		</li>
	 		</#list>
		</ul>
		<form id="listDiaryCommentForm" action="${ctx!}/userCenter/zone/diary/comment">
	    	<input type="hidden" name="relationId" value="${(param_relationId)!}">
    		<input type="hidden" name="limit" value="${(pageBounds.limit)!10}">
    		<input type="hidden" name="orders" value="${(param_orders)!'CREATE_TIME.DESC'}">
	    	<div id="listDiaryCommentPage" class="m-laypage"></div>
	    	<#import "../../../common/pagination_ajax.ftl" as p/>
			<@p.paginationAjaxFtl formId="listDiaryCommentForm" divId="listDiaryCommentPage" paginator=paginator contentId="listDiaryCommentDiv"/>
		</form>
	<#else>
		<div class="g-no-notice-Con admin">
	        <p class="txt">暂时没有评论！</p>
	    </div>
	</#if>
	
	<li mainId="" parentId="" commentId="" id="replyLiTemplet" style="display:none;">
	 	<div class="reply-block">
	     	<div class="r-img">
	         	<a><img alt="" src="${(app_path)!}/images/defaultAvatarImg.png"></a>
	     	</div>
	     	<div class="r-infor">
	         	<p class="i-text">
	             	<a onclick="goUserCenter(this)" ctx="${ctx!}" userId="" class="u-name"></a>
	              	<span class="l">回复</span>
	             	<a onclick="goUserCenter(this)" ctx="${ctx!}" userId="" class="u-name"></a>
	             	<span class="txt"></span>
	         	</p>
	         	<div class="t clearfix">
	             	<span class="time"><em></em></span>
	             	<a class="comment-delete-btn">删除</a>
	               	<a class="comment-reply-btn" onclick="logTxtReply();">回复</a>
	           	</div>
	       	</div>
	   	</div>
	</li>
	
	<script>
		$(function(){
			//加载子回复
			$('.mainCommentLi').each(function(){
				var _this = $(this);
				var mainCommentId = _this.attr('commentId');
				var _thisReplyUl = _this.find('.reply-list');
				$.ajax({
					url: '${ctx!}/comment/api',
					type: 'GET',
					data: 'orders=CREATE_TIME.DESC&limit=99999'+'&paramMap[mainId]='+mainCommentId,
					success: function(data){
						$.each(data,function(i,c){
							var replyLiTemplet = $('#replyLiTemplet').clone();
							replyLiTemplet.show();
							replyLiTemplet.attr('mainId',mainCommentId);
							replyLiTemplet.attr('commentId',c.id);
							replyLiTemplet.attr('id',c.id);
							if(c.creator.avatar == '' || c.creator.avatar == null || c.creator.avatar == undefined){
								c.creator.avatar = '${(app_path)!}/images/tpdpor/es/defaultAvatar.jpg';
							}
							replyLiTemplet.find('img').attr('src',c.creator.avatar);
							replyLiTemplet.find('.u-name:eq(0)').text(c.creator.realName);
							replyLiTemplet.find('.u-name:eq(0)').attr('userId',c.creator.id);
							
							if(c.parentComment != null && c.parentComment != undefined){								
								replyLiTemplet.find('.u-name:eq(1)').text(c.parentComment.creator.realName);
								replyLiTemplet.find('.u-name:eq(1)').attr('userId',c.parentComment.creator.id);
							}else{
								replyLiTemplet.find('.u-name:eq(1)').text(c.creator.realName);
								replyLiTemplet.find('.u-name:eq(1)').attr('userId',c.creator.id);
							}
							replyLiTemplet.find('.txt').text(c.content);
							replyLiTemplet.find('.comment-delete-btn').attr('onclick','deleteComment("'+c.id+'");');
							var createTime = new Date(c.createTime);
							replyLiTemplet.find('.time em').text(createTime.format('yyyy-MM-dd hh:mm:ss'));
							_thisReplyUl.append(replyLiTemplet);
			        	});
					}
				});
			})
		});
		
		//日期格式化
		Date.prototype.format = function(format){
			var o = {
			"M+" : this.getMonth()+1, //month
			"d+" : this.getDate(), //day
			"h+" : this.getHours(), //hour
			"m+" : this.getMinutes(), //minute
			"s+" : this.getSeconds(), //second
			"q+" : Math.floor((this.getMonth()+3)/3), //quarter
			"S" : this.getMilliseconds() //millisecond
			}
			
			if(/(y+)/.test(format)) {
			format = format.replace(RegExp.$1, (this.getFullYear()+"").substr(4 - RegExp.$1.length));
			}
			
			for(var k in o) {
			if(new RegExp("("+ k +")").test(format)) {
			format = format.replace(RegExp.$1, RegExp.$1.length==1 ? o[k] : ("00"+ o[k]).substr((""+ o[k]).length));
			}
			}
			return format;
		};
	</script>
		
</@commentsDirective>