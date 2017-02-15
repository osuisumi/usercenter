package com.haoyu.usercenter.shiro.handler;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.commons.collections.CollectionUtils;
import org.apache.shiro.authz.SimpleAuthorizationInfo;
import org.apache.shiro.subject.PrincipalCollection;

import com.google.common.collect.Maps;
import com.haoyu.ncts.course.entity.CourseAuthorize;
import com.haoyu.ncts.course.entity.CourseRegister;
import com.haoyu.ncts.course.service.ICourseAuthorizeService;
import com.haoyu.ncts.course.service.ICourseRegisterService;
import com.haoyu.ncts.course.utils.CourseAuthorizeRole;
import com.haoyu.ncts.course.utils.CourseRegisterState;
import com.haoyu.ncts.utils.RoleCodeConstant;
import com.haoyu.sip.auth.realm.IAuthRealmHandler;
import com.haoyu.wsts.workshop.entity.WorkshopUser;
import com.haoyu.wsts.workshop.service.IWorkshopUserService;
import com.haoyu.wsts.workshop.utils.WorkshopUserRole;
import com.haoyu.wsts.workshop.utils.WorkshopUserState;

public class AuthRealmHandler implements IAuthRealmHandler{
	
	@Resource
	private ICourseRegisterService courseRegisterService;
	@Resource
	private ICourseAuthorizeService courseAuthorizeService;
	@Resource
	private IWorkshopUserService workshopUserService;
	
	@Override
	public void addAuthorize(SimpleAuthorizationInfo info, PrincipalCollection principals) {
		List<Object> listPrincipals = principals.asList();
		Map<String, String> attributes = (Map<String, String>) listPrincipals.get(1);
		String userId = attributes.get("id");
		
		Map<String, Object> params = Maps.newHashMap();
		params.put("userId", userId);
		params.put("state", CourseRegisterState.PASS);
		List<CourseRegister> courseRegisters = courseRegisterService.listCourseRegister(params, null);
		for (CourseRegister courseRegister : courseRegisters) {
			info.addRole(RoleCodeConstant.COURSE_STUDY+"_"+courseRegister.getCourse().getId());
			if (!info.getRoles().contains(RoleCodeConstant.COURSE_STUDY)) {
				info.addRole(RoleCodeConstant.COURSE_STUDY);
			}
		}
		params.put("state", CourseRegisterState.PREVIEW);
		courseRegisters = courseRegisterService.listCourseRegister(params, null);
		for (CourseRegister courseRegister : courseRegisters) {
			info.addRole(RoleCodeConstant.PREVIEW+"_"+courseRegister.getCourse().getId());
		}
		
		params = Maps.newHashMap();
		params.put("userId", userId);
		List<CourseAuthorize> courseAuthorizes = courseAuthorizeService.listCourseAuthorize(params, null);
		for (CourseAuthorize courseAuthorize : courseAuthorizes) {
			if (courseAuthorize.getRole().equals(CourseAuthorizeRole.MAKER)) {
				info.addRole(RoleCodeConstant.COURSE_MAKER + "_" + courseAuthorize.getCourse().getId());
				if (!info.getRoles().contains(RoleCodeConstant.COURSE_MAKER)) {
					info.addRole(RoleCodeConstant.COURSE_MAKER);
				}
			}else if(courseAuthorize.getRole().equals(CourseAuthorizeRole.TEACHER)){
				info.addRole(RoleCodeConstant.COURSE_TEACHER + "_" + courseAuthorize.getCourse().getId());
				if (!info.getRoles().contains(RoleCodeConstant.COURSE_TEACHER)) {
					info.addRole(RoleCodeConstant.COURSE_TEACHER);
				}
			}else if(courseAuthorize.getRole().equals(CourseAuthorizeRole.ASSISTANT)){
				info.addRole(RoleCodeConstant.COURSE_ASSISTANT + "_" + courseAuthorize.getCourse().getId());
				if (!info.getRoles().contains(RoleCodeConstant.COURSE_ASSISTANT)) {
					info.addRole(RoleCodeConstant.COURSE_ASSISTANT);
				}
			}
		}
		
		params = Maps.newHashMap();
		params.put("userId", userId);
		List<WorkshopUser> workshopUsers = workshopUserService.findWorkshopUsers(params,null);
		if(CollectionUtils.isNotEmpty(workshopUsers)){
			for(WorkshopUser wu : workshopUsers){
				if(WorkshopUserState.PASS.equals(wu.getState())){
					info.addRole(wu.getRole() + "_" + wu.getWorkshopId());
					if (WorkshopUserRole.MASSTER.equals(wu.getRole()) || WorkshopUserRole.MEMBER.equals(wu.getRole())) {
						if (!info.getRoles().contains(RoleCodeConstant.WORKSHOP_MEMBER)) {
							info.addRole(RoleCodeConstant.WORKSHOP_MEMBER);
						}
					}else{
						if (!info.getRoles().contains(RoleCodeConstant.COURSE_STUDY)) {
							info.addRole(RoleCodeConstant.COURSE_STUDY);
						}
					}
				}
			}
		}
	}

}
