package com.haoyu.usercenter.filter;


import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;

import org.apache.shiro.SecurityUtils;
import org.apache.shiro.subject.Subject;
import org.apache.shiro.web.filter.authz.AuthorizationFilter;

import com.haoyu.sip.follow.service.IFollowService;
import com.haoyu.sip.gallery.entity.PhotoGallery;
import com.haoyu.sip.gallery.service.IPhotoGalleryService;

public class PhotoFilter extends AuthorizationFilter{
	@Resource
	private IPhotoGalleryService photoGalleryService;
	@Resource
	private IFollowService followService;

	@Override
	protected boolean isAccessAllowed(ServletRequest request, ServletResponse response, Object mappedValue) throws Exception {
		Subject subject = SecurityUtils.getSubject();
		List<Object> listPrincipals = subject.getPrincipals().asList();
		Map<String, String> attributes = (Map<String, String>) listPrincipals.get(1);
		String userId = attributes.get("id");
		
		HttpServletRequest httpServletRequest =(HttpServletRequest) request;
		String url = httpServletRequest.getRequestURL().toString();
		String galleryId = httpServletRequest.getRequestURL().substring(url.lastIndexOf("/")+1);
		PhotoGallery ghotoGallery = photoGalleryService.findPhotoGalleryById(galleryId);
		if(userId.equals(ghotoGallery.getCreator().getId())){
			return true;
		}else{
			Subject currentUser = SecurityUtils.getSubject();
			if(!currentUser.hasRole("PHOTO_GALLERY_"+galleryId)){
				return false;
			}
			return true;
		}
		
	}
	

}
