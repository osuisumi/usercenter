package com.haoyu.usercenter.zone.resource.controller;

import javax.annotation.Resource;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.haoyu.sip.category.entity.Category;
import com.haoyu.sip.category.service.ICategoryService;
import com.haoyu.sip.core.service.Response;
import com.haoyu.sip.core.utils.ThreadContext;
import com.haoyu.sip.core.web.AbstractBaseController;
import com.haoyu.tip.resource.entity.Resources;
import com.haoyu.tip.resource.service.IResourceRelationService;
import com.haoyu.tip.resource.service.IResourceService;
import com.haoyu.usercenter.utils.TemplateUtils;

@Controller
@RequestMapping("userCenter/zone/resource")
public class UCResourceController extends AbstractBaseController{

	@Resource
	private IResourceService resourceService;
	@Resource
	private IResourceRelationService resourceRelationService;
	@Resource
	private ICategoryService categoryService;
	
	private String getLogicViewNamePerfix(){
		return TemplateUtils.getTemplatePath("/zone/resource/");
	}
	
	@RequestMapping(method=RequestMethod.GET)
	public String list(Resources resource,String userId, Model model){
		model.addAttribute("userId", userId);
		resource.setCreator(ThreadContext.getUser());
		model.addAttribute("resource", resource);
		model.addAttribute("pageBounds", getPageBounds(10, true));
		return getLogicViewNamePerfix() + "list_resource";
	}
	
	@RequestMapping(value = "create", method=RequestMethod.GET)
	public String create(String userId,Model model){
		model.addAttribute("userId", userId);
		return getLogicViewNamePerfix() + "edit_resource"; 
	}
	
	@RequestMapping(method=RequestMethod.POST)
	@ResponseBody
	public Response create(Resources resource){
		return this.resourceService.createResource(resource);
	}
	
	@RequestMapping(value="{id}/edit", method=RequestMethod.GET)
	public String edit(Resources resource,String userId,Model model){	
		model.addAttribute("userId", userId);
		model.addAttribute("resource",resourceService.viewResource(resource));
		return getLogicViewNamePerfix() + "edit_resource";
	}
	
	@RequestMapping(method=RequestMethod.PUT)
	@ResponseBody
	public Response update(Resources resource){
		return this.resourceService.updateResource(resource);
	}
	
	@RequestMapping(method=RequestMethod.DELETE)
	@ResponseBody
	public Response delete(Resources resource){		
		return this.resourceRelationService.delete(resource.getResourceRelations().get(0).getId());
	}
	
	@RequestMapping(value="category",method=RequestMethod.GET)
	public String listCategory(Category category,String userId, Model model){
		model.addAttribute("userId", userId);
		category.setCreator(ThreadContext.getUser());
		model.addAttribute("category", category);
		return getLogicViewNamePerfix() + "list_category";
	}
	
	@RequestMapping(value = "category/create", method=RequestMethod.GET)
	public String createCategory(Category category,Model model){
		model.addAttribute("category",category);
		return getLogicViewNamePerfix() + "edit_category"; 
	}
	
	@RequestMapping(value="category",method=RequestMethod.POST)
	@ResponseBody
	public Response createCategory(Category category){
		return categoryService.createCategory(category);
	}
	
	@RequestMapping(value="category",method=RequestMethod.DELETE)
	@ResponseBody
	public Response deleteCategory(Category category){
		return categoryService.deleteCategoryByLogic(category);
	}
	
	@RequestMapping(value="category/edit", method=RequestMethod.GET)
	public String editCategory(Category category,Model model){	
		model.addAttribute("category",categoryService.findCategoryById(category.getId()));
		return getLogicViewNamePerfix() + "edit_category";
	}
	
	@RequestMapping(value="category",method=RequestMethod.PUT)
	@ResponseBody
	public Response updateCategory(Category category){
		return this.categoryService.updateCategory(category);
	}
	
}
