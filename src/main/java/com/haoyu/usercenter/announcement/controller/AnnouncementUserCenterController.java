package com.haoyu.usercenter.announcement.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import com.haoyu.sip.core.web.AbstractBaseController;
import com.haoyu.tip.announcement.entity.Announcement;
import com.haoyu.usercenter.utils.TemplateUtils;

@Controller
@RequestMapping("**/userCenter/announcement")
public class AnnouncementUserCenterController extends AbstractBaseController{
	
	private String getLogicalViewNamePrefix(){
		return TemplateUtils.getTemplatePath("/announcement/");
	}
	
	@RequestMapping(method=RequestMethod.GET)
	public String list(Model model){
		getPageBounds(10, true);
		model.addAllAttributes(request.getParameterMap());
		return getLogicalViewNamePrefix() + "list_announcement";
	}
	
	@RequestMapping(value="{id}/view", method=RequestMethod.GET)
	public String view(Announcement announcement, Model model){
		model.addAttribute("announcement", announcement);
		return getLogicalViewNamePrefix() + "view_announcement";
	}

}
