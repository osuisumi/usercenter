package com.haoyu.usercenter.listener;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.lang3.StringUtils;
import org.springframework.context.ApplicationListener;
import org.springframework.stereotype.Component;

import com.haoyu.sip.core.entity.Relation;
import com.haoyu.sip.core.entity.User;
import com.haoyu.sip.core.service.Response;
import com.haoyu.sip.core.utils.ThreadContext;
import com.haoyu.sip.dynamic.entity.Dynamic;
import com.haoyu.sip.dynamic.service.IDynamicService;
import com.haoyu.sip.follow.entity.Follow;
import com.haoyu.sip.follow.service.IFollowService;
import com.haoyu.sip.gallery.entity.Photo;
import com.haoyu.sip.gallery.entity.PhotoGallery;
import com.haoyu.sip.gallery.event.AddPhotosToGalleryEvent;
import com.haoyu.sip.gallery.service.IPhotoGalleryService;
import com.haoyu.sip.message.entity.Message;
import com.haoyu.sip.message.service.IMessageService;
import com.haoyu.sip.message.utils.MessageType;
import com.haoyu.sip.utils.Collections3;
import com.haoyu.usercenter.utils.DynamicFactory;

@Component
public class AddPhotosToGalleryListener implements ApplicationListener<AddPhotosToGalleryEvent>{
	@Resource
	private IDynamicService dynamicService;
	@Resource
	private IFollowService followService;
	@Resource
	private IMessageService messageService;
	@Resource
	private IPhotoGalleryService photoGalleryService;

	@Override
	public void onApplicationEvent(AddPhotosToGalleryEvent event) {
		Map<String,Object> source = (Map<String, Object>) event.getSource();
		String galleryId = source.get("id").toString();
		PhotoGallery photoGallery = photoGalleryService.findPhotoGalleryById(galleryId);
		List<Photo> photos = (List<Photo>) source.get("photos");
		if(StringUtils.isNotEmpty(galleryId) && CollectionUtils.isNotEmpty(photos)){
			Dynamic dynamic = DynamicFactory.createDynamic(photos, galleryId);
			Response response = dynamicService.create(dynamic);
			if(response.isSuccess()){
				//通知我的粉丝，我有新的计划动态
				Follow follow = new Follow();
				Relation relation = new Relation();
				relation.setId(ThreadContext.getUser().getId());
				relation.setType("user_center_user");
				follow.setFollowEntity(relation);
				List<Follow> myfans = followService.findFollowByFollow(follow, null);
				if(CollectionUtils.isNotEmpty(myfans)){
					Message message = new Message();
					message.setSender(new User(this.getClass().getName()));
					message.setType(MessageType.SYSTEM_MESSAGE);
					message.setContent("您关注的用户'"+ThreadContext.getUser().getRealName()+"'上传了"+photos.size()+"张图片到相册:"+photoGallery.getName());
					messageService.sendMessageToUsers(message, Collections3.extractToList(myfans, "creator.id"));
				}
			}
		}
		
	}

}
