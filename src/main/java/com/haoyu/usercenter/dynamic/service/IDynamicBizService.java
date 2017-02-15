package com.haoyu.usercenter.dynamic.service;

import java.util.List;
import java.util.Map;

import com.github.miemiedev.mybatis.paginator.domain.PageBounds;
import com.haoyu.sip.dynamic.entity.Dynamic;

public interface IDynamicBizService {
	
	List<Dynamic> ListDynamic(Map<String,Object> param,PageBounds pageBounds,boolean isIncludeFollows);
	
	Dynamic get(String id);

}
