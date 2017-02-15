package com.haoyu.usercenter.dynamic.handler;

import java.util.Arrays;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.commons.collections.CollectionUtils;
import org.springframework.stereotype.Component;

import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import com.haoyu.sip.dynamic.entity.Dynamic;
import com.haoyu.sip.utils.Collections3;
import com.haoyu.tip.schedule.entity.Schedule;
import com.haoyu.tip.schedule.service.IScheduleService;
import com.haoyu.usercenter.dynamic.DynamicSourceEntityHandler;
import com.haoyu.usercenter.utils.DynamicSourceType;
@Component
public class ScheduleHandler extends DynamicSourceEntityHandler{
	@Resource
	private IScheduleService scheduleService;

	@Override
	public void setDynamicSourceEntity(Map<String, List<Dynamic>> typeMap) {
		List<Dynamic> scheduleDynamics = typeMap.get(DynamicSourceType.SCHEDULE);
		if(CollectionUtils.isNotEmpty(scheduleDynamics)){
			Map<String,Object> parameter = Maps.newHashMap();
			List<String> scheduleIds = Lists.newArrayList();
			for(Dynamic d:scheduleDynamics){
				scheduleIds.addAll(Arrays.asList(d.getDynamicSourceId().split(",")));
			}
			parameter.put("ids",scheduleIds);
			List<Schedule> schedules = scheduleService.findSchedules(parameter);
			if(!CollectionUtils.isEmpty(schedules)){
				Map<String,Schedule> resultScheduleMap = Collections3.extractToMap(schedules, "id", null);
				for(Dynamic d:scheduleDynamics){
					List<Schedule> dynamicSourceEntity = Lists.newArrayList();
					for(String scheduleId:Arrays.asList(d.getDynamicSourceId().split(","))){
						if(resultScheduleMap.containsKey(scheduleId)){
							dynamicSourceEntity.add(resultScheduleMap.get(scheduleId));
						}
					}
					d.setDynamicSourceEntity(dynamicSourceEntity);
				}
			}
		}
	}
}
