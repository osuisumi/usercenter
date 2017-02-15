///<jscompress sourcefile="common.js" />
$(document).ready(function(){
    //公共模块js初始化
    commonJs.fn.init();
    //初始化占位符
    $("input,textarea").placeholder();
    //模拟下拉框
    $(".m-selectbox select").simulateSelectBox();
    //点选按钮模拟
    $('.m-radio-tick input').bindCheckboxRadioSimulate();
    //多选按钮模拟
    $('.m-checkbox-tick input').bindCheckboxRadioSimulate();
})
//定义公共模块js
var commonJs = $(window).commonJs || {};

commonJs.fn = {
    init : function(){
        var _this = this;
        //自定义下拉框
        //_this.simulateSelectBox();
        //返回顶部
        _this.toTop();
        //搜索框动态效果
        _this.searchAnimate();
    },
    //弹出框
    aJumpLayer : function(layer){
        var layer = $(layer),
            width = layer.innerWidth(),
            height = layer.innerHeight();
        layer.show().css({'margin-top':-height/2+'px','margin-left':-width/2+'px'});
        $('.m-blackbg').show();

        /*clickBtn.bind('click',function(){
            layer.show().css({'margin-top':-height/2+'px','margin-left':-width/2+'px'});
            $('.m-blackbg').show().css("opacity","0.5");

        })*/
        layer.find('.u-confirm-btn').bind('click',function(){
            layer.hide();
            $('.m-blackbg').hide();
        })
        layer.find('.u-cancel-btn').bind('click',function(){
            layer.hide();
            $('.m-blackbg').hide();
        })
        layer.find('.u-close-btn').bind('click',function(){
            layer.hide();
            $('.m-blackbg').hide();
        })
    },
    //打开绝对定位弹出框
    openABlayer : function(abLayer){
        var $layersLayout = $(abLayer),
            $whiteBg = $(".m-blackbg"),
            scrollTop = $(window).scrollTop();
        //打开弹出框
        $layersLayout.show().css('top',scrollTop + 100 + 'px');
        $whiteBg.show();
        //关闭弹出框
        this.closeABlayer($layersLayout,$whiteBg);

    },
    //关闭绝对定位弹出框
    closeABlayer : function($layersLayout,$whiteBg){
        var $colseBtn = $layersLayout.find(".u-close-btn"),
            $cancelBtn = $layersLayout.find(".u-cancel-btn"),
            $canfirmlBtn = $layersLayout.find(".u-confirm-btn");
        $colseBtn.on("click",function(){
            $layersLayout.hide();
            $whiteBg.hide();
        });
        $cancelBtn.on("click",function(){
            $layersLayout.hide();
            $whiteBg.hide();
        });
        $canfirmlBtn.on("click",function(){
            $layersLayout.hide();
            $whiteBg.hide();
        });
    },
    //返回顶部
    toTop : function(){
        //点击返回顶部
        $(document).on("click","#toTop",function(){
            $('html,body').animate({
                scrollTop: 0
            },100);
            return false;
        })
    },
    //搜索框动态效果
    searchAnimate : function(){
        //判断是否为IE浏览器，如果为IE浏览器，则使用jquery动画方式，反之采用css动画
        var navigatorName = "Microsoft Internet Explorer";  
        var isIE = false;   
        if( navigator.appName == navigatorName ){   
            isIE = true;   
            IE_fn();
        }else{   
            //alert("not ie"); 
            noIE_fn();  
        }   

        //IE浏览器使用jquery动画方式
        function IE_fn(){
            $(".m-srh .ipt").on('focus',function(){
                var $this = $(this),
                icon = $this.next();
                //如果value值为空，执行动画
                if($this.val() == ''){
                    $this.stop().animate({
                        'width' : 146 + 'px',
                        'padding-left' : 12 + 'px'
                    },500);
                    icon.stop().animate({
                        'right': 10 + 'px'
                    },500);
                }
            });
            //判断失去焦点时，用户是否输入文字
            $(".m-srh .ipt").on('blur',function(){
                var $this = $(this),
                    icon = $this.next();
                //如果value值为空，执行缩回动画，反之不执行
                if($this.val() == ''){
                    $this.stop().animate({
                        'width' : 60 + 'px',
                        'padding-left' : 98 + 'px'
                    },500);
                    icon.stop().animate({
                        'right': 100 + 'px'
                    },500);
                }
            });    
        };
        //非IE浏览器使用css3动画
        function noIE_fn(){
            $(".m-srh .ipt").on('blur',function(){
                var srhBox = $(this).parent();
                //如果value值为空，执行缩回动画，反之不执行
                if($(this).val() == ''){
                    srhBox.removeClass('hasValue');
                }else {
                    srhBox.addClass('hasValue');
                }
            });
        };
    },
    //课程指引提示 
    guideHint : function(guideHtml,nextGuideFn){
        /*
            guideHtml   : 指引提示html段，必有参数
            nextGuideFn : 存在下一步指引时，执行的方法
        */

        //默认没有下一步指引
        var nextGuide = false;
        //判断是否存在下一步指引
        if(nextGuideFn == "" || nextGuideFn == 'undefined' || nextGuideFn == null || nextGuideFn == undefined) {
        }else {
            nextGuide = true;
        }
        //插入指引html段
        $("body").append(guideHtml);

        //点击关闭
        $(".g-guide-hint .confirm").on('click',function(){
            var $this = $(this);
            //关闭指引
            $this.parents(".g-guide-hint").remove();
            $(".m-guideShade").remove();
            //如果存在下一步，执行下一步方法
            if(nextGuide){
                nextGuideFn();
            }
        });
    }
};




/*--start----多个同类名选项卡----start---*/
$.fn.extend({
    myTab : function(options)
    {
        var defaults = 
        {
            pars    : '.myTab',   //最外层父级
            tabNav  : '.tabNav',  //标签导航
            li      : 'li',       //标签
            tabCon  : '.tabCon',  //区域父级
            tabList : '.tabList', //t区域模块
            cur     : 'cur',      //选中类
            eType   : 'click',    //事件
            page    : 0 //默认显示第几个模块
        }
        var options = $.extend(defaults,options),
        _ts = $(this),
        tabBtn  = _ts.find(options.tabNav).find(options.li);
        tabList  = _ts.find(options.tabCon).find(options.tabList);
        this.each(function(){
            tabBtn.removeClass(options.cur);
            tabBtn.eq(options.page).addClass(options.cur);
            tabList.hide();
            tabList.eq(options.page).show();
            tabBtn.eq(options.page).show();
            tabBtn.on(options.eType,function(){
                var index = $(this).parents(options.tabNav).find(options.li).index(this);
                $(this).addClass(options.cur).siblings().removeClass(options.cur);
                $(this).parents(options.pars).find(options.tabCon).find(options.tabList).eq(index).css({'display':'block'}).siblings().css({'display':'none'});
            })
        })
        return this;
    }
});
/*--end-----多个同类名选项卡---end---*/


/*--start-----下拉多选款select按钮模拟---start---*/
(function ($) {
    $.fn.simulateSelectBox = function (options) {
        var settings = {//默认参数
            selectText: '.simulateSelect-text',
            byValue: null
        };
        //$.extend(true, settings, options);
        var options = $.extend(true,settings,options),
            _ts = this,
            selectText = options.selectText, //下拉框模拟文字class
            byValue = options.byValue;  //传入value值，重置默认选中

        return _ts.each(function(){
            var $this = $(this);
            //清除其他选中
            $this.find('option').prop('selected',false);
            //alert($this.find('option:selected').text());
            //判断是否传入value值
            if(byValue == "" || byValue == null || byValue == undefined){
                $this.find('option').eq(0).prop('selected',true);
            }else {
                //alert(byValue);
                //编辑选项，匹配传入的value值
                for(var i = 0; i < $this.find('option').length; i++){
                    if($this.find('option').eq(i).val() == byValue) {
                        //设置传入的value值选项为默认选中
                        $this.find('option').eq(i).prop('selected',true);
                        
                    }
                }
            }
            //改变模拟下拉框的文字
            $this.parent().find(selectText).text($this.find('option[selected="selected"]').text());
            $this.parent().find(selectText).text($this.find('option:selected').text());
        //点击下拉改变
        }).on('change',function(){
            //改变模拟下拉框的文字
            $(this).parent().find(selectText).text($(this).find('option:selected').text());
        });

    };
})(jQuery);
/*--end-----下拉多选款select按钮模拟---end---*/

/*--start-----radio单选与checkbox多选按钮的模拟---start---*/
(function ($) {
    $.fn.bindCheckboxRadioSimulate = function (options) {
        var settings = {
            className: 'on',
            onclick: null,
            checkbox_checked_fn: function (obj) {
                obj.parent().addClass(this.className);
            },
            checkbox_nochecked_fn: function (obj) {
                obj.parent().removeClass(this.className);
            },
            radio_checked_fn: function (obj) {
                obj.parent().addClass(this.className);
            },
            radio_nochecked_fn: function (obj) {
                obj.parent().removeClass(this.className);
            }
        };
        $.extend(true, settings, options);

        //input判断执行
        function inputJudge_fn(obj_this) {
           
            var $this = obj_this,
                $type;
            if ($this.attr('type') != undefined) {
                $type = $this.attr('type');
                if ($type == 'checkbox') {//if=多选按钮
                    if ($this.prop("checked")) {
                        settings.checkbox_checked_fn($this);
                    } else {
                        settings.checkbox_nochecked_fn($this);
                    }
                } else if ($type == 'radio') {//if=单选按钮
                    var $thisName;
                    if ($this.attr('name') != undefined) {
                        $thisName = $this.attr('name');
                        if ($this.prop("checked")) {
                            settings.radio_checked_fn($this);
                            $("input[name='" + $thisName + "']").not($this).each(function () {
                                settings.radio_nochecked_fn($(this));
                            });
                        } else {
                            settings.radio_nochecked_fn($this);
                        }
                    }
                }
            }
        }
        return this.each(function () {
            inputJudge_fn($(this));
        }).click(function () {
            inputJudge_fn($(this));
            if (settings.onclick) {
                settings.onclick(this, {
                    isChecked: $(this).prop("checked"),//返回是否选中
                    objThis: $(this)//返回自己
                });
            }
        });
    };
})(jQuery);
/*--end-----radio单选与checkbox多选按钮的模拟---end---*/

/*---start---------placeholder 占位符----------start--- */
; (function(f, h, $) {
    var a = 'placeholder' in h.createElement('input'),
    d = 'placeholder' in h.createElement('textarea'),
    i = $.fn,
    c = $.valHooks,
    k,
    j;
    if (a && d) {
        j = i.placeholder = function() {
            return this
        };
        j.input = j.textarea = true
    } else {
        j = i.placeholder = function() {
            var l = this;
            l.filter((a ? 'textarea': ':input') + '[placeholder]').not('.placeholder').bind({
                'focus.placeholder': b,
                'blur.placeholder': e
            }).data('placeholder-enabled', true).trigger('blur.placeholder');
            return l
        };
        j.input = a;
        j.textarea = d;
        k = {
            get: function(m) {
                var l = $(m);
                return l.data('placeholder-enabled') && l.hasClass('placeholder') ? '': m.value
            },
            set: function(m, n) {
                var l = $(m);
                if (!l.data('placeholder-enabled')) {
                    return m.value = n
                }
                if (n == '') {
                    m.value = n;
                    if (m != h.activeElement) {
                        e.call(m)
                    }
                } else {
                    if (l.hasClass('placeholder')) {
                        b.call(m, true, n) || (m.value = n)
                    } else {
                        m.value = n
                    }
                }
                return l
            }
        };
        a || (c.input = k);
        d || (c.textarea = k);
        $(function() {
            $(h).delegate('form', 'submit.placeholder', 
            function() {
                var l = $('.placeholder', this).each(b);
                setTimeout(function() {
                    l.each(e)
                },
                10)
            })
        });
        $(f).bind('beforeunload.placeholder', 
        function() {
            $('.placeholder').each(function() {
                this.value = ''
            })
        })
    }
    function g(m) {
        var l = {},
        n = /^jQuery\d+$/;
        $.each(m.attributes, 
        function(p, o) {
            if (o.specified && !n.test(o.name)) {
                l[o.name] = o.value
            }
        });
        return l
    }
    function b(m, n) {
        var l = this,
        o = $(l);
        if (l.value == o.attr('placeholder') && o.hasClass('placeholder')) {
            if (o.data('placeholder-password')) {
                o = o.hide().next().show().attr('id', o.removeAttr('id').data('placeholder-id'));
                if (m === true) {
                    return o[0].value = n
                }
                o.focus()
            } else {
                l.value = '';
                o.removeClass('placeholder');
                l == h.activeElement && l.select()
            }
        }
    }
    function e() {
        var q,
        l = this,
        p = $(l),
        m = p,
        o = this.id;
        if (l.value == '') {
            if (l.type == 'password') {
                if (!p.data('placeholder-textinput')) {
                    try {
                        q = p.clone().attr({
                            type: 'text'
                        })
                    } catch(n) {
                        q = $('<input>').attr($.extend(g(this), {
                            type: 'text'
                        }))
                    }
                    q.removeAttr('name').data({
                        'placeholder-password': true,
                        'placeholder-id': o
                    }).bind('focus.placeholder', b);
                    p.data({
                        'placeholder-textinput': q,
                        'placeholder-id': o
                    }).before(q)
                }
                p = p.removeAttr('id').hide().prev().attr('id', o).show()
            }
            p.addClass('placeholder');
            p[0].value = p.attr('placeholder')
        } else {
            p.removeClass('placeholder')
        }
    }
} (this, document, jQuery));
/*---end---------placeholder 占位符----------end--- */
///<jscompress sourcefile="sip-common.js" />
String.prototype.trim= function(){  
    return this.replace(/(^\s*)|(\s*$)/g, "");  
};
String.prototype.equalsIgnoreCase = function(str){
	return this.toLowerCase() == str.toLowerCase();
}
$.extend({
	ajaxQuery:function(formId,divId,callback,type){
		if(type == null || type == ''){
			type = 'get';
		}
		$.ajax({
			url:$("#"+formId).attr("action"),
			data:$("#"+formId).serialize(),
			type:type,
			success:function(data){
				$("#"+divId).html(data);
				if(callback!=undefined){
					var $callback = callback;
					if (! $.isFunction($callback)) $callback = eval('(' + callback + ')');
					$callback();
				}
			}
		});		
	},
	ajaxSubmit:function(formId){
		var data = $("#"+formId).serialize();
		var method = $("#"+formId).attr("method");
		if (method == 'delete' || method == 'DELETE' || method == 'put' || method == 'PUT') {
			data = '_method='+method+'&'+data;
		}
		var rData = $.ajax({
			url:$("#"+formId).attr("action"),
			data:data,
			type:'post',
			async:false,
			success:function(data){
				
			}
		}).responseText;
		return rData;
	},
	ajaxDelete:function(url, data, callback){
		$.ajax({
			url:url,
			type:'post',
			data:'_method=DELETE&'+data,
			success:function(data){
				if(callback!=undefined){
					var $callback = callback;
					if (! $.isFunction($callback)) $callback = eval('(' + callback + ')');
					$callback(data);
				}
			}
		});
	},
	put:function(url, data, callback){
		$.ajax({
			url:url,
			type:'post',
			data:'_method=PUT&'+data,
			success:function(data){
				if(callback!=undefined){
					var $callback = callback;
					if (! $.isFunction($callback)) $callback = eval('(' + callback + ')');
					$callback(data);
				}
			}
		});
	}
});

function assignParam(formId,objectId){
	$.each($('#'+formId+' :input'),function(){
		$(this).val($('#'+$(this).attr('id')+'_'+objectId).text());
	});
}

function checkAllBox(formId, obj){
	$(obj).click(function(){
		if($(this).prop("checked")){
			$('#'+formId+' :checkbox').each(function(){
				$(this).prop("checked",true);			
			});
		}else{
			$('#'+formId+' :checkbox').each(function(){
				$(this).prop("checked",false);			
			});
		}
	});
}

//txt:鏂囨湰妗唈query瀵硅薄
//limit:闄愬埗鐨勫瓧鏁�
//isbyte:true:瑙唋imit涓哄瓧鑺傛暟锛沠alse:瑙唋imit涓哄瓧绗︽暟
//cb锛氬洖璋冨嚱鏁帮紝鍙傛暟涓哄彲杈撳叆鐨勫瓧鏁�
function initLimit(txt,limit,isbyte,cb){
	txt.keyup(function(){
		var str=txt.val();
		var charLen;
		var byteLen=0;
		if(isbyte){
			for(var i=0;i<str.length;i++){
				if(str.charCodeAt(i)>255){
					byteLen+=2;
				}else{
					byteLen++;
				}
			}
			charLen = Math.floor((limit-byteLen)/2);
		}else{
			byteLen=str.length;
			charLen=limit-byteLen;
		}
		cb(charLen);
	});	
}

function guid(){
	var guid = (G() + G() + "" + G() + "" + G() + "" + 
			G() + "" + G() + G() + G()).toUpperCase();
	return guid;
}
function G() {
	return (((1 + Math.random()) * 0x10000) | 0).toString(16).substring(1);
}

function hintJumpLayer(){
	$('.m-blackbg').show();
	var layer = $('.g-layer-warning');
	var width = layer.innerWidth(),
    height = layer.innerHeight();
    layer.show().css({'margin-top':-height/2+'px','margin-left':-width/2+'px'});
}

/*window.msg = function(txt, confirmFn){
	layer.msg(txt, {time: 1500}, confirmFn);
};*/

window.alert = function(txt, confirmFn, time){
	//layer.alert(txt, confirmFn);
	if(time == null || time == ''){
		time = 1500;
	}
	mylayerFn.msg(txt, {time: time}, confirmFn);
};

window.confirm = function(txt, confirmFn, cancelFn){
	mylayerFn.confirm({
        content: txt,
        icon: 3,
        yesFn: confirmFn,
        cancelFn: cancelFn
    });
};

function getByteLength(value){
	var length = value.trim().length; 
    for(var i = 0; i < value.length; i++){      
        if(value.charCodeAt(i) > 127){      
        	length = length+2;      
        }      
    }
    return length;
}

function getSuffix(fileName){
	var index = fileName.lastIndexOf(".");
	return fileName.substring(index+1,fileName.length);
}

function getOuterHtml(obj) {
    var box = $('<div></div>');
    for (var i = 0; i < obj.length; i ++) {
        box.append($(obj[i]).clone());
    }
    return box.html();
}

function isMatchJson(data){
	if(data.match("^\{(.+:.+,*){1,}\}$")){
		return true;
	}else{
		return false;
	}
}
///<jscompress sourcefile="index.js" />
function closeLayer(){
	var index = parent.layer.getFrameIndex(window.name); 
	parent.layer.close(index); 
}

function downloadFile(id, fileName, type, relationId) {
	$('#downloadFileForm input[name="id"]').val(id);
	$('#downloadFileForm input[name="fileName"]').val(fileName);
	$('#downloadFileForm input[name="fileRelations[0].type"]').val(type);
	$('#downloadFileForm input[name="fileRelations[0].relation.id"]').val(relationId);
	//goLogin(function(){
		$('#downloadFileForm').submit();
	//});
}

function updateFile(id, fileName) {
	$('#updateFileForm input[name="id"]').val(id);
	$('#updateFileForm input[name="fileName"]').val(fileName);
	$.post('/file/updateFileInfo.do', $('#updateFileForm').serialize());
}

function deleteFileRelation(fileId, relationId, relationType) {
	$('#deleteFileRelationForm input[name="fileId"]').val(fileId);
	$('#deleteFileRelationForm input[name="relation.id"]').val(relationId);
	$('#deleteFileRelationForm input[name="type"]').val(relationType);
	$.post('/file/deleteFileRelation.do', $('#deleteFileRelationForm').serialize());
}

function deleteFileInfo(fileId) {
	$('#deleteFileInfoForm input[name="id"]').val(fileId);
	$.post('/file/deleteFileInfo.do', $('#deleteFileInfoForm').serialize());
}

function createCourseIndex(){
	window.location.href = '/make/course?orders=CREATE_TIME.DESC'
}

function goChangePassword(){
	mylayerFn.open({
        type: 2,
        title: '修改密码',
        fix: false,
        area: [620, 480],
        content: '/ncts/account/edit_password',
    });
}

function previewFile(fileId){
	mylayerFn.open({
        type: 2,
        title: '预览文件',
        fix: true,
        area: [$(window).width() * 99 / 100, $(window).height() * 99 / 100],
        content: '/file/previewFile?fileId='+fileId,
        shadeClose: true
    });
}
///<jscompress sourcefile="photoAlbum.js" />
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
