package com.haoyu.usercenter.templates;

import java.io.IOException;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Component;

import com.haoyu.sip.attitude.entity.AttitudeUser;
import com.haoyu.sip.attitude.service.IAttitudeService;
import com.haoyu.sip.core.entity.Relation;

import freemarker.core.Environment;
import freemarker.template.DefaultObjectWrapper;
import freemarker.template.TemplateDirectiveBody;
import freemarker.template.TemplateDirectiveModel;
import freemarker.template.TemplateException;
import freemarker.template.TemplateModel;

@Component
public class AttitudeUsersDataDirective implements TemplateDirectiveModel{
	@Resource
	private IAttitudeService attitudeService;

	@Override
	public void execute(Environment env, Map params, TemplateModel[] loopVars, TemplateDirectiveBody body) throws TemplateException, IOException {
		Relation relation = new Relation();
		if(params.containsKey("relationType") && params.get("relationType")!=null){
			relation.setType(params.get("relationType").toString());
		}
		if(params.containsKey("relationId") && params.get("relationId")!=null){
			relation.setId(params.get("relationId").toString());
		}
		List<AttitudeUser> attitudeUsers = attitudeService.findAttitudeUserByAttitudeAndRelation("support", relation, null);
		env.setVariable("supports" , new DefaultObjectWrapper().wrap(attitudeUsers));
		body.render(env.getOut());
	}

}
