<#include "/ncts/make/include/layout.ftl"/>
<@layout>
	<@courseDirective id=course.id>
		<#assign course=courseModel>
	</@courseDirective>
	<div id="g-bd">
	    <div class="addCoursePage">
	        <div class="g-innerAuto g-addCourse-cont">
	            <div class="g-addcourse-dt">
	                <div class="g-crm c1">
	                    <span>当前位置：</span>
	                    <a href="/ncts/index" title="首页" class="">首页</a>
	                    <span class="line">&gt;</span>
	                    <strong>${course.title } - 分支列表</strong>
	                </div>  
	                <@coursesDirective listMode=(listMode[0])!'' sourceId=course.id isTemplate='N' courseAuthorizeUserId=ThreadContext.getUser().id courseAuthorizeRole="maker" page=(pageBounds.page)!1 limit=(pageBounds.limit)!12 orders='CREATE_TIME.DESC' >
		                <#assign courses=courses>
							<#assign trainIds = []>
							<#list courses as course>
								<#if '' != (course.courseRelation.relation.id)!''>
									<#assign trainIds = trainIds + [course.courseRelation.relation.id]>
								</#if>
							</#list>
					</@coursesDirective>
					<#if (trainIds?size>0)>
						<@trainMapDirective ids=trainIds>
							<#assign trainMap=trainMap>
						</@trainMapDirective>
					</#if>
	                <div class="g-courseList-bd">
	                    <div class="g-clist-optRow">                                
	                        <div class="m-clist-tabli">
	                            <a href="javascript:void(0);" class="z-crt m-clist-inner">共计<span>${paginator.totalCount }</span>个分支<i class="trg"></i></a>
	                        </div>                              
	                        <div id="listModeBtn" class="m-viewMode">
                                <a listMode="list" class="u-view-list z-crt" title="列表模式"><i class="u-viewL-ico"></i></a>
                                <a listMode="flat" class="u-view-tiled" title="平铺模式"><i class="u-viewT-ico"></i></a>
                            </div>
                            <script>
                            	$(function(){
                            		$('#listModeBtn a').click(function(){
                            			var index = $('#listModeBtn a').index($(this));
                            			$('#listModeBtn a').removeClass('z-crt');
                            			$(this).addClass('z-crt');
                            			$('.courseUl').hide();
                            			$('.courseUl').eq(index).show();
                            			$('#listModeParam').val($(this).attr('listMode'));
                            			initUpload();
                            		});
                            		if('${listMode!}' == 'flat'){
                            			$('#listModeBtn a').eq(1).trigger('click');
                            		}
                            	});
                            </script>
	                    </div>
	                    <div class="g-clist-tabcon">
	                        <div class="g-clist-cont">
	                        	<#if (courses?size > 0)>
		                            <ul class="g-myCourse-lst courseUl">
		                            	<#list courses as course>	
			                                <li class="m-fig-viewList unissue">
			                                    <a href="javascript:void(0);" class="figure picker picker_${course.id! }" courseId="${course.id! }">
			                                        <#import "/common/image.ftl" as image/>
													<@image.imageFtl url="${course.image! }" default="${app_path }/images/uploadCourseImg.png" />
			                                    </a>
			                                    <h3 class="tt"><a href="javascript:void(0);">${course.title!}</a></h3>
			                                    <p>
			                                        <i class="u-sList-ico"></i>
		                                            <span class="txt">${course.code!}</span>
		                                            <span class="link">/</span>
		                                            <span class="txt">${course.termNo!}</span>
			                                    </p>
			                                    <!-- <p><i class="u-sTime-ico"></i><span class="txt">开课时间: 2015/12/12</span></p> -->
			                                    <div class="tagRow">
		                                            <span class="u-cTag type1">${course.organization!}</span>
		                                            <span class="u-cTag type1">
		                                            	<#if course.type == 'lead'>
															引领式
															<#elseif course.type == 'mic'>
															微课
															<#else>
															自主式
														</#if>
		                                            </span>
		                                            <span class="u-cTag type2">
		                                            	<#if course.state == 'editing'>
															未发布
															<#elseif course.state == 'pass'>
															已发布
															<#elseif course.state == 'published'>
															待审核
															<#else> 
															未通过
														</#if>
		                                            </span>
		                                        </div>
			                                    <div class="optRow">
			                                    	<#if SecurityUtils.getSubject().hasRole('course_maker_${course.id}') && (course.state != 'pass' || course.type == 'lead')>
			                                    		<a onclick="editCourseConfig('${course.id}')" class="u-opt u-setting"><i class="u-setting-ico"></i><span class="tip">设置</span></a>
			                                            <a onclick="previewCourse('${course.id}')" href="javascript:void(0);" class="u-opt u-view"><i class="u-view-ico"></i><span class="tip">预览</span></a>
			                                            <!-- <a onclick="editCourse('${course.id}')" href="javascript:void(0);" class="u-opt u-alter"><i class="u-alter-ico"></i><span class="tip">编辑</span></a> -->
			                                            <#if course.type == 'lead'>
			                                            	<a onclick="editCourseContent('${course.id}')" href="javascript:void(0);" class="u-opt u-alter"><i class="u-alter-ico"></i><span class="tip">编辑</span></a>
			                                            <#else>
			                                            	<#if (!TimeUtils.hasBegun((course.timePeriod.startTime)!'', (trainMap[course.courseRelation.relation.id].trainingTime.startTime)!'')) || course.state != 'pass'>
					                                            <a onclick="editCourseContent('${course.id}')" href="javascript:void(0);" class="u-opt u-alter"><i class="u-alter-ico"></i><span class="tip">编辑</span></a>
					                                        </#if>
			                                            </#if>
			                                            <#if course.state! == 'editing' || course.state! == 'reject'>
			                                            	<a onclick="publishCourse('${course.id}')" href="javascript:void(0);" class="u-opt u-issue"><i class="u-issue-ico"></i><span class="tip">发布</span></a>
			                                            </#if>
			                                    	</#if>
		                                        </div>
			                                </li>
			                        	</#list>
		                            </ul>
		                            <ul class="courseUl g-fig-tiled" style="display:none;">
										<#list courses as course>	
	                                        <li>
	                                            <div class="m-fig-tiled unissue">
	                                                <a courseId="${course.id! }" href="javascript:void(0);" class="figure picker picker_${course.id! }">
	                                                    <#import "/common/image.ftl" as image/>
														<@image.imageFtl url="${course.image! }" default="/ncts/images/uploadCourseImg.png" />
	                                                    <span></span>
	                                                </a>
	                                                <h3 class="tt"><a href="javascript:void(0);">${course.title!}</a></h3>
	                                                <div class="tagRow">
	                                                    <span class="u-cTag type1">${course.organization!}</span>
	                                                    <span class="u-cTag type1">
	                                                    	<#if course.type == 'lead'>
																引领式
																<#elseif course.type == 'mic'>
																微课
																<#else>
																自主式
															</#if>
	                                                    </span>
	                                                    <span class="u-cTag type2">
	                                                    	<#if course.state == 'editing'>
																未发布
																<#elseif course.state == 'pass'>
																已发布
																<#elseif course.state == 'published'>
																待审核
																<#else> 
																未通过
															</#if>
	                                                    </span>
	                                                </div>
	                                                <div class="optRow">
	                                                	<#if SecurityUtils.getSubject().hasRole('course_maker_${course.id}') && (course.state != 'pass' || course.type == 'lead')>
		                                                    <a onclick="editCourseConfig('${course.id}')" href="###" class="u-opt u-setting"><i class="u-setting-ico"></i><span class="tip">设置</span></a>
		                                                    <span class="line">|</span>
		                                                    <a onclick="previewCourse('${course.id}')" href="javascript:void(0);" class="u-opt u-view"><i class="u-view-ico"></i><span class="tip">预览</span></a>
		                                                    <span class="line">|</span>
		                                                    <#if course.type == 'lead'>
				                                            	<a onclick="editCourseContent('${course.id}')" href="javascript:void(0);" class="u-opt u-alter"><i class="u-alter-ico"></i><span class="tip">编辑</span></a>
				                                            <#else>
				                                            	<#if (!TimeUtils.hasBegun((course.timePeriod.startTime)!'', (trainMap[course.courseRelation.relation.id].trainingTime.startTime)!'')) || course.state != 'pass'>
						                                            <a onclick="editCourseContent('${course.id}')" href="javascript:void(0);" class="u-opt u-alter"><i class="u-alter-ico"></i><span class="tip">编辑</span></a>
						                                        </#if>
				                                            </#if>
		                                                    <#if course.state! == 'editing' || course.state! == 'reject'>
		                                                    	<span class="line last">|</span>
		                                                   		<a onclick="publishCourse('${course.id}')" href="javascript:void(0);" class="u-opt u-issue"><i class="u-issue-ico"></i><span class="tip">发布</span></a>
		                                                    </#if>
		                                                </#if>
	                                                </div>    
	                                            </div>
	                                        </li>
	                                	</#list>
                                    </ul>
                                    <form id="listCourseForm" action="${ctx}/make/course">	
										<input type="hidden" name="id" value="${course.id}">
										<input id="listModeParam" type="hidden" name="listMode" value="${listMode! }">
	                                    <div id="myCoursePage" class="m-laypage"></div>
	                                    <#import "/common/pagination.ftl" as p/>
										<@p.paginationFtl formId="listCourseForm" divId="myCoursePage" paginator=paginator />
									</form>
								<#else>	
									<div class="g-noContent">
							            <p>此课程没有您可以操作的分支</p>
							        </div>
								</#if>
	                        </div>    
	                    </div>
	                </div>
	            </div>
	        </div>
	    </div>
	</div>
    <input id="previewId" type="hidden">
</@layout>
<script>
	$(function(){
		$('.picker').click(function(){
			$('#previewId').val($(this).attr('courseId'));
		});
		
		initUpload();
	});

	function initUpload(){
		var uploader = WebUploader.create({
    		swf : $('#ctx').val() + '/js/webuploader/Uploader.swf',
    		server : '${ctx}/file/uploadFileInfoRemote',
    		pick : '.picker',
    		resize : true,
    		duplicate : true,
    		accept : {
    		    extensions: 'jpg,jpeg,png'
    		}
    	});
    	// 当有文件被添加进队列的时候
    	uploader.on('fileQueued', function(file) {
    		uploader.upload();
    	});
    	// 文件上传过程中创建进度条实时显示。
    	uploader.on('uploadProgress', function(file, percentage) {
    		
    	});
    	uploader.on('uploadSuccess', function(file, response) {
    		if (response != null && response.responseCode == '00') {
   				var fileInfo = response.responseData;
   				$('.picker_'+$('#previewId').val()+' img').attr('src', '${FileUtils.getFileUrl("")}'+fileInfo.url);
   				$.put('${ctx}/make/course/'+$('#previewId').val(), '&image='+fileInfo.url);
    		}
    	});
    	uploader.on('uploadError', function(file) {
    		$('#' + file.id).find('.fileBar').addClass('error');
    		$('#' + file.id).find('.barTxt').text('上传出错');
    	});
    	uploader.on('error', function(type) {
    		if (type == 'Q_TYPE_DENIED') {
    			alert('不支持该类型的文件');
    		}
    	});
	}
	
	function goCreateCourse(){
		mylayerFn.open({
            type: 2,
            title: '创建课程',
            fix: false,
            area: [720, 580],
            content: '${ctx}/make/course/create',
            shadeClose: true
        });
	}
	
	function goCourseRecycle(){
		window.location.href = '${ctx}/make/course/course_recycle?isDeleted=Y&orders=CREATE_TIME.DESC';
	}
	
	function listCourse(state){
		$('#listCourseForm #stateParam').val(state);
		$('#listCourseForm #currentPage').val(1);
		$('#listCourseForm').submit();
	}
	
	function editCourse(id){
		window.location.href = '${ctx}/'+id+'make/course/'+id+'/edit';
	}
	
	function deleteCourse(id){
		confirm('确定要把该课程放入回收站吗?', function(){
			$.ajaxDelete('${ctx}/make/course/deleteByLogic', 'id='+id, function(data){
				if(data.responseCode == '00'){
					alert('已放入回收站',function(){
						window.location.reload();
					});
				}	
			});
		});
	}
	
	function publishCourse(id){
		confirm('确定要发布该课程吗?', function(){
			$.put('${ctx}/make/course/'+id, 'state=published', function(data){
				if(data.responseCode == '00'){
					alert('发布成功',function(){
						window.location.reload();
					});
				}	
			});
		});
	}
	
	function editCourseContent(id){
		window.location.href = '${ctx}/make/course/'+id+'/editCourseContent';
	}
	
	function editCourseConfig(id){
		window.location.href = '${ctx}/make/course/'+id+'/editCourseConfig';
	}
	
	function previewCourse(id){
		window.open('${ctx}/make/course/'+id+'/preview');
	}
	
	function listCourseBranch(id){
		window.location.href = '${ctx}/make/course/'+id+'/listCourseBranch';
	}
</script>