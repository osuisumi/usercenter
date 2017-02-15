package com.haoyu.usercenter.listener;

import java.util.Set;

import javax.annotation.Resource;

import org.springframework.context.ApplicationListener;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.stereotype.Component;

import com.haoyu.sip.core.utils.PropertiesLoader;
import com.haoyu.wsts.workshop.event.ChangeWorkshopEvent;

@Component
public class ClearCache_ChangeWorkshopListener implements ApplicationListener<ChangeWorkshopEvent>{
	
	@Resource
	private RedisTemplate redisTemplate;

	@Override
	public void onApplicationEvent(ChangeWorkshopEvent event) {
		Set<String> keys = redisTemplate.keys(PropertiesLoader.get("redis.app.key") + ":userCenterIndexPage:workshops:*");
		redisTemplate.delete(keys);
	}

}
