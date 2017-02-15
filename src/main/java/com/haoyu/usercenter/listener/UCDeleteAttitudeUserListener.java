package com.haoyu.usercenter.listener;

import javax.annotation.Resource;

import org.springframework.context.ApplicationListener;
import org.springframework.stereotype.Component;

import com.haoyu.sip.attitude.entity.AttitudeUser;
import com.haoyu.sip.attitude.event.DeleteAttitudeUserEvent;
import com.haoyu.sip.diary.entity.Diary;
import com.haoyu.sip.diary.service.IDiaryService;
import com.haoyu.sip.dynamic.entity.Dynamic;
import com.haoyu.sip.dynamic.service.IDynamicService;

@Component
public class UCDeleteAttitudeUserListener implements ApplicationListener<DeleteAttitudeUserEvent> {
	@Resource
	private IDynamicService dynamicService;
	@Resource
	private IDiaryService diaryService;

	@Override
	public void onApplicationEvent(DeleteAttitudeUserEvent event) {
		AttitudeUser attitudeUser = (AttitudeUser) event.getSource();
		if (attitudeUser.getRelation().getType().equals("zoneDynamic")) {
			Dynamic dynamic = new Dynamic();
			dynamic.setId(attitudeUser.getRelation().getId());
			dynamic.setSupportNum(1);
			dynamicService.update(dynamic);
		}
		if (attitudeUser.getRelation().getType().equals("zoneDiary")) {
			Diary diary = new Diary();
			diary.setId(attitudeUser.getRelation().getId());
			diary.setSupportNum(1);
			diaryService.updateDiary(diary);
		}	
	}

}
