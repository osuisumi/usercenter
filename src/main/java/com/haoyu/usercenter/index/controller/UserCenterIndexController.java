package com.haoyu.usercenter.index.controller;

import java.util.List;

import org.apache.commons.lang3.StringUtils;
import org.apache.shiro.SecurityUtils;
import org.apache.shiro.subject.Subject;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import com.google.common.collect.Lists;
import com.haoyu.ncts.course.entity.CourseRegister;
import com.haoyu.ncts.utils.RoleCodeConstant;
import com.haoyu.sip.core.utils.ThreadContext;
import com.haoyu.sip.core.web.AbstractBaseController;
import com.haoyu.sip.login.Loginer;
import com.haoyu.usercenter.utils.TemplateUtils;

@Controller
@RequestMapping("**/userCenter")
public class UserCenterIndexController extends AbstractBaseController{
	
	private String getLogicalViewNamePrefix(){
		return TemplateUtils.getTemplatePath("/");
	}
	
	@RequestMapping(value="index", method=RequestMethod.GET)
	public String index(Model model){
		Subject currentUser = SecurityUtils.getSubject();
		String url = "";
		List<String> enters = Lists.newArrayList();
		Loginer loginer = (Loginer) request.getSession().getAttribute("loginer");
		if (loginer != null ) {
			String roleCode = (String) loginer.getAttributes().get("roleCode");
			if (roleCode.equals("1")) {
				enters.add(RoleCodeConstant.SUPER_MANAGER);
				url = "redirect:/nts/manage";
			}
		}
		if (currentUser.hasRole(RoleCodeConstant.COURSE_MAKER)) {
			enters.add(RoleCodeConstant.COURSE_MAKER);
			url = "redirect:/make/course";
		}
		if(currentUser.hasRole(RoleCodeConstant.COURSE_TEACHER)){
			enters.add(RoleCodeConstant.COURSE_TEACHER);
			url = "redirect:/teach/course";
		}
		if(currentUser.hasRole(RoleCodeConstant.COURSE_STUDY)){
			if (!enters.contains("user_center")) {
				enters.add("user_center");
			}
		}
		if(currentUser.hasRole(RoleCodeConstant.WORKSHOP_MEMBER)){
			if (!enters.contains(RoleCodeConstant.WORKSHOP_MEMBER)) {
				enters.add(RoleCodeConstant.WORKSHOP_MEMBER);
			}
			url = "redirect:/userCenter/workshop/manage";
		}
//		if (currentUser.hasRole(RoleCodeConstant.SUPER_MANAGER) || currentUser.hasRole(RoleCodeConstant.DEV_MANAGER) || currentUser.hasRole(RoleCodeConstant.COMMUNITY_MANAGER)
//				|| currentUser.hasRole(RoleCodeConstant.RESOURCE_MANAGER)) {
//			
//		}
		if (currentUser.hasRole(RoleCodeConstant.TRAIN_INSPECTOR)) {
			if (!enters.contains("user_center")) {
				enters.add("user_center");
			}
		}
		if (enters.size() > 1) {
			model.addAttribute("enters", enters);
			return "/user-center/my_enters";
		}else{
			if (StringUtils.isNotEmpty(url)) {
				return url;
			}else{
				return "redirect:/userCenter";
			}
		}
	}
	
	@RequestMapping(method=RequestMethod.GET)
	public String myUserCenter(Model model){
		this.setParameterToModel(request, model);
		return  getLogicalViewNamePrefix() + "my_user_center";
	}

}
