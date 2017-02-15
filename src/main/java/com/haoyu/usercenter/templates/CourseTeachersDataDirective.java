package com.haoyu.usercenter.templates;

import java.io.IOException;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.commons.collections.CollectionUtils;
import org.springframework.stereotype.Component;

import com.github.miemiedev.mybatis.paginator.domain.PageBounds;
import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import com.haoyu.ncts.course.utils.CourseAuthorizeRole;
import com.haoyu.sip.auth.dao.IAuthUserRoleDao;
import com.haoyu.sip.auth.entity.AuthRole;
import com.haoyu.sip.auth.entity.AuthUser;
import com.haoyu.sip.auth.service.IAuthRoleService;
import com.haoyu.sip.auth.service.IAuthUserService;
import com.haoyu.sip.user.entity.UserInfo;
import com.haoyu.sip.user.service.IUserInfoService;
import com.haoyu.sip.utils.Collections3;

import freemarker.core.Environment;
import freemarker.template.DefaultObjectWrapper;
import freemarker.template.TemplateDirectiveBody;
import freemarker.template.TemplateDirectiveModel;
import freemarker.template.TemplateException;
import freemarker.template.TemplateModel;

@Component
public class CourseTeachersDataDirective implements TemplateDirectiveModel{
	@Resource
	private IAuthUserRoleDao authUserRoleDao;
	@Resource
	private IAuthUserService authUserService;
	@Resource
	private IAuthRoleService authRoleService;
	@Resource
	private IUserInfoService userInfoService;

	@Override
	public void execute(Environment env, Map params, TemplateModel[] loopVars, TemplateDirectiveBody body) throws TemplateException, IOException {
		String relationId = "";
		if(params.containsKey("relationId")){
			relationId = params.get("relationId").toString();
		}
		List<AuthRole> allRoles = authRoleService.findRoleByNameAndRelation("", "");
		List<String> teacherRoleCodes = Lists.newArrayList();
		for(AuthRole r:allRoles){
			if(("course_" + CourseAuthorizeRole.MAKER).equals(r.getCode())||("course_"+CourseAuthorizeRole.TEACHER).equals(r.getCode())){
				teacherRoleCodes.add(r.getId());
			}
		}
		
		if(CollectionUtils.isNotEmpty(teacherRoleCodes)){
			List<AuthUser> teachers = Lists.newArrayList();
			for(String roleId:teacherRoleCodes){
				AuthRole role = new AuthRole(roleId);
				teachers.addAll(authUserService.findAuthUserByRoleAndRelation(role, relationId));
			}
			if(CollectionUtils.isNotEmpty(teachers)){
				Map<String,Object> parameter = Maps.newHashMap();
				parameter.put("ids", Collections3.extractToList(teachers, "id"));
				List<UserInfo> teachersUserInfo = userInfoService.listUser(parameter,new PageBounds(8));
				env.setVariable("teachersUserInfo" , new DefaultObjectWrapper().wrap(teachersUserInfo));
			}
		}
		body.render(env.getOut());
		
	}

}
