package com.haoyu.usercenter.templates;

import java.io.IOException;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Component;

import com.github.miemiedev.mybatis.paginator.domain.PageBounds;
import com.github.miemiedev.mybatis.paginator.domain.PageList;
import com.google.common.collect.Maps;
import com.haoyu.ncts.utils.PageSplitUtils;
import com.haoyu.sip.gallery.entity.PhotoGallery;
import com.haoyu.sip.gallery.service.IPhotoGalleryService;

import freemarker.core.Environment;
import freemarker.template.DefaultObjectWrapper;
import freemarker.template.TemplateDirectiveBody;
import freemarker.template.TemplateDirectiveModel;
import freemarker.template.TemplateException;
import freemarker.template.TemplateModel;

@Component
public class PhotoGallerysDataDirective implements TemplateDirectiveModel{
	@Resource
	private IPhotoGalleryService photoGalleryService;

	@Override
	public void execute(Environment env, Map params, TemplateModel[] loopVars, TemplateDirectiveBody body) throws TemplateException, IOException {
		if(params.containsKey("userId") && params.get("userId")!=null){
			String userId = params.get("userId").toString();
			Map<String,Object> parameter = Maps.newHashMap();
			parameter.put("creatorId", userId);
			PageBounds pageBounds = PageSplitUtils.getPageBounds(params, env);
			List<PhotoGallery> photoGallerys = photoGalleryService.findPhotoGalleries(parameter,pageBounds);
			if (pageBounds != null && pageBounds.isContainsTotalCount()) {
				PageList pageList = (PageList) photoGallerys;
				env.setVariable("paginator", new DefaultObjectWrapper().wrap(pageList.getPaginator()));
			}
			env.setVariable("photoGallerys", new DefaultObjectWrapper().wrap(photoGallerys));
		}
		body.render(env.getOut());
	}

}
