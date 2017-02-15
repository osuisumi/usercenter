package com.haoyu.usercenter.course.controller.service;

import java.util.List;
import java.util.Map;

import com.github.miemiedev.mybatis.paginator.domain.PageBounds;
import com.haoyu.ncts.course.entity.CourseRelation;

public interface ICourseRelationTrainService {
	
	public List<CourseRelation> listCourseRelations(Map<String,Object> parameter,PageBounds pageBounds);
	
	public List<CourseRelation> listCourseRelations(CourseRelation courseRelation, PageBounds pageBounds);

}
