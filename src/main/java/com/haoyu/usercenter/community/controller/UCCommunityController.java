package com.haoyu.usercenter.community.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import com.haoyu.sip.core.web.AbstractBaseController;
import com.haoyu.usercenter.utils.TemplateUtils;

@Controller
@RequestMapping("**/userCenter/community")
public class UCCommunityController extends AbstractBaseController{
	
	private String getLogicViewNamePerfix(){
		return TemplateUtils.getTemplatePath("/community/");
	}
	
	@RequestMapping
	public String index(){
		return getLogicViewNamePerfix() + "index"; 
	}
	
	@RequestMapping("point")
	public String point(){
		return getLogicViewNamePerfix() + "point"; 
	}

}
