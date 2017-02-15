package com.haoyu.usercenter.zone.controller;

import javax.annotation.Resource;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import com.haoyu.sip.core.utils.ThreadContext;
import com.haoyu.sip.core.web.AbstractBaseController;
import com.haoyu.usercenter.utils.TemplateUtils;
import com.haoyu.usercenter.zone.dao.IZoneCountInfoDao;

@Controller
@RequestMapping(value="userCenter/zone")
public class ZoneController extends AbstractBaseController{
	@Resource
	private IZoneCountInfoDao zoneCountInfoDao;
	
	private String getLogicViewNamePerfix(){
		return TemplateUtils.getTemplatePath("/zone/");
	}
	
	@RequestMapping(value="index",method=RequestMethod.GET)
	public String index(String userId,Model model){
		model.addAttribute("userId", userId);
		model.addAttribute("zoneCountInfo", zoneCountInfoDao.getZoneCountInfo(userId));
		if(ThreadContext.getUser().getId().equals(userId)){
			return getLogicViewNamePerfix() + "index";
		}else{
			return getLogicViewNamePerfix() + "others_index";
		}
		
	}

}
