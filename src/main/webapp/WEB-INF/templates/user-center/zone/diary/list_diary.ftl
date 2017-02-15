<@diariesDirective diary=diary userId=userId! pageBounds=pageBounds>
<dl class="m-dynamic">
    <dt class="m-zone-mod m-all-dynamic">
        <h3 class="u-tit">学习日志</h3>
        <#if ThreadContext.getUser().getId() == userId!>
        	<a href="javascript:void(0);" class="u-btn u-btn-upload">+ 发表日志</a>
    	</#if>
    	<label class="m-srh">
            <input id="searchContext" value="${(diary.title)!}" type="text" class="ipt" placeholder="搜索">
            <i class="u-srh1-ico"></i>
        </label>
    </dt>
    <dd class="m-zone-mod m-person-dynamic">
        <ul class="m-jou-box">
        <#if diaries?? &&(diaries?size >0)>
        <#list diaries as diary>
            <li class="m-journal-Li" diaryId="${(diary.id)!}">
                <a class="m-jou-tl">
                    <#if (diary.isHot)! == 'Y'>
                    	<i class="u-hot"><ins></ins><span>热</span></i>
                    </#if>
                    <#if (diary.isTop)! == 'Y'>
                  		<i class="u-support"><ins></ins><span>顶</span></i>
                    </#if>
                    <#if (diary.isEssence)! == 'Y'>
                    	<i class="u-nice"><ins></ins><span>精</span></i> 
                    </#if>
                   	${(diary.title)!}                                          
                </a>
                <p class="m-time">
                    <span><i class="year">${diary.createTime?number_to_datetime?string("yyyy/MM/dd")!}</i>${diary.createTime?number_to_datetime?string("HH:mm:ss")!}</span> 
                    <a href="javascript:;"><i class="see"></i>浏览 (${(diary.browseNum)!'0'}) </a>
                </p>
                <p class="m-jour-txt">${(diary.content)!}</p>
                <div class="m-person-com m-jour-comment">
                    <div class="user-comment">
                        <a class="u-user-com-cl" ><i class="au-comment"></i>评论(${(diary.commentNum)!'0'})</a>
                        <i class="line">|</i>
                        <a class="diary-support">
	                        <#if attitudeUsers?? >
								<#if (attitudeUsers[diary.id].attitude)! == 'support'>
                        			<ii id="support_${(diary.id)!}"><i class="au-praise un-praise"></i><ii id="supportText_${(diary.id)!}">取消赞</ii>(<ii class="supportNum_${(diary.id)!}">${(diary.supportNum)!'0'}</ii>)</ii>
								<#else>
                       				<ii id="support_${(diary.id)!}"><i class="au-praise"></i><ii id="supportText_${(diary.id)!}">点赞</ii>(<ii class="supportNum_${(diary.id)!}">${(diary.supportNum)!'0'}</ii>)</ii>
								</#if>
							</#if>
                        </a>
                        <#if (ThreadContext.getUser().getId()) == (diary.creator.id)>
                        <i class="line">|</i>
                        <a class="diary-alter"><i class="au-edit"></i>编辑</a>
                        <i class="line">|</i>
                        <div class="more"><i class="au-more"></i>更多
                            <div class="m-more-List">
                                <i class="arrow"></i>
                                <a class="List diary-overhead">取消置顶</a>
                                <a class="List diary-category">修改分类</a>
                                	<a class="List diary-schedule">删除计划</a>
                            </div>
                        </div>
                        </#if>
                    </div>
                </div>
            </li>
       	</#list>
       	<#else>
   			<div class="g-no-notice-Con admin">
	        	<p class="txt">暂时没有数据！</p>
	    	</div>
        </#if>
        </ul>
        <form id="listDiaryForm"  method="post" action="${ctx!}/userCenter/zone/diary" >	
			<input type="hidden" name="_method" value="GET">
			<input type="hidden" name="orders" value="${orders!'CREATE_TIME.DESC'}">
			<input class="limit" type="hidden" name="limit" value="${limit!'10'}" >
			<input type="hidden" name="userId" value="${userId!}" >
			<input type="hidden" name="creator.id" value="${userId!}" >
			<input type="hidden" name="title" value="${(diary.title)!}">
			<div id="myCoursePage" class="m-laypage-jour"></div>
			<#if paginator??>
				<#import "../../../common/pagination_ajax.ftl" as p/>
				<@p.paginationAjaxFtl formId="listDiaryForm" divId="myCoursePage" paginator=paginator contentId="zoneContent"/>
			</#if>
		</form>
    </dd>  
</dl>
</@diariesDirective>  
<script>
$(function(){
	changeZoneItem('diary');
	
	//新增
    $(".u-btn-upload").on("click",function(){    
        mylayerFn.open({
	        type: 2,
	        title: '发表日志',
	        fix: false,
	        area: [900, 800],
	        content: '${ctx!}/userCenter/zone/diary/create',
	        shadeClose: true,
	        offset:[$(document).scrollTop()]
    	});
    });
    
    //修改
    $(".diary-alter").on("click",function(){
        mylayerFn.open({
        type: 2,
        title: '编辑日志',
        fix: false,
        area: [900, 800],
        content: '${ctx!}/userCenter/zone/diary/'+$(this).closest('li').attr('diaryId')+'/edit',
        shadeClose: true,
	    offset:[$(document).scrollTop()]
    	});
    });
    
    //查看具体日志
    $(".m-jou-tl").on("click",function(){
		$('#listDiaryForm').attr('action','${ctx!}/userCenter/zone/diary/'+$(this).closest('li').attr('diaryId')+'/view');
		$.ajaxQuery('listDiaryForm', 'zoneContent');
    });
    
    //改变顶置状态
    $(".diary-overhead").on("click",function(){
     	var diaryId = $(this).closest('li').attr('diaryId');
	 	confirm('确定取消顶置?', function(){
			$.post('${ctx!}/userCenter/zone/diary',{
				'_method':'PUT', 
				'id':diaryId,
				'isTop':'N'
			},function(response){
				if(response.responseCode == '00'){
					$('li[diaryId='+diaryId+']').find('.u-support').remove();
					alert('顶置已取消!');
				}
			});
		});
    });
    
    //修改分类
    $(".diary-category").on("click",function(){
 		mylayerFn.open({
	        type: 2,
	        title: '修改分类',
	        fix: false,
	        area: [700, 590],
	        content: '',
	        shadeClose: true,
	        offset:[$(document).scrollTop()]
    	});
    });
    
    //删除计划
    $(".diary-schedule").on("click",function(){
 		
    });
  
    //评论
    $(".u-user-com-cl").on("click",function(){
 		
    });
	
    //改变点赞状态
    $(".diary-support").on("click",function(){
 		var isSupport = $(this).find('i').hasClass('un-praise');
 		var diaryId = $(this).closest('li').attr('diaryId');
 		var $this = $(this);
 		//取消点赞
 		if(isSupport == true){
 			$.post('${ctx!}/attitudes',{
 				'attitude':'support',
				'relationId':diaryId,
				'_method':'DELETE' 
 			},function(response){
 				if(response.responseCode == '00'){
 					//点赞按钮改变
					$this.find('i').removeClass('un-praise');
					$('#supportText_'+diaryId).text('点赞');
					//日志数-1
					var count = $('.supportNum_'+diaryId).eq(0).text();
					$('.supportNum_'+diaryId).text(parseInt(count) - 1);
					alert('点赞已取消!');
				}
 			});
 		}else{//进行点赞
 			$.post('${ctx!}/attitudes',{
				'attitude':'support',
				'relation.id':diaryId,
				'relation.type':'zoneDiary'
			},function(response){
				if(response.responseCode == '00'){
					//点赞按钮改变
					$this.find('i').addClass('un-praise');
					$('#supportText_'+diaryId).text('取消赞');
					//日志数+1
					var count = $('.supportNum_'+diaryId).eq(0).text();
					$('.supportNum_'+diaryId).text(parseInt(count) + 1);
					alert('点赞成功!');
				}
			});
 		}
    });
    
    $('#searchContext').bind('keydown',function(event){
        if(event.keyCode == "13")    
        {
        	loadDiary();
        }
    });
    
});
    function loadDiary(){
    	$('#listDiaryForm input[name=title]').val($('#searchContext').val().trim());
    	$('#zoneContent').load('${ctx!}/userCenter/zone/diary?userId=${userId!}&title='+$('#searchContext').val().trim());
    };
</script>