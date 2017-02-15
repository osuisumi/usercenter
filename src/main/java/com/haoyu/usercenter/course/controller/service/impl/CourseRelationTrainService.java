package com.haoyu.usercenter.course.controller.service.impl;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.commons.lang3.StringUtils;
import org.springframework.stereotype.Service;

import com.github.miemiedev.mybatis.paginator.domain.PageBounds;
import com.google.common.collect.Maps;
import com.haoyu.ncts.course.entity.Course;
import com.haoyu.ncts.course.entity.CourseRelation;
import com.haoyu.usercenter.course.controller.dao.ICourseRelationTrainDao;
import com.haoyu.usercenter.course.controller.service.ICourseRelationTrainService;

@Service
public class CourseRelationTrainService implements ICourseRelationTrainService {
	@Resource
	private ICourseRelationTrainDao courseRelationTrainDao;

	@Override
	public List<CourseRelation> listCourseRelations(Map<String, Object> parameter, PageBounds pageBounds) {
		return courseRelationTrainDao.listCourseRelations(parameter, pageBounds);
	}

	@Override
	public List<CourseRelation> listCourseRelations(CourseRelation courseRelation, PageBounds pageBounds) {
		Map<String, Object> parameter = Maps.newHashMap();
		if (courseRelation.getCourse() != null) {
			Course course = courseRelation.getCourse();
			if (StringUtils.isNotEmpty(course.getId())) {
				parameter.put("courseId", course.getId());
			}
			if (StringUtils.isNotEmpty(course.getSubject())) {
				parameter.put("subject", course.getSubject());
			}
			if (StringUtils.isNotEmpty(course.getStage())) {
				parameter.put("stage", course.getState());
			}
			if (StringUtils.isNotEmpty(course.getState())) {
				parameter.put("state", course.getState());
			}
		}
		if (courseRelation.getRelation() != null && StringUtils.isNotEmpty(courseRelation.getRelation().getId())) {
			parameter.put("relationId", courseRelation.getRelation().getId());
		}
		return this.listCourseRelations(parameter, pageBounds);
	}

}
