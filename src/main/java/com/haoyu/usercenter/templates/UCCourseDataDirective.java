package com.haoyu.usercenter.templates;

import java.io.IOException;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.commons.lang3.StringUtils;
import org.springframework.stereotype.Component;

import com.google.common.collect.Maps;
import com.haoyu.ncts.course.entity.CourseRelation;
import com.haoyu.ncts.course.service.ICourseRelationBizService;
import com.haoyu.ncts.course.service.ICourseRelationService;
import com.haoyu.tip.train.entity.Train;
import com.haoyu.tip.train.service.ITrainService;

import freemarker.core.Environment;
import freemarker.template.DefaultObjectWrapper;
import freemarker.template.TemplateDirectiveBody;
import freemarker.template.TemplateDirectiveModel;
import freemarker.template.TemplateException;
import freemarker.template.TemplateModel;

@Component
public class UCCourseDataDirective implements TemplateDirectiveModel{
	@Resource
	private ICourseRelationService courseRelationService;
	@Resource
	private ITrainService trainService;

	@Override
	public void execute(Environment env, Map params, TemplateModel[] loopVars, TemplateDirectiveBody body) throws TemplateException, IOException {
		if(params.containsKey("id")&&StringUtils.isNotEmpty(params.get("id").toString())){
			String id = params.get("id").toString();
			Map<String,Object> parameter = Maps.newHashMap();
			parameter.put("courseId", id);
			List<CourseRelation> courseRelations = courseRelationService.listCourseRelations(parameter, null);
			if(courseRelations.size() != 1){
				throw new RuntimeException("courseRelation is not unique");
			}
			Train train = trainService.findTrainById(courseRelations.get(0).getRelation().getId());
			env.setVariable("course", new DefaultObjectWrapper().wrap(courseRelations.get(0).getCourse()));
			env.setVariable("train", new DefaultObjectWrapper().wrap(train));
		}
		body.render(env.getOut());
	}
	

}
