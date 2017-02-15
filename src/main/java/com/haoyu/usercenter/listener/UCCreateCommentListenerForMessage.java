package com.haoyu.usercenter.listener;

import java.util.List;

import javax.annotation.Resource;

import org.apache.commons.lang3.StringUtils;
import org.apache.commons.logging.Log;
import org.springframework.context.ApplicationListener;
import org.springframework.stereotype.Component;

import com.haoyu.sip.comment.entity.Comment;
import com.haoyu.sip.comment.event.CreateCommentEvent;
import com.haoyu.sip.core.entity.User;
import com.haoyu.sip.core.utils.ThreadContext;
import com.haoyu.sip.diary.entity.Diary;
import com.haoyu.sip.diary.service.IDiaryService;
import com.haoyu.sip.dynamic.entity.Dynamic;
import com.haoyu.sip.gallery.entity.Photo;
import com.haoyu.sip.gallery.entity.PhotoGallery;
import com.haoyu.sip.gallery.service.IPhotoGalleryService;
import com.haoyu.sip.gallery.service.IPhotoService;
import com.haoyu.sip.message.entity.Message;
import com.haoyu.sip.message.service.IMessageService;
import com.haoyu.sip.message.utils.MessageType;
import com.haoyu.tip.resource.entity.Resources;
import com.haoyu.tip.schedule.entity.Schedule;
import com.haoyu.usercenter.dynamic.service.IDynamicBizService;
import com.haoyu.usercenter.utils.DynamicSourceType;
@Component
public class UCCreateCommentListenerForMessage implements ApplicationListener<CreateCommentEvent>{
	
	@Resource
	private IMessageService messageService;
	@Resource
	private IPhotoService photoService;
	@Resource
	private IDiaryService diaryService;
	@Resource
	private IDynamicBizService dynamicBizService;
	@Resource
	private IPhotoGalleryService photoGalleryService;
	@Override
	public void onApplicationEvent(CreateCommentEvent event) {
		Comment comment = (Comment) event.getSource();
		if(comment.getRelation()!= null){
			sendMessage(comment);
		}
	}
	
	@SuppressWarnings("rawtypes")
	private void sendMessage(Comment comment){
		if("photo".equals(comment.getRelation().getType())){
			//如果mainId为空，对实体评论
			if(StringUtils.isEmpty(comment.getMainId())){
				Photo photo = photoService.findPhotoById(comment.getRelation().getId());
				if(photo != null){
					if(!ThreadContext.getUser().getId().equals(photo.getCreator().getId())){
						Message message = new Message();
						message.setReceiver(new User(photo.getCreator().getId()));
						String photoName  = "";
						if(StringUtils.isNotEmpty(photo.getName())){
							photoName = photo.getName();
						}else{
							photoName = photo.getFileInfo().getFileName();
						}
						message.setSender(new User(this.getClass().getName()));
						message.setContent("您的相片'"+photoName+"'有新的评论:"+comment.getContent());
						message.setType(MessageType.SYSTEM_MESSAGE);
						messageService.createMessage(message);
					}
				}
			}else{
				//评论有新的回复
				
			}
		}else if("zoneDiary".equals(comment.getRelation().getType())){
			//如果mainId为空，对实体评论
			if(StringUtils.isEmpty(comment.getMainId())){
				Diary diary = diaryService.findDiaryById(comment.getRelation().getId());
				if(diary != null){
					if(!ThreadContext.getUser().getId().equals(diary.getCreator().getId())){
						Message message = new Message();
						message.setReceiver(new User(diary.getCreator().getId()));
						message.setContent("您的日志'"+diary.getTitle()+"'有新的评论:"+comment.getContent());
						message.setSender(new User(this.getClass().getName()));
						message.setType(MessageType.SYSTEM_MESSAGE);
						messageService.createMessage(message);
					}
				}
			}else{
				//评论有新的回复
				
			}
		}else if("dynamic".equals(comment.getRelation().getType())){
			//如果mainId为空，对实体评论
			if(StringUtils.isEmpty(comment.getMainId())){
				Dynamic dynamic = dynamicBizService.get(comment.getRelation().getId());
				if(dynamic != null){
					if(!ThreadContext.getUser().getId().equals(dynamic.getCreator().getId())){
						String content = "";
						try {
							if(DynamicSourceType.DIARY.equals(dynamic.getDynamicSourceType())){
								Diary diary = (Diary) dynamic.getDynamicSourceEntity();
								content = "发表日志'"+diary.getTitle()+"'";
							}else if(DynamicSourceType.GALLERY_PHOTO.equals(dynamic.getDynamicSourceType())){
								List photos = (List) dynamic.getDynamicSourceEntity();
								String galleryId = dynamic.getDynamicSourceRelation().getId();
								PhotoGallery photoGallery = photoGalleryService.findPhotoGalleryById(galleryId);
								content = "上传"+photos.size()+"张照片到"+photoGallery.getName();
							}else if(DynamicSourceType.RESOURCE.equals(dynamic.getDynamicSourceType())){
								Resources r = (Resources) dynamic.getDynamicSourceEntity();
								content = "上传资源"+r.getTitle();
							}else if(DynamicSourceType.SCHEDULE.equals(dynamic.getDynamicSourceType())){
								List<Schedule> schedules = (List) dynamic.getDynamicSourceEntity();
								StringBuffer sb = new StringBuffer();
								sb.append("添加计划：");
								for(Schedule s:schedules){
									sb.append(s.getTitle()+" ");
								}
								content = sb.toString();
							}
						} catch (Exception e) {
							
						}
						Message message = new Message();
						message.setReceiver(new User(dynamic.getCreator().getId()));
						message.setContent("您的动态:\""+content+"\"有新的评论:"+comment.getContent());
						message.setSender(new User(this.getClass().getName()));
						message.setType(MessageType.SYSTEM_MESSAGE);
						messageService.createMessage(message);
					}
				}
			}
			
		}
	}

}
