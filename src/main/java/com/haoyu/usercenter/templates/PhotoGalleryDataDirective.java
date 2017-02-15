package com.haoyu.usercenter.templates;

import java.io.IOException;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Component;

import com.haoyu.sip.gallery.entity.PhotoGallery;
import com.haoyu.sip.gallery.service.IPhotoGalleryService;

import freemarker.core.Environment;
import freemarker.template.DefaultObjectWrapper;
import freemarker.template.TemplateDirectiveBody;
import freemarker.template.TemplateDirectiveModel;
import freemarker.template.TemplateException;
import freemarker.template.TemplateModel;
@Component
public class PhotoGalleryDataDirective implements TemplateDirectiveModel{
	@Resource
	private IPhotoGalleryService photoGalleryService;
	
	@Override
	public void execute(Environment env, Map params, TemplateModel[] loopVars, TemplateDirectiveBody body) throws TemplateException, IOException {
		if(params.containsKey("id")){
			PhotoGallery photoGallery = photoGalleryService.findPhotoGalleryById(params.get("id").toString());
			env.setVariable("photoGallery", new DefaultObjectWrapper().wrap(photoGallery));
		}
		body.render(env.getOut());
		
	}

}
