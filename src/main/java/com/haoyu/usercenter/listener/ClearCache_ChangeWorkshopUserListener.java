package com.haoyu.usercenter.listener;

import java.util.List;
import java.util.Map;
import java.util.Set;

import javax.annotation.Resource;

import org.apache.commons.collections.CollectionUtils;
import org.springframework.context.ApplicationListener;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.stereotype.Component;

import com.haoyu.sip.core.utils.PropertiesLoader;
import com.haoyu.wsts.workshop.event.ChangeWorkshopUserEvent;

@Component
public class ClearCache_ChangeWorkshopUserListener implements ApplicationListener<ChangeWorkshopUserEvent> {

	@Resource
	private RedisTemplate redisTemplate;

	@Override
	public void onApplicationEvent(ChangeWorkshopUserEvent event) {
		String redis_key = PropertiesLoader.get("redis.app.key");
		try {
			Map<String, Object> eventSource = (Map<String, Object>) event.getSource();
			List<String> userIds = (List<String>) eventSource.get("userIds");
			if (CollectionUtils.isEmpty(userIds)) {
				Set<String> keys = redisTemplate.keys(redis_key + ":userCenterProgess:*");
				redisTemplate.delete(keys);
				keys = redisTemplate.keys(redis_key + ":userCenterIndexPage:workshops:*");
				redisTemplate.delete(keys);
			} else {
				for (String userId : userIds) {
					Set<String> keys = redisTemplate.keys(redis_key + ":userCenterProgess:" + userId + ":*");
					redisTemplate.delete(keys);
					keys = redisTemplate.keys(redis_key + ":userCenterIndexPage:workshops:" + userId + ":*");
					redisTemplate.delete(keys);
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
			Set<String> keys = redisTemplate.keys(redis_key + ":userCenterIndexPage:workshops:*");
			redisTemplate.delete(keys);
		}

	}

}
