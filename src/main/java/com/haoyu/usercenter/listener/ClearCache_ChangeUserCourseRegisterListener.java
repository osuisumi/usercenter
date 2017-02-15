package com.haoyu.usercenter.listener;

import java.util.List;
import java.util.Map;
import java.util.Set;

import javax.annotation.Resource;

import org.springframework.context.ApplicationListener;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.stereotype.Component;

import com.google.common.collect.Lists;
import com.haoyu.ncts.course.event.ChangeUserCourseRegisterEvent;
import com.haoyu.sip.core.utils.PropertiesLoader;
import com.haoyu.sip.utils.Collections3;

@Component
public class ClearCache_ChangeUserCourseRegisterListener implements ApplicationListener<ChangeUserCourseRegisterEvent>{
	
	@Resource
	private RedisTemplate redisTemplate;
	
	@Override
	public void onApplicationEvent(ChangeUserCourseRegisterEvent event) {
		String key_prefix = PropertiesLoader.get("redis.app.key") + ":userCenterProgess:";
		Map<String, Object> map = (Map<String, Object>) event.getSource();
		if(map.containsKey("userIds")){
			List<String> userIds = (List<String>) map.get("userIds");
			if (Collections3.isNotEmpty(userIds)) {
				for (String userId : userIds) {
					Set<String> keys = redisTemplate.keys(key_prefix + userId + ":*");
					redisTemplate.delete(keys);
				}
			}
		}
	}
}
