package com.haoyu.usercenter.workshop.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import com.haoyu.sip.core.utils.ThreadContext;
import com.haoyu.sip.core.web.AbstractBaseController;
import com.haoyu.usercenter.utils.TemplateUtils;
import com.haoyu.wsts.workshop.utils.WorkshopState;

@Controller
@RequestMapping("**/userCenter/workshop")
public class UCWorkshopController extends AbstractBaseController{
	
	private String getLogicViewNamePerfix(){
		return TemplateUtils.getTemplatePath("/workshop/");
	}
	
	@RequestMapping(method=RequestMethod.GET)
	public String list(String pageType,Model model){
		getPageBounds(10,true);
		model.addAllAttributes(request.getParameterMap());
		pageType = StringUtils.isEmpty(pageType)?"my":pageType;
		if("all".equals(pageType)){
			model.addAttribute("userId", "");
			model.addAttribute("isTemplate", "N");
			model.addAttribute("state",WorkshopState.PUBLISHED);
		}else{
			model.addAttribute("userId", ThreadContext.getUser().getId());
			model.addAttribute("isTemplate", "");
			model.addAttribute("state","");
		}
		model.addAttribute("pageType", pageType);
		return getLogicViewNamePerfix() + "list_workshop"; 
	}
	
	@RequestMapping(value="interested",method=RequestMethod.GET)
	public String listInterestedWorkshop(Model model){
		getPageBounds(5, true);
		return getLogicViewNamePerfix() + "list_interested_workshop";
	}
	
	@RequestMapping(value="manage",method=RequestMethod.GET)
	public String manage(Model model){
		return getLogicViewNamePerfix() + "manage";
	}

}
