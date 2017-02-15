package com.haoyu.usercenter.templates;

import java.io.IOException;
import java.util.Date;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Component;

import com.github.miemiedev.mybatis.paginator.domain.PageBounds;
import com.github.miemiedev.mybatis.paginator.domain.PageList;
import com.haoyu.ncts.course.entity.CourseRelation;
import com.haoyu.sip.core.freemarker.AbstractTemplateDirectiveModel;
import com.haoyu.usercenter.course.controller.service.ICourseRelationTrainService;

import freemarker.core.Environment;
import freemarker.template.DefaultObjectWrapper;
import freemarker.template.TemplateDirectiveBody;
import freemarker.template.TemplateException;
import freemarker.template.TemplateModel;

@Component
public class CourseRelationTrainDataDirective extends AbstractTemplateDirectiveModel{
	@Resource
	private ICourseRelationTrainService courseRelationTrainService;
	@Override
	public void execute(Environment env, Map params, TemplateModel[] loopVars, TemplateDirectiveBody body) throws TemplateException, IOException {
		Map<String,Object> parameter = getSelectParam(params);
		PageBounds pageBounds = getPageBounds(params);
		
		if (parameter.containsKey("timeParam")) {
			String timeParam = (String)parameter.get("timeParam");
			if (timeParam.equals("beginning")) {
				parameter.put("startTimeLessThanOrEquals", new Date());
				parameter.put("endTimeGreaterThanOrEquals", new Date());
			}else if(timeParam.equals("notBegun")){
				parameter.put("startTimeGreaterThan", new Date());
			}else if(timeParam.equals("end")){
				parameter.put("endTimeLessThan", new Date());
			}else if(timeParam.equals("inElectivesTime")){
				parameter.put("inElectivesTime", new Date());
			}
		}
		
		List<CourseRelation> courseRelations = courseRelationTrainService.listCourseRelations(parameter, pageBounds);
		env.setVariable("courseRelations" , new DefaultObjectWrapper().wrap(courseRelations));
		if(pageBounds != null && pageBounds.isContainsTotalCount()){
			PageList pageList = (PageList)courseRelations;
			env.setVariable("paginator" , new DefaultObjectWrapper().wrap(pageList.getPaginator()));
		}
		body.render(env.getOut());
	}
}
