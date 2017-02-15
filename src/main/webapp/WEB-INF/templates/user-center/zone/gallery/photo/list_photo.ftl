<#import "/common/image.ftl" as image/>
<@photoGalleryPhotosDirective galleryId=galleryId! pageBounds=pageBounds>
<dl class="m-dynamic">
	<input type="hidden" value="${galleryId}" id="galleryId">
	<dt class="m-zone-mod m-all-dynamic" id="defaultTit">
		<h3 class="u-tit">我的相册</h3>
		<a onclick="loadContent('gallery')" class="u-btn u-btn-upload" id="upload-photo">返回相册</a>
	</dt>
	<dt class="m-zone-mod m-all-dynamic check" id="photoOpa">
		<div class="all-chk">
			<label class="chk-lbl" id="checkAll"> <strong> <i class="u-ico-check"></i>
				<input type="checkbox">
				</strong> <span class="txt">本页全选</span> </label>
				<!--<span>已选择1张</span>-->
		</div>
		<a href="javascript:void(0);" class="u-btn u-btn-upload" id="finishMag">完成管理</a>
		<a href="javascript:void(0);" class="u-btn u-btn-create" id="deletePhotos">删除</a>
		<!-- <a href="javascript:void(0);" class="u-btn u-btn-create" id="create-photo">编辑照片信息</a> -->
		<a href="javascript:void(0);" class="u-btn u-btn-create" id="movePhoto">移动到相册</a>
	</dt>
	<dd class="m-zone-mod m-person-dynamic">
		<div class="g-photo-lst">
			<div class="g-photo-info">
				<div class="m-photo-info">
					<span class="u-img">
						<@image.imageFtl url="${(photoGallery.frontCover)!}" default="/user-center/images/pic-none.png" /> 
					</span>
					<div class="img-name">
						<b>${(photoGallery.name)!}</b>
						<span>${(photoGallery.photoNumber)!}张</span>
						<span class="line">/</span>
						<span>
							<#if photoGallery.privacy??>
								<#if photoGallery.privacy == "all">
									所有人可见
								<#elseif photoGallery.privacy == "myselfOnly">
									仅自己可见
								<#elseif photoGallery.privacy == "myFollowOnly">
									我关注的用户可见
								</#if>
							</#if>
						</span>
						<i class="u-ico-drop1"></i>
					</div>
					<#if ThreadContext.getUser().getId() == userId>
						<div class="u-opa">
							<a href="javascript:void(0);" class="u-btn-upload" id="photoUploadBtn"><i class="u-ico-upload"></i>上传照片</a>
							<a href="javascript:void(0);" class="u-btn-create" id="mgBtn">批量管理</a>
							<!-- <a href="javascript:void(0);" class="u-btn-create"></i>更多</a> -->
						</div>
					</#if>
				</div>
				<div class="m-photo-edit">
					<b class="photo-name">${(photoGallery.name)!}</b>
					<!--<a href="javascript:void(0);" class="u-edit" id="editPhotoInfo">编辑相册信息</a>-->
					<!-- <span class="u-tips">直接拖动照片可调整顺序</span> -->
				</div>
			</div>
				<ul class="m-photo-lst photo-detail" id="m-photo-lst" data-alter="false">
					<#if photos??>
						<#list photos as p>
							<li>
								<div class="m-block">
									<label> 
										<strong photoId="${p.id}"> <i class="u-ico-check"></i>
											<input type="chckbox">
										</strong> 
										<a href="javascript:void(0);" class="m-img">
											<span class="u-img"><img id="${p.id}" src="${FileUtils.getFileUrl((p.fileInfo.url)!)}" url="${(p.fileInfo.url)!}" alt=""></span> 
											<span class="u-btm"> 
												<span class="txt">
													<#if p.name??>
														${p.name}
													<#else>
														${(p.fileInfo.fileName)!}
													</#if>
												</span> 
											</span>
										</a> 
									</label>
									<#if ThreadContext.getUser().getId() == userId>
									<div class="m-opa">
										<a href="javascript:void(0);" class="u-drop"><i class="u-ico-drop"></i></a>
										<div class="opa-lst" photoId="${p.id}">
											<a onclick="editPhoto(this)" href="javascript:void(0);" class="lst u-btn-edit"><i class="u-ico-edit"></i>编辑</a>
											<!--
											<a href="javascript:void(0);" class="lst"><i class="u-ico-rotateRt"></i>旋转（右旋）</a>
											<a href="javascript:void(0);" class="lst"><i class="u-ico-rotateLt"></i>旋转（左旋）</a>
											-->
											<a onclick="setCover(this)" href="javascript:void(0);" class="lst"><i class="u-ico-cover"></i>设为封面</a>
											<a onclick="moveToGallery(this)" href="javascript:void(0);" class="lst"><i class="u-ico-move"></i>移动到相册</a>
											<a onclick="deletePhoto(this)" href="javascript:void(0);" class="lst u-btn-del"><i class="u-ico-delete1"></i>删除</a>
										</div>
									</div>
									</#if>
								</div>
							</li>
						</#list>
					</#if>
				</ul>
			<form id="listPhotoForm" action="${ctx}/userCenter/zone/gallery/photo/list/${galleryId}">
				<input type="hidden" value="${limit!}" name="limit">
				<input type="hidden" value="${userId}" name="userId">
				<#if paginator??>
					<#import "../../../../common/pagination_ajax.ftl" as p/>
					<@p.paginationAjaxFtl formId="listPhotoForm" divId="photoPage" paginator=paginator contentId="zoneContent"/>
				</#if>
			</form>
			<div id="photoPage" class="m-laypage"></div>
		</div>
		<!-- end g-photo-lst -->
	</dd>
</dl>
	<div id="detailList">
	</div>
<form id="changeGalleryCoverForm" action="${ctx}/userCenter/zone/gallery/photoGallery/${photoGallery.id}" method="put">
	
</form>


<form id="deletePhotosForm" action="${ctx}/userCenter/zone/gallery/photoGallery/${galleryId}/removePhotos?_method=DELETE">
	
</form>
<script>
	$(function(){
		//弹框--上传照片
	    $("#photoUploadBtn").on("click",function(){
	        mylayerFn.open({
	       	 	id: '999',
	       	 	fix: false,
	            shadeClose: false,
	            type: 2,
	            title: "上传相片",
	            area: [700,450],
	            offset: ['auto','auto'],
	            content: "${ctx}/userCenter/zone/gallery/photo/create?galleryId=${galleryId}"
	        });
	    });
	    
    	//弹框--移动到相册
        $("#movePhoto").on("click",function(){
        	//获取所有选中相片的id
        	var strongs = $('#m-photo-lst li strong[class="on"]');
        	if(strongs.size()<=0){
        		alert('请选择相片');
        		return false;
        	}
        	var photoIds = '';
        	$.each(strongs,function(i,n){
        		if(photoIds == ''){
        			photoIds = $(n).attr('photoId');
        		}else{
        			photoIds = photoIds + ',' +  $(n).attr('photoId');
        		}
        	});
            mylayerFn.open({
            	id: '999',
	       	 	fix: false,
	            shadeClose: false,
                type: 2,
                title: "移动到相册",
                area: [500,190],
                offset: ['auto','auto'],
                content: "${ctx}/userCenter/zone/gallery/photo/move?galleryId=${galleryId}&photoIds="+photoIds
            });
        });
        
        //批量删除按钮
        $('#deletePhotos').on('click',function(){
        	confirm("确定删除选中的图片吗?",function(){
        		var strongs = $('#m-photo-lst li strong[class="on"]');
	        	if(strongs.size()<=0){
	        		alert('请选择相片');
	        		return false;
	        	}
	        	var deleteForm = $('#deletePhotosForm');
	        	deleteForm.empty();
	        	var photoIds = '';
	        	$.each(strongs,function(i,n){
	        		if(photoIds == ''){
	        			photoIds = $(n).attr('photoId');
	        		}else{
	        			photoIds = photoIds + ',' +  $(n).attr('photoId');
	        		}
	        	});
	        	deleteForm.append('<input type="hidden" name="photoIds" value="'+photoIds+'">');
	        	var response = $.ajaxSubmit('deletePhotosForm');
	        	response = $.parseJSON(response);
	        	if(response.responseCode == '00'){
	        		alert('删除成功');
	        	}
        	});
        });
        
        //j图片缩略图
	    $('#m-photo-lst .m-block .u-img img').jqthumb({
	        width: 190,
	        height: 178,
	        after: function(imgObj){
	            imgObj.css('opacity', 0).animate({opacity: 1}, 500);
	        }
	    });
	    //j图片缩略图
	    $('.m-preview-sList li img').jqthumb({
	        width: 52,
	        height: 52,
	    });
	    
	    //点击图片弹出预览列表
        $("#m-photo-lst").on('click','li .m-img',function(){
        	$this = $(this);
        	var photoId = $(this).closest('li').find('strong').eq(0).attr('photoId');
        	$('#detailList').load('${ctx}/userCenter/zone/gallery/photo/detailList/${galleryId}?page=${paginator.page}',function(){
		        var data_att = $this.parents("#m-photo-lst").attr("data-alter");
		        var $Pli = $this.parents("li");
		        var indexs = $Pli.index();
		        if(data_att === 'false'){            
	            	photoPreview.init(indexs,'${(paginator.totalCount)!}','${(paginator.page)!}'); 
	 			};
        	});
    	});
    	
    	function loadDetailList(){
    		$('#detailList').load('${ctx}/userCenter/zone/gallery/photo/detailList/${galleryId}?page=${paginator.page}');
    	}
    	
    	   //相册下拉框
		    photoDrop();
		    function photoDrop(){
		        var photo_lst = $("#m-photo-lst"),
		            btn = photo_lst.find(".u-drop"),
		            lst = photo_lst.find(".opa-lst"),
		            block = photo_lst.find(".m-block");
		        btn.on("click",function(){
		            var _ts = $(this),
		                lst = _ts.next(".opa-lst");
		            lst.show();
		        });
		        lst.on("mouseover",function(){
		            $(this).show();
		        });
		        lst.on("mouseout",function(){
		            $(this).hide();
		        });
		        block.on("mouseleave",function(){
		            $(this).find(".opa-lst").hide();
		        });
		    }
    	
       	//批量管理
        manage();
        function manage(){
            var mg_btn = $("#mgBtn"),                   //批量管理按钮
                mg_img = mg_btn.parents(".g-photo-info").siblings('#m-photo-lst')
                default_tit = $("#defaultTit"),         //我的相册标题
                photo_opa = $("#photoOpa"),             //管理相册标题
                photo_info = $(".m-photo-info"),  
                fns_btn = $("#finishMag"),              //完成管理按钮
                photo_edit = $(".m-photo-edit"),
                check_all = $("#checkAll"),
                photo_lst_check = $("#m-photo-lst .m-block").find("strong");

                //点击批量管理按钮
                mg_btn.on("click",function(){
                    default_tit.hide();
                    photo_opa.show();
                    photo_info.hide();
                    photo_edit.show();
                    photo_lst_check.show();
                    mg_img.removeClass('m-img-List');
                    mg_img.attr('data-alter',"ture");
                });
                //点击完成管理按钮
                fns_btn.on("click",function(){
                    default_tit.show();
                    photo_opa.hide();
                    photo_info.show();
                    photo_edit.hide();
                    photo_lst_check.hide();
                    mg_img.addClass('m-img-List');
                    mg_img.attr('data-alter',"false");
                });

                photo_lst_check.on("click",function(){
                    var _ts = $(this);
                    if(!(_ts.hasClass("on"))){
                        _ts.addClass("on");
                    }else{
                        _ts.removeClass("on");
                    }
                })

                check_all.on("click",function(event){
                    var cld = $(this).find("strong"),
                        ipt = $(this).find("input");
                    if(!(ipt.is(":checked"))){
                        cld.removeClass("on");
                        photo_lst_check.each(function(){
                            $(this).removeClass("on");
                        })
                    }else{
                        cld.addClass("on");
                        photo_lst_check.each(function(){
                            if(!($(this).hasClass("on"))){
                                $(this).addClass("on");
                            }
                        });
                    }
                    event.stopPropagation();
                });
        }
	    
	
	}); 
	
        function setCover(a){
			var photoId = $(a).closest('div').attr('photoId');
			confirm('确定将该图片设置为封面?',function(){
				var form = $('#changeGalleryCoverForm');
				form.empty();
				var imgSrc = $('#'+photoId).attr('url');
				form.append('<input type="hidden" name="frontCover" value="'+imgSrc+'">');
				var response = $.ajaxSubmit('changeGalleryCoverForm');
				response = $.parseJSON(response);
				if(response.responseCode == '00'){
					alert('设置成功');
				}
			});
        } 
        
        function deletePhoto(a){
        	confirm("确定删除选中的图片吗?",function(){
	        	var deleteForm = $('#deletePhotosForm');
	        	deleteForm.empty();
	        	var photoIds = $(a).closest('div').attr('photoId');
	        	deleteForm.append('<input type="hidden" name="photoIds" value="'+photoIds+'">');
	        	var response = $.ajaxSubmit('deletePhotosForm');
	        	response = $.parseJSON(response);
	        	if(response.responseCode == '00'){
	        		alert('删除成功');
	        	}
        	});
        }
        
        function moveToGallery(a){
        	var photoIds = $(a).closest('div').attr('photoId');
            mylayerFn.open({
            	id: '999',
	       	 	fix: false,
	            shadeClose: false,
                type: 2,
                title: "移动到相册",
                area: [500,190],
                offset: ['auto','auto'],
                content: "${ctx}/userCenter/zone/gallery/photo/move?galleryId=${galleryId}&photoIds="+photoIds
            });
        }
        
        function editPhoto(a){
        	var photoIds = $(a).closest('div').attr('photoId');
            mylayerFn.open({
            	id: '999',
	       	 	fix: false,
	            shadeClose: false,
                type: 2,
                title: "编辑相片信息",
                area: [700,360],
                offset: ['auto','auto'],
                content: "${ctx}/userCenter/zone/gallery/photo/"+photoIds+"/edit"
            });
        	
        }
	
</script>

</@photoGalleryPhotosDirective>

