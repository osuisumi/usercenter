//关注按钮
var followFn = $(window).followFn || {};


followFn = {
	_loginId:'',//登录者id
	_followType:'',//关注的类型
	_doms:'',//关注按钮
	_followBtnDom:'',//关注按钮模板
	_unFollowBtnDom:'',//取消按钮模板
	_ctx:'',
	_msg:'',
	_this:'',
	
	init:function(loginId,followType,doms,followBtnDom,unFollowBtnDom,ctx,msg){
		_this = this;
		_loginId = loginId||'';
		_followType = followType||'';
		_doms = doms||'';
		_followBtnDom = followBtnDom||$('');
		_unFollowBtnDom = unFollowBtnDom||$('');
		_ctx = ctx||'';
		_msg = msg||'关注',
		_this.setFollowStat();
	},
	
	setFollowStat:function(){
		var ids = '';
		$.each(_doms,function(i,n){
			var id = $(n).attr('followRelationId');
			if(ids == ''){
				ids = id;
			}else{
				ids = ids + ',' + id;
			}
		});
		
		if(ids == ''){
			return;
		}
		
		$.get(_ctx+'/follows/isFollow',{
			'userId':_loginId,
			'relationIds':ids,
			'type':_followType
		},function(response){
			$.each(response, function(key, value) {
				var dom = _doms.filter('[followRelationId="'+key+'"]');
				if (value == true) {
					_this.addUnFollowBtn(dom);
				} else {
					_this.addFollowBtn(dom);
				}
			});
		});
	},
	
	addFollowBtn:function(dom){
		var followBtn = followFn._followBtnDom.clone();
		followBtn.attr('followRelationId',dom.attr('followRelationId'));
		_this.bindFollowFunc(followBtn);
		$(dom).replaceWith(followBtn);
	},
	
	addUnFollowBtn:function(dom){
		var unFollowBtn = followFn._unFollowBtnDom.clone();
		followBtn.attr('followRelationId',dom.attr('followRelationId'));
		_this.bindUnFollowEvent(unFollowBtn);
		$(dom).replaceWith(unFollowBtn);
	},
	
	bindFollowFunc:function(followBtn){
		followBtn.on('click',function(){
			$.post(_ctx+'/follows', {
				'followEntity.id' : followBtn.attr('followRelationId'),
				'followEntity.type' : _followType
			}, function(response) {
				if (response.responseCode == '00') {
					_this.addUnFollowBtn(followBtn);
				}
			});
		});
	},
	
	bindUnFollowEvent:function(unFollowBtn){
		unFollowBtn.on('click',function(){
			confirm("确定取消"+_msg+"吗？",function(){
				$.post(_ctx+"/follows/deleteByUserAndFollowEntity",{
					"_method":"DELETE",
					"creator.id":_loginId,
					"followEntity.id":unFollowBtn.attr('followRelationId'),
					"followEntity.type":_followType
				},function(response){
					if(response.responseCode == '00'){
						alert('取消成功',function(){
							_this.addFollowBtn(unFollowBtn);
						});
					}
				});
			});
		});
	}
	
};


