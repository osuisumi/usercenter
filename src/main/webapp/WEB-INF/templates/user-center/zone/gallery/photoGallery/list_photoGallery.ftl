<#import "/common/image.ftl" as image/>
<dl class="m-dynamic">
	<dt class="m-zone-mod m-all-dynamic">
		<h3 class="u-tit">我的相册</h3>
		<#if ThreadContext.getUser().getId() == userId>
			<a href="javascript:void(0);" class="u-btn u-btn-create" id="create-photo">+ 新建相册</a>
			<a href="javascript:void(0);" class="u-btn u-btn-upload" id="upload-photo"><i class="u-ico-upload"></i>上传照片</a>
		</#if>
	</dt>
	<@photoGallerysDirective userId=userId pageBounds=pageBounds>
	<dd class="m-zone-mod m-person-dynamic">
		<div class="g-photo-lst">
			<ul class="m-photo-lst" id="m-photo-lst">
				<#if photoGallerys?? && (photoGallerys?size >0)>
				<#if photoGallerys??>
					<#list photoGallerys as pg>
						<li>
							<div class="m-block">
								<a onclick="loadPhotos('${pg.id}')" class="m-img"> 
									<span class="u-img"><@image.imageFtl url="${(pg.frontCover)!}" default="/user-center/images/pic-none.png" /></span>
									<span class="u-btm"> 
										<span class="txt">${(pg.name)!}</span> <span class="ico">${(pg.photoNumber)!0}</span>
									</span>
								</a>
								<#if ThreadContext.getUser().getId() == userId>
								<div class="m-opa">
									<a href="javascript:void(0);" class="u-drop"><i class="u-ico-drop"></i></a>
									<div class="opa-lst" galleryId="${(pg.id)!}">
										<a href="javascript:void(0);" class="lst u-btn-edit"><i class="u-ico-edit"></i>编辑</a>
										<!--<a href="javascript:void(0);" class="lst u-btn-power"><i class="u-ico-lock"></i>权限设置</a>-->
										<a href="javascript:void(0);" class="lst u-btn-del"><i class="u-ico-delete1"></i>删除</a>
									</div>
								</div>
								</#if>
							</div>
						</li>
					</#list>
				</#if>
				<#else>
					<div class="g-no-notice-Con">
			        	<p class="txt">暂时没有数据！</p>
			    	</div>
				</#if>
			</ul>
			<form id="listGalleryForm" action="${ctx}/userCenter/zone/gallery/photoGallery">
				<input type="hidden" value="${limit!}" name="limit">
				<input type="hidden" value="${userId}" name="userId">
				<#if paginator??>
					<#import "/common/pagination_ajax.ftl" as p/>
					<@p.paginationAjaxFtl formId="listGalleryForm" divId="galleryPage" paginator=paginator contentId="zoneContent"/>
				</#if>
			</form>
			<div id="galleryPage" class="m-laypage"></div>
		</div>
	</dd>
	</@photoGallerysDirective>
</dl>

<script>
	$(function(){
		changeZoneItem('gallery');
	})

	function loadPhotos(id){
		$('#zoneContent').load('${ctx}/userCenter/zone/gallery/photo/list/'+id+'?userId=${userId}');
	}
	
	$(function(){
        //弹框--创建相册
        $("#create-photo").on("click",function(){
            mylayerFn.open({
	            id: '999',
	            fix: false,
	            shadeClose: false,
                type: 2,
                title: "创建相册",
                area: [700,450],
                offset: ['auto','auto'],
                content: "${ctx}/userCenter/zone/gallery/photoGallery/create"
            });
        });

        //弹框--上传照片
        $("#upload-photo").on("click",function(){
        	var gallery = $('#m-photo-lst li');
        	if(gallery.size()<=0){
        		alert('请先创建相册');
        		return false;
        	}
            mylayerFn.open({
           	 	id: '999',
           	 	fix: false,
	            shadeClose: false,
                type: 2,
                title: "上传相片",
                area: [700,450],
                offset: ['auto','auto'],
                content: "${ctx}/userCenter/zone/gallery/photo/create"
            });
        });

        //弹框--编辑相册
        $(".u-btn-edit").on("click",function(){
        	var galleryId = $(this).closest('div').attr('galleryId');
            mylayerFn.open({
                type: 2,
                title: "编辑相册信息",
                area: [700,450],
                content: "${ctx}/userCenter/zone/gallery/photoGallery/edit/"+galleryId
            });
        });

        //弹框--权限设置
        $(".u-btn-power").on("click",function(){
            mylayerFn.open({
                type: 2,
                title: "权限设置",
                area: ["500px","190px"],
                content: "mylayerFn/edit-power.html"
            });
        });

        //弹框--删除相册
        $(".u-btn-del").on("click",function(){
        	var galleryId = $(this).closest('div').attr('galleryId');
            confirm('确定删除该相册吗?',function(){
            	$.post('${ctx}/userCenter/zone/gallery/photoGallery/'+galleryId,{
            		"_method":'DELETE',
            	},function(response){
            		if(response.responseCode == '00'){
            			alert('删除成功',function(){
            				loadContent('gallery');
            			});
            			
            		}
            	});
            });
        });
    });
    
    
    $(function(){
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
    usercommentfocus();
    del_replay();
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
                val_tw = $(".1").find(".au-textarea").val(),
                val_th = $(".2").find(".au-textarea").val(),
                val_fou = $(".3").find(".au-textarea").val(),
                val_fin = $(".4").find(".au-textarea").val();
           
                if(val_one==""&&val_tw==""&&val_th==""&&val_fou==""&&val_fin==""){
                    // alert($(this).val())
                     $('.bigarea').stop().animate({height : "76px"
                        },200,function(){
                            $(this).parent().siblings('.am-cmtBtn-block').show();
                        }).focus(); 
                    $otherComm.stop().animate({height : "22px"
                            },200,function(){
                            $(this).parent().siblings('.am-cmtBtn-block').hide();
                        });
                    // alert($usrerComm.attr("class"))
                    $usrerComm.removeClass('bigarea');              
                }else{
                    var hasComm = confirm('您正在发表，是否关闭该条发表？');
                    $textarea.each(function(){
                        if(!$(this).val()==""){
                            $(this).addClass('in')
                        }
                    });

                    if(hasComm==true){
                         $('.in').stop().animate({height : "22px"
                            },200,function(){
                                $(this).parent().siblings('.am-cmtBtn-block').hide();
                            }).val("");      
                        $('.bigarea').stop().animate({height : "76px"
                                },200,function(){
                                $(this).parent().siblings('.am-cmtBtn-block').show();
                            }).focus();
                        $usrerComm.removeClass('bigarea');
                        $textarea.removeClass('in') 

                    
                     }else{
                         $('.in').stop().animate({height : "76px"
                            },200,function(){
                                $(this).parent().siblings('.am-cmtBtn-block').show();
                            }).focus();      
                        $('.bigarea').stop().animate({height : "22px"
                                },200,function(){
                                $(this).parent().siblings('.am-cmtBtn-block').hide();
                            }).blur();
                        $usrerComm.removeClass('bigarea');  
                        $textarea.removeClass('in')                           
                     }
                         
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


});  
</script>