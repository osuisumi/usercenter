package com.haoyu.usercenter.zone.follow.controller;


import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import com.haoyu.sip.core.web.AbstractBaseController;
import com.haoyu.usercenter.utils.TemplateUtils;

@RequestMapping("userCenter/zone/follow")
@Controller
public class UCFollowController extends AbstractBaseController{
	
	
	private String getLogicViewNamePerfix(){
		return TemplateUtils.getTemplatePath("/zone/follow/");
	}
	@RequestMapping(value="fans",method=RequestMethod.GET)
	public String listFans(String userId,String fansName,Model model){
		model.addAttribute("userId", userId);
		model.addAttribute("fansName", fansName);
		getPageBounds(16, true);
		return getLogicViewNamePerfix() +"fans/list_fans";
	}
	
	@RequestMapping(value="follows",method=RequestMethod.GET)
	public String listFollows(String userId,String followName,Model model){
		model.addAttribute("userId",userId);
		model.addAttribute("followName", followName);
		getPageBounds(16,true);
		return getLogicViewNamePerfix() +"follows/list_follows";
	}

}
