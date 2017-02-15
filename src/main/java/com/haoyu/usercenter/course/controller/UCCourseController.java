package com.haoyu.usercenter.course.controller;

import javax.annotation.Resource;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import com.haoyu.ncts.course.entity.Course;
import com.haoyu.ncts.course.entity.CourseRelation;
import com.haoyu.ncts.course.service.ICourseRelationBizService;
import com.haoyu.ncts.course.service.ICourseService;
import com.haoyu.ncts.course.utils.CourseState;
import com.haoyu.ncts.faq.controller.param.FaqQuestionParam;
import com.haoyu.sip.core.web.AbstractBaseController;
import com.haoyu.usercenter.utils.TemplateUtils;

@Controller
@RequestMapping("userCenter/course")
public class UCCourseController extends AbstractBaseController{
	@Resource
	private ICourseService courseService;
	
	@Resource
	private ICourseRelationBizService courseRelationService;
	
	private String getLogicViewNamePerfix(){
		return TemplateUtils.getTemplatePath("/course/");
	}
	
//	@RequestMapping(method=RequestMethod.GET)
//	public String list(CourseExtend courseExtend,Model model){
//		getPageBounds(16,true);
//		model.addAttribute("courseExtend", courseExtend);
//		return getLogicViewNamePerfix() +  "list_course";
//	}
	
	@RequestMapping(method=RequestMethod.GET)
	public String list(CourseRelation courseRelation,Model model){
		getPageBounds(16,true);
		model.addAllAttributes(request.getParameterMap());
		model.addAttribute("courseRelation",courseRelation);
		return getLogicViewNamePerfix() +  "list_course";
	}
	
	@RequestMapping(value="{id}",method=RequestMethod.GET)
	public String view(Course course,String relationId,Model model){
		model.addAttribute("courseId",course.getId());
		model.addAttribute("relationId",relationId);
		return getLogicViewNamePerfix() + "view_course";
	}
	
	@RequestMapping(value="faqQuestions",method=RequestMethod.GET)
	public String listFaqQuestion(FaqQuestionParam faqQuestionParam,Model model){
		model.addAttribute("faqQuestion",faqQuestionParam);
		getPageBounds(5, true);
		return getLogicViewNamePerfix() + "list_faqQuestions";
	}

}
