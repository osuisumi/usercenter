package com.haoyu.usercenter.zone.schedule.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import com.haoyu.usercenter.utils.TemplateUtils;

@Controller
@RequestMapping("userCenter/zone/schedule")
public class UCScheduleController {
	
	private String getLogicViewNamePerfix(){
		return TemplateUtils.getTemplatePath("/zone/schedule/");
	}
	@RequestMapping(method=RequestMethod.GET)
	public String list(String userId,Model model){
		model.addAttribute("userId", userId);
		return getLogicViewNamePerfix() + "list_schedule";
	}

}
