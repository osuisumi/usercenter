//相片预览
var photoPreview = $(window).photoPreview || {};

photoPreview = {
    //这是初始索引
    p_index : 0,
    f_index: 0,
    element : {
        p_wrap : "#photoPreviewBd",
        layer : ".g-photoPreview-layer",
        big_list : ".m-preview-bList",
        small_list : ".m-preview-sList"
    },
    photo_area_height: null,
    total:0,
    page:1,
    limit:9,
    totalPage:0,
    nowPhotoId:'',
	//index:下标 total:总数  page:当前页数 limit:每页条数
    init : function(index,total,page,limit){
        var _this = this;
        //判断是否传入新的索引
        if(index === '' || index === undefined || index === 'undefined' || index === null){
        }else {
            //重置索引
           _this.p_index = index;
        }
       	_this.total = total||0;
       	_this.page = page||1;
       	_this.limit = limit||9;
       	_this.totalPage = Math.ceil(_this.total/_this.limit);
        //执行相片预览区域显示函数
        _this.show();
        //关闭函数
        _this.close();
    },
    //打开相片预览
    show : function(){
        //获取预览区域
        var $photo_wrap = $(this.element.p_wrap);
        $photo_wrap.show();
        //获取相片预览区域的高度
        this.photo_area_height = parseInt($(this.element.layer).height() - 140);
        //打开相片预览，设置区域高度
        $photo_wrap.find(this.element.big_list).css('height', this.photo_area_height + 'px');
        //大图区域效果
        this.bigPhoto($photo_wrap);
        //小图区域效果
        this.smallPhoto($photo_wrap);
    },
    //关闭 
    close : function(){
        //点击关闭
        $(this.element.p_wrap).on('click','.close',function(){
            $(photoPreview.element.p_wrap).hide();
        });
    },
    bigPhoto : function(photo_wrap){
        //获取图片个数
        var photo_length = photo_wrap.find(this.element.big_list).children().length;

        //默认打开显示的图片
        photoPreview.photoChange(photo_wrap);
        //显示隐藏大图切换按钮
        photoPreview.hidePrevNextBtn();
        //左切换
        $('#photoPreiewPrev').off().on('click',function(){
            //右切换按钮显示
            $('#photoPreiewNext').show();
            //切换到最左边图片的时候，隐藏左切换按钮
            if(photoPreview.p_index === 1){
               //$(this).hide();
               //prev();
            }
            //如果是第0张，执行上一页
            if(photoPreview.p_index === 0){
            	prev();
            }
            //大图索引-1
            photoPreview.p_index--;
            photoPreview.hidePrevNextBtn();
            //执行切换函数
            photoPreview.photoChange(photo_wrap);
            //执行焦点图翻页函数
            //photoPreview.focusListChange(true);
        });
        //右切换
        $('#photoPreiewNext').off().on('click',function(){
            //左切换按钮显示
            $('#photoPreiewPrev').show();
            //切换到最左边图片的时候，隐藏左切换按钮
            //执行下一页
            if(photoPreview.p_index >= photo_length - 2){
                //$(this).hide();
                //next();
            }
            //如果是最后一张，执行下一页
            if(photoPreview.p_index === photo_length - 1){
            	next();
            }
            //大图索引+1
            photoPreview.p_index++;
            photoPreview.hidePrevNextBtn();
            //执行切换函数
            photoPreview.photoChange(photo_wrap);
            //执行焦点图翻页函数
            //photoPreview.focusListChange(true);
        }); 
    },
    //焦点图函数
    smallPhoto: function(photo_wrap){
    	
        var $s_list = $(photoPreview.element.layer).find(photoPreview.element.small_list),//获取焦点图列表
            $s_item = $s_list.children(), //单个焦点图
            $focusPrevBtn = $("#photoPreiewFocusPrev"), //左翻页按钮
            $focusNextBtn = $("#photoPreiewFocusNext"); //游翻页按钮

        var item_length = photoPreview.total,//$s_item.length, //焦点图个数
            item_width = $s_item.innerWidth(), //焦点图宽度
            item_margin = parseInt($s_item.css('marginRight')), //焦点图margin-right的值
            ofh_width = $s_list.parent().width(), //焦点图父级的宽度
            //row_item_num = Math.round(ofh_width / (item_width + item_margin)), //焦点图一页图片的个数
            row_item_num = photoPreview.limit,
            row_num = Math.ceil(item_length / row_item_num), //焦点图页数
            row_width = (item_width + item_margin) * row_item_num; //翻页的长度
        //重置焦点图翻页索引
        photoPreview.f_index = parseInt(photoPreview.p_index / row_item_num); //焦点图页码
        
        if(photoPreview.totalPage>photoPreview.page){
        	$focusNextBtn.show();
        }else{
        	$focusNextBtn.hide();
        }
        
        if(photoPreview.page>1){
        	$focusPrevBtn.show();
        }else{
        	$focusPrevBtn.hide();
        }
		
        //焦点图点击
        $s_item.on('click',function(){
            //获取点击的索引
            photoPreview.p_index = photo_wrap.find(photoPreview.element.small_list).children().index(this);
            //执行切换函数
            photoPreview.photoChange(photo_wrap);
            photoPreview.hidePrevNextBtn();
        });
		/*
        //焦点图左翻页
        $focusPrevBtn.off().on('click',function(){
            $focusNextBtn.show();
            if(photoPreview.f_index <= 1){
                $(this).hide();
            }
            photoPreview.f_index--;
            $s_list.stop().animate({
                'left': -row_width * photoPreview.f_index + 'px'
            },200);   
        });
        
        //焦点图右翻页
        $focusNextBtn.off().on('click',function(){
            $focusPrevBtn.show();
            if(photoPreview.f_index >= row_num - 2){
                $(this).hide();
            }
            photoPreview.f_index++;
            $s_list.stop().animate({
                'left': -row_width * photoPreview.f_index + 'px'
            },200);   
        });
        //执行焦点图翻页函数
        photoPreview.focusListChange(false);
        */
    },
    //大图切换
    photoChange : function(photo_wrap){
        //获取图片列表
        var $photo_item = photo_wrap.find(photoPreview.element.big_list).children();
        var nowImg = $photo_item.eq(photoPreview.p_index).children('img');
    	var nowPhotoId = nowImg.attr('photoId');
    	//加载详细页面
    	photoPreview.nowPhotoId = nowPhotoId;
    	loadPhotoDetail(nowPhotoId);
        //获取当前索引图片的高度
        var this_img_h = $photo_item.eq(photoPreview.p_index).children('img').height();
        //显示当前索引的图片
        $photo_item.removeClass('z-crt').eq(photoPreview.p_index).addClass('z-crt');
        //photoPreview.nowPhotoId = $photo_item.eq(photoPreview.p_index).attr('photoId');
        //设置当前索引图片的top值
        $photo_item.eq(photoPreview.p_index).children('img').css('top', (photoPreview.photo_area_height - this_img_h) / 2 + 'px'); 
        //获取焦点图片列表
        var $focus_lst = photo_wrap.find(photoPreview.element.small_list);
        //显示当前索引的焦点图片
        $focus_lst.children().removeClass('z-crt').eq(photoPreview.p_index).addClass('z-crt');
        //索引等于0的时候，左切换按钮隐藏
    },
    //显示隐藏大图切换按钮函数
    hidePrevNextBtn : function(){
    	//第一页第一张图,隐藏左翻页
    	//最后一页最后一张图，隐藏右翻页
    	if(photoPreview.page == 1 && photoPreview.p_index<=0){
    		$('#photoPreiewPrev').hide();
    	}else{
    		$('#photoPreiewPrev').show();
    	}
    	
    	if(photoPreview.page == photoPreview.totalPage && photoPreview.p_index+1>=photoPreview.total%photoPreview.limit){
    		$('#photoPreiewNext').hide();
    	}else{
    		$('#photoPreiewNext').show();
    	}
    	/*
        //获取大图个数
        var photo_length = $(photoPreview.element.layer).find(photoPreview.element.big_list).children().length;
        //当前索引小于等于0的时候，隐藏大图的左切换按钮
        if(photoPreview.p_index <= 0){
            $('#photoPreiewPrev').hide();
        //或者如果当前索引小于图片总数的时候，显示左右切换按钮
        }else if(photoPreview.p_index < photo_length - 1){
            $('#photoPreiewPrev').show();
            $('#photoPreiewNext').show();
        //如果索引大于等于总数的时候，隐藏右切换按钮
        }else {
            $('#photoPreiewNext').hide();
        }*/
    },
    //焦点图列表翻页
    /*
    focusListChange : function(ifAnimate){
        var $s_list = $(photoPreview.element.layer).find(photoPreview.element.small_list),//获取焦点图列表
            $s_item = $s_list.children(),//获取单个焦点图
            $focusPrevBtn = $("#photoPreiewFocusPrev"), //左翻页按钮
            $focusNextBtn = $("#photoPreiewFocusNext"); //游翻页按钮

        var item_length = photoPreview.total,//$s_item.length, //焦点图个数
            item_width = $s_item.innerWidth(), //焦点图宽度
            item_margin = parseInt($s_item.css('marginRight')), //焦点图margin-right的值
            ofh_width = $s_list.parent().width(), //焦点图父级的宽度
            row_item_num = Math.round(ofh_width / (item_width + item_margin)), //焦点图一页图片的个数
            row_num = Math.ceil(item_length / row_item_num); //焦点图页数
        //重置焦点图翻页索引
        photoPreview.f_index = parseInt(photoPreview.p_index / row_item_num); //焦点图页码
        $s_list.css('width', (item_width + item_margin) * item_length + 'px');
        //判断焦点图页数是否只有1页
        if(row_num <= 1){
            //如果是，隐藏焦点图左右翻页按钮
            $focusPrevBtn.hide();
            $focusNextBtn.hide();
        //页数超过一页
        }else {
            //如果页码为0
            if(photoPreview.f_index === 0){
                //隐藏左翻页按钮
                $focusPrevBtn.hide();
            //或者如果页码小于总页数
            }else if(photoPreview.f_index < row_num - 1){
                //显示左右翻页按钮
                $focusPrevBtn.show();
                $focusNextBtn.show();
            //如果页面等于总页数
            }else if(photoPreview.f_index == row_num - 1) {
                //隐藏右滚动按钮
                $focusNextBtn.hide();
            }
        }
        var page_slide_width = (item_width + item_margin) * row_item_num * photoPreview.f_index;
        //判断是否执行翻页动画
        if(ifAnimate){
            //翻页
            $s_list.stop().animate({'left': -page_slide_width + 'px'},200);
        }else {
            //翻页
            $s_list.css('left', -page_slide_width + 'px');
        }

    }
    */
};