package com.haoyu.usercenter.listener;

import java.util.List;

import javax.annotation.Resource;

import org.apache.commons.collections.CollectionUtils;
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
import com.haoyu.sip.message.entity.Message;
import com.haoyu.sip.message.service.IMessageService;
import com.haoyu.sip.message.utils.MessageType;
import com.haoyu.sip.utils.Collections3;
import com.haoyu.tip.resource.entity.Resources;
import com.haoyu.tip.resource.event.CreateResourceEvent;
import com.haoyu.usercenter.utils.DynamicFactory;

@Component
public class UCCreateResourceListener implements ApplicationListener<CreateResourceEvent> {

	@Resource
	private IDynamicService DynamicService;
	@Resource
	private IFollowService followService;
	@Resource
	private IMessageService messageService;

	@Override
	public void onApplicationEvent(CreateResourceEvent event) {
		Resources resources = (Resources) event.getSource();
		Dynamic dynamic = DynamicFactory.createDynamic(resources);
		if (dynamic != null) {
			Response response = DynamicService.create(dynamic);
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
					message.setContent("您关注的用户'"+ThreadContext.getUser().getRealName()+"'上传了资源:"+resources.getTitle());
					messageService.sendMessageToUsers(message, Collections3.extractToList(myfans, "creator.id"));
				}
			}
		}
	}

}
