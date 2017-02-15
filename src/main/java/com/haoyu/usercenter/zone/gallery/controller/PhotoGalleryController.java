package com.haoyu.usercenter.zone.gallery.controller;

import java.util.Arrays;

import javax.annotation.Resource;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.haoyu.sip.core.service.Response;
import com.haoyu.sip.core.web.AbstractBaseController;
import com.haoyu.sip.gallery.entity.PhotoGallery;
import com.haoyu.sip.gallery.service.IPhotoGalleryService;
import com.haoyu.usercenter.utils.TemplateUtils;

@Controller
@RequestMapping("userCenter/zone/gallery/photoGallery")
public class PhotoGalleryController extends AbstractBaseController{
	
	@Resource
	private IPhotoGalleryService photoGalleryService;
	
	private String getLogicViewNamePerfix(){
		return TemplateUtils.getTemplatePath("/zone/gallery/photoGallery/");
	}
	
	@RequestMapping(method=RequestMethod.GET)
	public String list(String userId,Model model){
		model.addAttribute("userId", userId);
		getPageBounds(12, true);
		return getLogicViewNamePerfix() + "list_photoGallery";
	}
	
	@RequestMapping(value="create",method=RequestMethod.GET)
	public String create(){
		return getLogicViewNamePerfix() + "edit_photoGallery";
	}
	
	@RequestMapping(value="edit/{id}",method=RequestMethod.GET)
	public String edit(@PathVariable String id,Model model){
		model.addAttribute("id", id);
		return getLogicViewNamePerfix() + "edit_photoGallery";
	}
	
	@RequestMapping(method=RequestMethod.POST)
	@ResponseBody
	public Response createPhotoGallery(PhotoGallery photoGallery){
		return photoGalleryService.createPhotoGallery(photoGallery);
	}
	
	@RequestMapping(value = "/{id}/addPhotos", method = RequestMethod.POST)
	@ResponseBody
	public Response addPhotosToGallery(@PathVariable String id, PhotoGallery photoGallery){
		Response response = photoGalleryService.addPhotosToGallery(id, photoGallery.getPhotos());
		return response;
	}
	
	@RequestMapping(value = "/{id}/removePhotos", method = RequestMethod.DELETE)
	@ResponseBody
	public Response removePhotosToGallery(@PathVariable String id, String photoIds){
		Response response = photoGalleryService.deletePhotosFromGallery(id, Arrays.asList(photoIds.split(",")));
		return response;
	}
	
	@RequestMapping(value = "/{id}",method=RequestMethod.PUT)
	@ResponseBody
	public Response updatePhotoGallery(@PathVariable String id,PhotoGallery photoGallery){
		photoGallery.setId(id);
		return photoGalleryService.updatePhotoGallery(photoGallery);
	}
	
	@RequestMapping(value = "/{id}",method=RequestMethod.DELETE)
	@ResponseBody
	public Response deletePhotoGallery(@PathVariable String id){
		return photoGalleryService.deletePhotoGallery(new PhotoGallery(id));
	}
	
	

}
