package com.haoyu.usercenter.dynamic.handler;

import java.util.Arrays;
import java.util.Comparator;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.commons.collections.CollectionUtils;
import org.apache.shiro.SecurityUtils;
import org.apache.shiro.subject.Subject;
import org.springframework.stereotype.Component;

import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import com.haoyu.sip.core.utils.ThreadContext;
import com.haoyu.sip.dynamic.entity.Dynamic;
import com.haoyu.sip.gallery.entity.Photo;
import com.haoyu.sip.gallery.service.IPhotoService;
import com.haoyu.sip.utils.Collections3;
import com.haoyu.usercenter.dynamic.DynamicSourceEntityHandler;
import com.haoyu.usercenter.utils.DynamicSourceType;
@Component
public class GalleryPhotoHandler extends DynamicSourceEntityHandler {
	@Resource
	private IPhotoService photoService;
	
	@Override
	public Map<String, Object> getSelectParameterMap() {
		Subject subject = SecurityUtils.getSubject();
		List<String> hasNoPermissionGalleryIds = (List<String>) subject.getSession().getAttribute(ThreadContext.getUser().getId() + "_hasNoPermissionGalleryIds");
		if(CollectionUtils.isNotEmpty(hasNoPermissionGalleryIds)){
			Map<String,Object> result = Maps.newHashMap();
			result.put("dynamicSourceRelationIdExlution", hasNoPermissionGalleryIds);
			return result;
		}
		return null;
	}



	@Override
	public void setDynamicSourceEntity(Map<String, List<Dynamic>> typeMap) {
		List<Dynamic> PhotoDynamics = typeMap.get(DynamicSourceType.GALLERY_PHOTO);
		if (CollectionUtils.isNotEmpty(PhotoDynamics)) {
			// List<Dynamic> hasPermissionPhotoDynamics = photoFilter(PhotoDynamics);
			List<Dynamic> hasPermissionPhotoDynamics = PhotoDynamics;
			if (CollectionUtils.isNotEmpty(hasPermissionPhotoDynamics)) {
				Map<String, Object> parameter = Maps.newHashMap();
				List<String> photoIds = Lists.newArrayList();
				for (Dynamic d : hasPermissionPhotoDynamics) {
					photoIds.addAll(Arrays.asList(d.getDynamicSourceId().split(",")));
				}
				parameter.put("ids", photoIds);
				List<Photo> photos = photoService.findPhotoByParameter(parameter, null);
				if (!CollectionUtils.isEmpty(photos)) {
					Map<String, Photo> resultPhotoMap = Collections3.extractToMap(photos, "id", null);
					for (Dynamic d : hasPermissionPhotoDynamics) {
						List<Photo> dynamicSourceEntity = Lists.newArrayList();
						for (String photoId : Arrays.asList(d.getDynamicSourceId().split(","))) {
							if (resultPhotoMap.containsKey(photoId)) {
								dynamicSourceEntity.add(resultPhotoMap.get(photoId));
								Comparator<Photo> c = new Comparator<Photo>() {
									@Override
									public int compare(Photo o1, Photo o2) {
										return new Long(o2.getCreateTime() - o1.getCreateTime()).intValue();
									}
								};
								dynamicSourceEntity.sort(c);
								d.setDynamicSourceEntity(dynamicSourceEntity);
							}
						}
					}
				}
			}
		}

	}

}
