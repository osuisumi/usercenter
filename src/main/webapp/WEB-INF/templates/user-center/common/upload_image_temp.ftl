<#macro uploadImageTempFtl relationId relationType="" paramName="fileInfos" paramType="list" divId="fileDiv" btnTxt="上传文件" fileNumLimit=0 fileTypeLimit="" uploadWhere="uploadFileInfoRemote">
	<style>
	.uploadImg-block{display: inline-block; position: relative; z-index: 11;}
	.uploadImg-block:hover a {display: inline-block;}
	.uploadImg-block a {display: none; position: absolute; top: -7px; right: -7px; width: 14px; height: 14px; border-radius: 50%; background-color: red; text-align: center; line-height: 14px; color:#fff;}
	</style>
	<#if relationId != ''>
		<script>
			$.get('/file','relationId=${relationId}&relationType=${relationType}',function(data) {
				if (data != null) {
					$.each(data,function(i, tag) {
						var $li = $('#fileLiTemplet').clone();
						$li.addClass('success').attr('fileId', this.id).show();
						$li.find('.fileName').text(this.fileName);
						$li.find('.fileBar').remove();
						$('#${divId}').find(".fileList").append($li);
					});
					initFileParam('${divId}', '${paramName}');
				}
			});
		</script>
	</#if>
	<ul class="fileList f-cb">
		<li id="fileLiTemplet" class="fileLi" style="display: none; float: left; margin-right: 15px;">
			<i class="fileIcon"></i>
			<a class="fileName txt"></a>
			<div class="fileBar sche" style="float: left;">
				<div class="bl"><div class="barLength bs" role="progressbar" style="width: 0%"></div></div>
				<span class="barNum num"></span><span class="barTxt status"></span>
			</div>
			<!--<a class="deleteBtn dlt">×</a>-->
		</li>
	</ul>
	<div>
		<a class="l-btn picker" style="margin-bottom: 10px"><span>${btnTxt }</span></a> 
		<span class="help-block">仅支持JPG、JPEG、PNG格式（2M以下）</span>
	</div>
    <script>
    	$(function(){
    		var uploader = WebUploader.create({
        		swf : $('#ctx').val() + '/js/webuploader/Uploader.swf',
        		server : '${ctx}/file/${uploadWhere}',
        		pick : '#${divId} .picker',
        		resize : true,
        		duplicate : true,
        		accept : {
        		    extensions: '${fileTypeLimit!}'
        		}
        	});
        	// 当有文件被添加进队列的时候
        	uploader.on('fileQueued', function(file) {
        		var fileNumLimit = parseInt('${fileNumLimit}');
        		if(fileNumLimit != 0){
        			var fileNum = $('#${divId}').find('.fileList').find(".fileLi").length;
            		if(fileNum > fileNumLimit){
            			alert('只允许上传'+fileNumLimit+'个附件');
            			uploader.removeFile(file.id);
            			return false;
            		}
        		}
        		var $li = $('#fileLiTemplet').clone();
        		$li.attr('id', file.id).addClass('fileItem').show();
        		//$li.find('.fileName').text(file.name);
        		$('#${divId}').find(".fileList").append($li);
			    $li.append('<span class="uploadImg-block"><img src="" width="100" height="100" /><a class="deleteBtn" href="javascript:;">×</a></span>');    
			    // 创建缩略图
			    uploader.makeThumb( file, function( error, src ) {
			    	$img = $('#'+file.id).find('img');
			        if ( error ) {
			            $img.replaceWith('<span>不能预览</span>');
			            return;
			        }
			        $img.attr( 'src', src );
			    });
        		uploader.upload();
        	});
        	// 文件上传过程中创建进度条实时显示。
        	uploader.on('uploadProgress', function(file, percentage) {
        		//var $li = $('#' + file.id), $bar = $li.find('.fileBar');
        		// 避免重复创建
        		/* if (!$percent.length) {
        			$li.find('.state').html('<div class="sche">' + '<div class="bl">' + '<div class="bs" role="progressbar" style="width: 0%"></div>' + '</div>' + '<span class="num">' + '0%' + '</span>' + '<span class="status"></span>' + '</div>');
        			$percent = $li.find('.sche');
        		} */
        		//var progress = Math.round(percentage * 100);
        		//$bar.find('.barLength').css('width', progress + '%');
        		//$bar.find('.barNum').text(progress + '%');
        		//$bar.find('.barTxt').text('上传中');
        	});
        	uploader.on('uploadSuccess', function(file, response) {
        		if (response != null && response.responseCode == '00') {
        			//$('#' + file.id).find('.fileBar').addClass('finish');
        			//$('#' + file.id).find('.barTxt').text('已上传');
        			var fileInfo = response.responseData;
        			$('#' + file.id).attr('fileId', fileInfo.id);
        			$('#' + file.id).attr('url', fileInfo.url);
        			$('#' + file.id).attr('fileName', fileInfo.fileName);
        			$('#' + file.id).addClass('success');
        			initFileParam('${divId}', '${paramName}');
        		}
        	});
        	uploader.on('uploadError', function(file) {
        		$('#' + file.id).find('.fileBar').addClass('error');
        		$('#' + file.id).find('.barTxt').text('上传出错');
        	});
        	uploader.on('uploadComplete', function(file) {
        		$('#' + file.id).find('.progress').fadeOut();
        	});
        	
//        	$('#uploadBtn').click(function() {
//        		uploader.upload();
//        	});
        	$('#${divId}').find(".fileList").on('click', '.deleteBtn', function() {
        		var _this = $(this);
        		confirm('是否确定删除该附件?',function(){
        			if ($(this).parents('.fileLi').hasClass('fileItem')) {
        				uploader.removeFile($(this).parents('.fileLi').attr('id'));
        			}
        			_this.parents('.fileLi').remove();
        			initFileParam('${divId}', '${paramName}');
        		});
        	});
        	uploader.on('error', function(type) {
        		if (type == 'Q_TYPE_DENIED') {
        			alert('请检查上传的文件类型');
        		}
        	}); 
    	});
	
	    function initFileParam(divId, paramName) {
	    	var $list = $('#'+divId).find(".fileList");
	    	$list.find('.fileParam').remove();
	    	$list.find('.fileLi.success').each(function(i) {
	    		var fileId = $(this).attr('fileId');
	    		var fileName = $(this).attr('fileName');
	    		var url = $(this).attr('url');
	    		if('${paramType}' == 'entity'){
	    			$(this).append('<input class="fileParam" name="'+paramName+'.id" value="' + fileId + '" type="hidden"/>');
		    		$(this).append('<input class="fileParam" name="'+paramName+'.fileName" value="' + fileName + '" type="hidden"/>');
		    		$(this).append('<input class="fileParam" name="'+paramName+'.url" value="' + url + '" type="hidden"/>');
	    		}else{
	    			$(this).append('<input class="fileParam" name="'+paramName+'[' + i + '].id" value="' + fileId + '" type="hidden"/>');
		    		$(this).append('<input class="fileParam" name="'+paramName+'[' + i + '].fileName" value="' + fileName + '" type="hidden"/>');
		    		$(this).append('<input class="fileParam" name="'+paramName+'[' + i + '].url" value="' + url + '" type="hidden"/>');
	    		}
	    	});
	    	initFileType($list);
	    }
	    
	    function initFileType(obj){
	    	var $file_name_par = obj.find(".fileLi");
	    	$file_name_par.each(function(){
	    		var _ts = $(this);
	    		var $names = _ts.find(".fileName").text(); //文件名字
	            var $file_ico = _ts.find(".fileIcon");
	            var strings = $names.split(".");
	            var s_length = strings.length;
	            var suffix = strings[s_length -1];
	            if(s_length == 1){
	               
	            }else {
	                if(suffix == "doc" || suffix == "docx"){
	                	$file_ico.addClass("doc");
	                }else if(suffix == "xls" || suffix == "xlsx"){
	                	$file_ico.addClass("excel");
	                }else if(suffix == "ppt" || suffix == "pptx"){
	                	$file_ico.addClass("ppt");
	                }else if(suffix == "pdf"){
	                	$file_ico.addClass("pdf");
	                }else if(suffix == "txt"){
	                	$file_ico.addClass("txt");
	                }else if(suffix == "zip" || suffix == "rar"){
	                	$file_ico.addClass("zip");
	                }else if(suffix == "jpg" || suffix == "jpeg" || suffix == "png" || suffix == "gif"){
	                	$file_ico.addClass("pic");
	                }else if(
	                    suffix == "mp4" || 
	                    suffix == "avi" || 
	                    suffix == "rmvb" || 
	                    suffix == "rm" || 
	                    suffix == "asf" || 
	                    suffix == "divx" || 
	                    suffix == "mpg" || 
	                    suffix == "mpeg" || 
	                    suffix == "mpe" || 
	                    suffix == "wmv" || 
	                    suffix == "mkv" || 
	                    suffix == "vob" || 
	                    suffix == "3gp"
	                    ){
	                	$file_ico.addClass("video");
	                }else {
	                	$file_ico.addClass("other");
	                }
	            }
	    	});
	    }
    </script>
</#macro>