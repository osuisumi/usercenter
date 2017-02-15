package com.haoyu.usercenter.utils;

import java.util.List;

import com.haoyu.sip.core.entity.Relation;
import com.haoyu.sip.diary.entity.Diary;
import com.haoyu.sip.dynamic.entity.Dynamic;
import com.haoyu.sip.gallery.entity.Photo;
import com.haoyu.tip.resource.entity.Resources;
import com.haoyu.tip.schedule.entity.Schedule;

public class DynamicFactory {
	
	public static Dynamic createDynamic(Schedule schedule){
		Dynamic dynamic = createDynamic();
		dynamic.setDynamicSourceId(schedule.getId());
		dynamic.setDynamicSourceType(DynamicSourceType.SCHEDULE);
		return dynamic;
	}
	
	public static Dynamic createDynamic(List<Schedule> schedules){
		Dynamic dynamic = createDynamic();
		String ids = "";
		for(Schedule s:schedules){
			if(ids.equals("")){
				ids = s.getId();
			}else{
				ids = ids + "," + s.getId();
			}
		}
		dynamic.setDynamicSourceId(ids);
		dynamic.setDynamicSourceType(DynamicSourceType.SCHEDULE);
		return dynamic;
		
	}
	
	public static Dynamic createDynamic(List<Photo> photos,String galleryId){
		Dynamic dynamic = createDynamic();
		dynamic.getDynamicSourceRelation().setId(galleryId);
		String ids = "";
		for(Photo p:photos){
			if(ids.equals("")){
				ids = p.getId();
			}else{
				ids = ids + "," + p.getId();
			}
		}
		dynamic.setDynamicSourceId(ids);
		dynamic.setDynamicSourceType(DynamicSourceType.GALLERY_PHOTO);
		return dynamic;
	}
	
	public static Dynamic createDynamic(Diary diary){
		Dynamic dynamic = createDynamic();
		dynamic.setDynamicSourceId(diary.getId());
		dynamic.setDynamicSourceType(DynamicSourceType.DIARY);
		return dynamic;
	}
	
	public static Dynamic createDynamic(Resources entity){
		Dynamic dynamic = createDynamic();
		dynamic.setDynamicSourceId(entity.getId());
		dynamic.setDynamicSourceType(DynamicSourceType.RESOURCE);
		return dynamic;
	}
	
	private static Dynamic createDynamic(){
		Dynamic dynamic = new Dynamic();
		Relation relation = new Relation();
		relation.setType("zone");
		dynamic.setDynamicSourceRelation(relation);
		return dynamic;
	}

}
