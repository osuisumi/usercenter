package com.haoyu.usercenter.zone.diary.controller;

import javax.annotation.Resource;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.haoyu.sip.core.service.Response;
import com.haoyu.sip.core.web.AbstractBaseController;
import com.haoyu.sip.diary.entity.Diary;
import com.haoyu.sip.diary.service.IDiaryService;
import com.haoyu.usercenter.utils.TemplateUtils;

@Controller
@RequestMapping("userCenter/zone/diary")
public class UCDiaryController extends AbstractBaseController{
	
	@Resource
	private IDiaryService diaryService;
	
	private String getLogicViewNamePerfix(){
		return TemplateUtils.getTemplatePath("/zone/diary/");
	}
	
	@RequestMapping(method=RequestMethod.GET)
	public String list(Diary diary,String userId,Model model){
		model.addAttribute("userId",userId);
		model.addAttribute("diary",diary);
		model.addAttribute("pageBounds", getPageBounds(10, true));
		return getLogicViewNamePerfix() + "list_diary";
	}
	@RequestMapping(value = "create", method=RequestMethod.GET)
	public String create(Diary diary,Model model){
		model.addAttribute("diary",diary);
		return getLogicViewNamePerfix() + "edit_diary"; 
	}
	@RequestMapping(method=RequestMethod.POST)
	@ResponseBody
	public Response create(Diary diary){
		return this.diaryService.createDiary(diary);
	}
	
	@RequestMapping(value="{id}/edit", method=RequestMethod.GET)
	public String edit(Diary diary,Model model){	
		model.addAttribute("diary",diaryService.findDiaryById(diary.getId()));
		return getLogicViewNamePerfix() + "edit_diary";
	}
	
	@RequestMapping(method=RequestMethod.PUT)
	@ResponseBody
	public Response update(Diary diary){
		return this.diaryService.updateDiary(diary);
	}
	
	@RequestMapping(value="{id}/view", method=RequestMethod.GET)
	public String detail(Diary diary,Model model){	
		model.addAttribute("diary",diary);
		model.addAllAttributes(request.getParameterMap());
		return getLogicViewNamePerfix() + "view_diary";
	}
	
	@RequestMapping(method=RequestMethod.DELETE)
	@ResponseBody
	public Response delete(Diary diary){		
		return this.diaryService.deleteDiary(diary);
	}
	
	@RequestMapping(value="comment", method=RequestMethod.GET)
	public String listMovementComment(Model model){
		getPageBounds(10, true);
		setParameterToModel(request, model);
		return getLogicViewNamePerfix() + "list_diary_comment";
	}
}