package com.haoyu.usercenter.dynamic.service.impl;

import java.util.ArrayList;
import java.util.Collection;
import java.util.List;
import java.util.Map;

import javax.annotation.PostConstruct;
import javax.annotation.Resource;

import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.collections.MapUtils;
import org.springframework.context.ApplicationContext;
import org.springframework.stereotype.Service;

import com.github.miemiedev.mybatis.paginator.domain.PageBounds;
import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import com.haoyu.sip.core.entity.Relation;
import com.haoyu.sip.core.utils.ThreadContext;
import com.haoyu.sip.dynamic.dao.IDynamicDao;
import com.haoyu.sip.dynamic.entity.Dynamic;
import com.haoyu.sip.dynamic.service.IDynamicService;
import com.haoyu.sip.follow.entity.Follow;
import com.haoyu.sip.follow.service.IFollowService;
import com.haoyu.sip.utils.Collections3;
import com.haoyu.usercenter.dynamic.DynamicSourceEntityHandler;
import com.haoyu.usercenter.dynamic.service.IDynamicBizService;
import com.haoyu.usercenter.zone.follow.utils.UserFollowType;

@Service
public class DynamicBizService implements IDynamicBizService{
	
	@Resource
	private IDynamicDao dynamicDao;
	@Resource
	private ApplicationContext applicationContext;
	@Resource
	private IFollowService followService;
	@Resource
	private IDynamicService dynamicService;
	
	private List<DynamicSourceEntityHandler> dynamicSourceEntityHandlers = Lists.newArrayList();
	
	@PostConstruct
	private void init(){
		dynamicSourceEntityHandlers.add((DynamicSourceEntityHandler) applicationContext.getBean("scheduleHandler"));
		dynamicSourceEntityHandlers.add((DynamicSourceEntityHandler) applicationContext.getBean("resourcesHandler"));
		dynamicSourceEntityHandlers.add((DynamicSourceEntityHandler) applicationContext.getBean("galleryPhotoHandler"));
		dynamicSourceEntityHandlers.add((DynamicSourceEntityHandler) applicationContext.getBean("diaryHandler"));
	}
	
	@Override
	public List<Dynamic> ListDynamic(Map<String, Object> param, PageBounds pageBounds,boolean isIncludeFollows) {
		List<String> dynamicCreators = Lists.newArrayList();
		if(isIncludeFollows){
			Follow follow = new Follow();
			follow.setCreator(ThreadContext.getUser());
			follow.setFollowEntity(new Relation());
			follow.getFollowEntity().setType(UserFollowType.FOLLOW_TYPE);
			List<Follow> follows = followService.findFollowByFollow(follow,null);
			if(CollectionUtils.isNotEmpty(follows)){
				dynamicCreators.addAll(Collections3.extractToList(follows, "followEntity.id"));
			}
		}
		dynamicCreators.add(param.get("userId").toString());
		param.put("creators", dynamicCreators);
		
		param.putAll(getParameterMap());
		
		List<Dynamic> dynamics = dynamicDao.select(param, pageBounds);
		setDynamicSourceEntity(dynamics);
		removeEmpty(dynamics);
		return dynamics;
	}
	
	private void setDynamicSourceEntity(List<Dynamic> dynamics){
		if(CollectionUtils.isNotEmpty(dynamics)){
			Map<String,List<Dynamic>> typeMap = Maps.newHashMap();
			for(Dynamic d:dynamics){
				if(!typeMap.containsKey(d.getDynamicSourceType())){
					List<Dynamic> item = Lists.newArrayList();
					item.add(d);
					typeMap.put(d.getDynamicSourceType(),item);
				}else{
					typeMap.get(d.getDynamicSourceType()).add(d);
				}
			}
			for(DynamicSourceEntityHandler dse:dynamicSourceEntityHandlers){
				dse.setDynamicSourceEntity(typeMap);
			}
		}
		
	}
	
	private void removeEmpty(List<Dynamic> dynamics){
		List<Dynamic> prepareRemove = Lists.newArrayList();
		for(Dynamic d:dynamics){
			if(d.getDynamicSourceEntity() == null){
				prepareRemove.add(d);
			}else if(d.getDynamicSourceEntity() instanceof ArrayList){
				if(CollectionUtils.isEmpty((Collection) d.getDynamicSourceEntity())){
					prepareRemove.add(d);
				}
			}
		}
		dynamics.removeAll(prepareRemove);
		//remove之后删除
		if(CollectionUtils.isNotEmpty(prepareRemove)){
			dynamicDao.batchDelete(Collections3.extractToList(prepareRemove, "id"));
		}
	}
	
	private Map<String,Object> getParameterMap(){
		Map<String,Object> result = Maps.newHashMap();
		result.put("dynamicSourceRelationIdExlution", Lists.newArrayList());
		result.put("dynamicSourceIdExlution",Lists.newArrayList());
		List<String> resultdsre = (List<String>) result.get("dynamicSourceRelationIdExlution");
		List<String> resultdse = (List<String>) result.get("dynamicSourceIdExlution");
		for(DynamicSourceEntityHandler dseh:dynamicSourceEntityHandlers){
			Map<String,Object> parameter = dseh.getSelectParameterMap();
			if(MapUtils.isNotEmpty(parameter)){
				if(parameter.containsKey("dynamicSourceRelationIdExlution")){
					Object objdsre = parameter.get("dynamicSourceRelationIdExlution");
					if(objdsre instanceof ArrayList){
						List<String> dsre = (List<String>) parameter.get("dynamicSourceRelationIdExlution");
						resultdsre.addAll(dsre);
					}else if(objdsre instanceof String){
						resultdsre.add(parameter.get("dynamicSourceRelationIdExlution").toString());
					}
				}
				
				if(parameter.containsKey("dynamicSourceIdExlution")){
					Object objdse =  parameter.get("dynamicSourceIdExlution");
					if(objdse instanceof ArrayList){
						List<String> dse = (List<String>) parameter.get("dynamicSourceIdExlution");
						resultdse.addAll(dse);
					}else if(objdse instanceof String){
						resultdse.add(parameter.get("dynamicSourceIdExlution").toString());
					}
				}
			}
		}
		if(CollectionUtils.isEmpty(resultdsre)){
			result.remove("dynamicSourceRelationIdExlution");
		}
		if(CollectionUtils.isEmpty(resultdse)){
			result.remove("dynamicSourceIdExlution");
		}
		return result;
	}

	@Override
	public Dynamic get(String id) {
		Dynamic d = dynamicService.get(id);
		if(d!=null){
			List<Dynamic> list = Lists.newArrayList();
			list.add(d);
			setDynamicSourceEntity(list);
			if(CollectionUtils.isNotEmpty(list)){
				return list.get(0);
			}
		}
		return null;
	}
	
	
//	private List<Dynamic> photoFilter(List<Dynamic> dynamics){
//		List<Dynamic> result = Lists.newArrayList();
//		Subject currentUser = SecurityUtils.getSubject();
//		for(Dynamic d:dynamics){
//			if(currentUser.hasRole("PHOTO_GALLERY_"+d.getDynamicSourceRelation().getId())){
//				result.add(d);
//			}
//		}
//		return result;
//	}
	

}
