package com.haoyu.usercenter.zone.dynamic.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import com.haoyu.sip.core.web.AbstractBaseController;
import com.haoyu.usercenter.utils.TemplateUtils;

@Controller
@RequestMapping("userCenter/zone/dynamic")
public class DynamicController extends AbstractBaseController{
	
	private String getLogicViewNamePerfix(){
		return TemplateUtils.getTemplatePath("/zone/dynamic/");
	}
	
	@RequestMapping(method=RequestMethod.GET)
	public String list(String userId,Model model){
		model.addAttribute("userId",userId);
		getPageBounds(6, true);
		return getLogicViewNamePerfix() + "list_dynamic";
	}

}
