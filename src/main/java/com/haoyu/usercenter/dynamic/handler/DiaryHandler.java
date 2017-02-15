package com.haoyu.usercenter.dynamic.handler;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.commons.collections.CollectionUtils;
import org.springframework.stereotype.Component;

import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import com.haoyu.sip.diary.entity.Diary;
import com.haoyu.sip.diary.service.IDiaryService;
import com.haoyu.sip.dynamic.entity.Dynamic;
import com.haoyu.sip.utils.Collections3;
import com.haoyu.usercenter.dynamic.DynamicSourceEntityHandler;
import com.haoyu.usercenter.utils.DynamicSourceType;

@Component
public class DiaryHandler extends DynamicSourceEntityHandler{
	@Resource
	private IDiaryService diaryService;

	@SuppressWarnings("unchecked")
	@Override
	public void setDynamicSourceEntity(Map<String, List<Dynamic>> typeMap) {
		List<Dynamic> diaryDynamic = typeMap.get(DynamicSourceType.DIARY);
		if(CollectionUtils.isNotEmpty(diaryDynamic)){
			Map<String,Object> parameter = Maps.newHashMap();
			List<String> diaryIds = Lists.newArrayList();
			for(Dynamic d:diaryDynamic){
				diaryIds.add(d.getDynamicSourceId());
			}
			parameter.put("ids", diaryIds);
			List<Diary> diarys = diaryService.listDiary(parameter,null);
			if(!CollectionUtils.isEmpty(diarys)){
				Map<String,Diary> resultDiaryMap = Collections3.extractToMap(diarys, "id", null);
				for(Dynamic d:diaryDynamic){
					if(resultDiaryMap.containsKey(d.getDynamicSourceId())){
						d.setDynamicSourceEntity(resultDiaryMap.get(d.getDynamicSourceId()));
					}
				}
			}
		}
		
	}

}
