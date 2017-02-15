package com.haoyu.usercenter.zone.dao.impl.mybatis;

import java.util.Map;

import org.springframework.stereotype.Repository;

import com.google.common.collect.Maps;
import com.haoyu.sip.core.jdbc.MybatisDao;
import com.haoyu.sip.core.utils.ThreadContext;
import com.haoyu.usercenter.zone.dao.IZoneCountInfoDao;
import com.haoyu.usercenter.zone.utils.ZoneCountInfo;

@Repository
public class ZoneCountInfoDao extends MybatisDao implements IZoneCountInfoDao{

	@Override
	public ZoneCountInfo getZoneCountInfo(String userId) {
		Map<String, Object> param = Maps.newHashMap();
		param.put("userId", userId);
		if(ThreadContext.getUser().getId().equals(userId)){
			param.put("isMyself", true);
		}else {
			param.put("isMyself", false);
		}
		return super.selectOne("select",param);
	}

}
