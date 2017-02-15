//赞按钮
var supportBtn = $(window).supportBtn || {};

supportBtn = {
	_loginId:'',//登录者id
	_relationType:'',//
	_doms:'',//
	_supportBtnClass:'',
	_unSupportBtnClass:'',
	_ctx:'',
	_this:'',
	
	init:function(loginId,_relationType,doms,supportBtnClass,unSupportBtnClass,ctx){
		_this = this;
		_loginId = loginId||'';
		_relationType = _relationType||'';
		_doms = doms||'';
		_supportBtnClass = supportBtnClass||'';
		_unSupportBtnClass = unSupportBtnClass||'';
		_ctx = ctx||'';
		
		_this.setSupportStat();
	},
	
	setSupportStat:function(){
		var ids = '';
		$.each(_doms,function(i,n){
			var id = $(n).attr('relationId');
			if(ids == ''){
				ids = id;
			}else{
				ids = ids + ',' + id;
			}
		});
		
		if(ids == ''){
			return;
		}
		
		$.get(_ctx+'/attitudes/attitudeUserMap',{
			'relationIds':ids,
			'relationType':_relationType
		},function(response){
			$.each(response, function(key, attitudeUser) {
				var dom = _doms.filter('[relationId="'+key+'"]');
				if (attitudeUser.attitude == 'support') {
					_this.addUnSupportBtn(dom);
				} else {
					_this.addSupportBtn(dom);
				}
			});
		});
	},
	
	addSupportBtn:function(dom){
		var supportBtn = $('<a href="javascript:void(0);" class="supportBtn" relationId="'+dom.attr('relationId')+'"><i class="'+_supportBtnClass+'"></i>赞</a>');
		_this.bindSupportFunc(supportBtn);
		$(dom).replaceWith(supportBtn);
	},
	
	addUnSupportBtn:function(dom){
		var unSupportBtn = $('<a href="javascript:void(0);" class="unSupportBtn" relationId="'+dom.attr('relationId')+'" ><i class="'+_unSupportBtnClass+'"></i>取消关注</a>');
		_this.bindUnSupportEvent(unSupportBtn);
		$(dom).replaceWith(unSupportBtn);
	},
	
	bindSupportFunc:function(supportBtn){
		supportBtn.on('click',function(){
			$.post(_ctx+'/attitudes', {
				'relation.id' : supportBtn.attr('relationId'),
				'relation.type' : _relationType,
				'attitude':'support'
			}, function(response) {
				if (response.responseCode == '00') {
					_this.addUnSupportBtn(supportBtn);
				}
			});
		});
	},
	
	bindUnSupportEvent:function(unSupportBtn){
		unSupportBtn.on('click',function(){
	    	$.post('${ctx}/attitudes',{
	    		"_method":'DELETE',
	    		"relationId":unSupportBtn.attr('relationId'),
	    		"attitude":'support'
	    	},function(response){
	    		if(response.responseCode == '00'){
	    			alert('取消成功');
	    			//var count = $('#supportNum_'+id).text();
	    			addSupportBtn(unSupportBtn);
	    		}
	    	});
		});
	}
	
};


