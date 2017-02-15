package com.haoyu.usercenter.zone.zonedynamic.controller;

import javax.annotation.Resource;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.haoyu.sip.core.service.Response;
import com.haoyu.sip.core.web.AbstractBaseController;
import com.haoyu.sip.dynamic.entity.Dynamic;
import com.haoyu.sip.dynamic.service.IDynamicService;
import com.haoyu.sip.gallery.service.IPhotoService;
import com.haoyu.usercenter.utils.TemplateUtils;

@RequestMapping("userCenter/zone/zoneDynamic")
@Controller
public class ZoneDynamicController extends AbstractBaseController{
	@Resource
	private IDynamicService dynamicService;
	@Resource
	private IPhotoService photoService;
	
	private String getLogicViewNamePerfix(){
		return TemplateUtils.getTemplatePath("/zone/zoneDynamic/");
	}
	
	@RequestMapping(method=RequestMethod.GET)
	public String list(String userId,Model model){
		model.addAttribute("userId", userId);
		getPageBounds(5, true);
		return getLogicViewNamePerfix() + "list_zoneDynamic";
	}
	
	@RequestMapping(method=RequestMethod.DELETE)
	@ResponseBody
	public Response delete(Dynamic dynamic){
		return dynamicService.delete(dynamic);
	}
	
	@RequestMapping(value="detailListPhoto",method=RequestMethod.GET)
	public String listPhotoDetail(String galleryId,String photoIds,Model model){
		model.addAttribute("galleryId",galleryId );
		model.addAttribute("photoIds",photoIds);
		return getLogicViewNamePerfix() + "detail_list_photo";
	}

}
