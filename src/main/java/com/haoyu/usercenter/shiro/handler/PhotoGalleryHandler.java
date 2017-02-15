package com.haoyu.usercenter.shiro.handler;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.commons.collections.CollectionUtils;
import org.apache.shiro.SecurityUtils;
import org.apache.shiro.authz.SimpleAuthorizationInfo;
import org.apache.shiro.subject.PrincipalCollection;
import org.apache.shiro.subject.Subject;

import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import com.haoyu.sip.auth.realm.IAuthRealmHandler;
import com.haoyu.sip.core.entity.Relation;
import com.haoyu.sip.follow.entity.Follow;
import com.haoyu.sip.follow.service.IFollowService;
import com.haoyu.sip.gallery.entity.PhotoGallery;
import com.haoyu.sip.gallery.service.IPhotoGalleryService;
import com.haoyu.sip.utils.Collections3;
import com.haoyu.usercenter.zone.gallery.utils.PhotoGalleryPrivacyType;

public class PhotoGalleryHandler implements IAuthRealmHandler {

	@Resource
	private IPhotoGalleryService photoGalleryService;
	@Resource
	private IFollowService followService;

	@Override
	public void addAuthorize(SimpleAuthorizationInfo info, PrincipalCollection principals) {
		Subject subject = SecurityUtils.getSubject();
		List<Object> listPrincipals = subject.getPrincipals().asList();
		Map<String, String> attributes = (Map<String, String>) listPrincipals.get(1);
		String userId = attributes.get("id");
		
		Relation relation = new Relation(userId);
		relation.setType("user_center_user");
		Follow follow = new Follow();
		follow.setFollowEntity(relation);
		List<Follow> myFans = followService.findFollowByFollow(follow, null);
		List<String> fanIds = Collections3.extractToList(myFans, "creator.id");
		List<PhotoGallery> photoGallerys = photoGalleryService.findPhotoGalleries(Maps.newHashMap(), null);
		// 我自己的有权限 我粉丝的对我开放的我也有权限 公开的有权限
		List<String> hasNoPermissionGalleryIds = Lists.newArrayList();
		for (PhotoGallery pg : photoGallerys) {
			if (userId.equals(pg.getCreator().getId())) {
				info.addRole("PHOTO_GALLERY_" + pg.getId());
			} else if (PhotoGalleryPrivacyType.ALL.equals(pg.getPrivacy())) {
				info.addRole("PHOTO_GALLERY_" + pg.getId());
			} else if (PhotoGalleryPrivacyType.MY_FOLLOW_ONLY.equals(pg.getPrivacy())) {
				if (CollectionUtils.isNotEmpty(fanIds) && fanIds.contains(pg.getCreator().getId())) {
					info.addRole("PHOTO_GALLERY_" + pg.getId());
				}else{
					hasNoPermissionGalleryIds.add(pg.getId());
				}
			}else if(PhotoGalleryPrivacyType.MYSELF_ONLY.equals(pg.getPrivacy())){
				hasNoPermissionGalleryIds.add(pg.getId());
			}
		}
		
		subject.getSession().setAttribute(userId + "_hasNoPermissionGalleryIds", hasNoPermissionGalleryIds);
	}

}
