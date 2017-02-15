package com.haoyu.usercenter.course.controller.dao.impl.mybatis;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import com.github.miemiedev.mybatis.paginator.domain.PageBounds;
import com.haoyu.ncts.course.entity.CourseRelation;
import com.haoyu.sip.core.jdbc.MybatisDao;
import com.haoyu.usercenter.course.controller.dao.ICourseRelationTrainDao;

@Repository
public class CourseRelationTrainDao extends MybatisDao implements ICourseRelationTrainDao{
	

	@Override
	public List<CourseRelation> listCourseRelations(Map<String, Object> parameter,PageBounds pageBounds) {
		return super.selectList("select",parameter,pageBounds);
	}

}
