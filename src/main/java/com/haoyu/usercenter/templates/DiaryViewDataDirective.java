package com.haoyu.usercenter.templates;

import java.io.IOException;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.commons.lang3.StringUtils;
import org.springframework.stereotype.Component;

import com.google.common.collect.Maps;
import com.haoyu.sip.core.utils.ThreadContext;
import com.haoyu.sip.diary.entity.Diary;
import com.haoyu.sip.diary.service.IDiaryService;
import com.haoyu.usercenter.zone.diary.utils.DiaryVisitPermissionType;

import freemarker.core.Environment;
import freemarker.ext.beans.BeanModel;
import freemarker.template.DefaultObjectWrapper;
import freemarker.template.TemplateDirectiveBody;
import freemarker.template.TemplateDirectiveModel;
import freemarker.template.TemplateException;
import freemarker.template.TemplateModel;

@Component
public class DiaryViewDataDirective implements TemplateDirectiveModel{

	@Resource
	private IDiaryService diaryService;
	
	@Override
	public void execute(Environment env, Map params, TemplateModel[] loopVars, TemplateDirectiveBody body)
			throws TemplateException, IOException {
		if (params.containsKey("diary") && params.get("diary") != null) {
			BeanModel beanModel = (BeanModel) params.get("diary");
			if (beanModel != null) {
				Diary diary = (Diary) beanModel.getWrappedObject();
				Map<String, Object> param = Maps.newHashMap();
				String userId = null;
				String id = null;
				
				if (params.containsKey("userId")) {
					userId = params.get("userId").toString().trim();
					if (StringUtils.isNotEmpty(userId) ) {
						param.put("creator", userId);
					}
				}
				
				if (StringUtils.isNotEmpty(diary.getId())) {
					id = diary.getId();
					param.put("id", diary.getId());
				}
				if (StringUtils.isNotEmpty(userId) && !userId.equals(ThreadContext.getUser().getId())) {
					param.put("visitPermission", DiaryVisitPermissionType.PUBLIC);
				}
				
				if (params.containsKey("op") && StringUtils.isNotEmpty(params.get("op").toString().trim())) {
					param.put("op", params.get("op").toString().trim());
					diary = diaryService.getDiaryByOp(param);
					if (diary == null) {
						diary = diaryService.findDiaryById(id);
					}
				}else{
					diary = diaryService.findDiaryById(diary.getId());
				}
				
				env.setVariable("diary", new DefaultObjectWrapper().wrap(diary));
				
				//浏览数加1
				if (diary != null && StringUtils.isNotEmpty(diary.getId())) {					
					diary.setBrowseNum(1);
					diaryService.updateDiary(diary);
				}
			}
		}
		body.render(env.getOut());
	}
}