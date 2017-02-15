package com.haoyu.usercenter.course.controller.dao;

import java.util.List;
import java.util.Map;

import com.github.miemiedev.mybatis.paginator.domain.PageBounds;
import com.haoyu.ncts.course.entity.CourseRelation;

public interface ICourseRelationTrainDao {
	
	public List<CourseRelation> listCourseRelations(Map<String,Object> parameter,PageBounds pageBounds);

}
