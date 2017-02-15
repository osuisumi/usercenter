package com.haoyu.usercenter.templates;

import java.io.IOException;
import java.util.Arrays;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.commons.lang3.StringUtils;
import org.springframework.stereotype.Component;

import com.github.miemiedev.mybatis.paginator.domain.PageBounds;
import com.github.miemiedev.mybatis.paginator.domain.PageList;
import com.google.common.collect.Maps;
import com.haoyu.ncts.utils.PageSplitUtils;
import com.haoyu.sip.gallery.entity.Photo;
import com.haoyu.sip.gallery.entity.PhotoGallery;
import com.haoyu.sip.gallery.service.IPhotoGalleryService;
import com.haoyu.sip.gallery.service.IPhotoService;

import freemarker.core.Environment;
import freemarker.template.DefaultObjectWrapper;
import freemarker.template.TemplateDirectiveBody;
import freemarker.template.TemplateDirectiveModel;
import freemarker.template.TemplateException;
import freemarker.template.TemplateModel;

@Component
public class PhotoGalleryPhotosDataDirective implements TemplateDirectiveModel{
	@Resource
	private IPhotoService photoService;
	@Resource
	private IPhotoGalleryService pgotoGalleryService;
	@Override
	public void execute(Environment env, Map params, TemplateModel[] loopVars, TemplateDirectiveBody body) throws TemplateException, IOException {
		if(params.containsKey("galleryId")&&params.get("galleryId")!=null){
			Map<String,Object> parameter = Maps.newHashMap();
			PageBounds pageBounds = PageSplitUtils.getPageBounds(params, env);
			String galleryId =  params.get("galleryId").toString();
			parameter.put("galleryId", galleryId);
			if(params.containsKey("photoIds")){
				String photoIds = params.get("photoIds").toString();
				if(StringUtils.isNotEmpty(photoIds)){
					parameter.put("ids",Arrays.asList(photoIds.split(",")));
				}
			}
			List<Photo> photos = photoService.findPhotoByParameter(parameter, pageBounds);
			//List<Photo> allPhotos = photoService.findPhotoByGallery(galleryId, null);
			PhotoGallery photoGallery = pgotoGalleryService.findPhotoGalleryById(galleryId);
			if (pageBounds != null && pageBounds.isContainsTotalCount()) {
				PageList pageList = (PageList) photos;
				env.setVariable("paginator", new DefaultObjectWrapper().wrap(pageList.getPaginator()));
			}
			env.setVariable("photos", new DefaultObjectWrapper().wrap(photos));
			//env.setVariable("allPhotos", new DefaultObjectWrapper().wrap(allPhotos));
			env.setVariable("photoGallery", new DefaultObjectWrapper().wrap(photoGallery));
			
		}
		body.render(env.getOut());
		
	}

}
