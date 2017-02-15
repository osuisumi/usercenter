package com.haoyu.usercenter.dynamic;

import java.util.List;
import java.util.Map;

import com.haoyu.sip.dynamic.entity.Dynamic;

public abstract class DynamicSourceEntityHandler {
	
	public Map<String,Object> getSelectParameterMap(){
		return null;
	}
	
	public abstract void setDynamicSourceEntity(Map<String,List<Dynamic>> dynamicMap);

}
