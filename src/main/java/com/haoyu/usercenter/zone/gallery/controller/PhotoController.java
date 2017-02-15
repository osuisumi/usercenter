package com.haoyu.usercenter.zone.gallery.controller;

import java.util.Arrays;

import javax.annotation.Resource;

import org.apache.commons.codec.digest.DigestUtils;
import org.apache.commons.lang3.StringUtils;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.haoyu.sip.core.service.Response;
import com.haoyu.sip.core.web.AbstractBaseController;
import com.haoyu.sip.gallery.entity.Photo;
import com.haoyu.sip.gallery.service.IPhotoGalleryService;
import com.haoyu.sip.gallery.service.IPhotoService;
import com.haoyu.usercenter.utils.TemplateUtils;

@RequestMapping("userCenter/zone/gallery/photo")
@Controller
public class PhotoController extends AbstractBaseController{
	@Resource
	private IPhotoGalleryService photoGalleryService;
	@Resource
	private IPhotoService photoService;
	
	private String getLogicViewNamePerfix(){
		return TemplateUtils.getTemplatePath("/zone/gallery/photo/");
	}
	@RequestMapping(value="list/{galleryId}",method=RequestMethod.GET)
	public String listGalleryPhotos(@PathVariable String galleryId,String userId,Model model){
		model.addAttribute("galleryId", galleryId);
		model.addAttribute("userId", userId);
		getPageBounds(9, true);
		return getLogicViewNamePerfix() + "list_photo";
	}
	
	@RequestMapping(value="detailList/{galleryId}",method=RequestMethod.GET)
	public String detailList(@PathVariable String galleryId,String photoIds,Model model){
		if(StringUtils.isNotEmpty(photoIds)){
			model.addAttribute("photoIds",photoIds);
		}
		model.addAttribute("galleryId",galleryId);
		getPageBounds(9, true);
		return getLogicViewNamePerfix() + "detail_list_photo";
	}
	
	@RequestMapping(value="detail",method=RequestMethod.GET)
	public String detail(String id,String galleryId,Model model){
		model.addAttribute("id",id);
		model.addAttribute("commentRelationId",id);
		return getLogicViewNamePerfix() + "detail_photo";
	}
	
	@RequestMapping(value="create",method=RequestMethod.GET)
	public String create(String galleryId,Model model){
		if(StringUtils.isNotEmpty(galleryId)){
			model.addAttribute("galleryId", galleryId);
		}
		return getLogicViewNamePerfix() + "create_photo";
	}
	
	@RequestMapping(value="{id}/edit",method=RequestMethod.GET)
	public String edit(@PathVariable String id,Model model){
		model.addAttribute("id", id);
		return getLogicViewNamePerfix() + "edit_photo";
	}
	
	@RequestMapping(value="update",method=RequestMethod.PUT)
	@ResponseBody
	public Response update(Photo photo){
		return photoService.updatePhoto(photo);
	}
	
	@RequestMapping(value="move",method=RequestMethod.GET)
	public String move(String galleryId,String photoIds,Model model){
		model.addAttribute("photoIds", photoIds);
		model.addAttribute("galleryId", galleryId);
		return getLogicViewNamePerfix() + "move_photo";
	}
	
	@RequestMapping(value="movePhotos",method=RequestMethod.PUT)
	@ResponseBody
	public Response movePthotosToGallery(String from,String to,String photoIds){
		return photoGalleryService.movePhotosToAnotherGallery(from,to,Arrays.asList(photoIds.split(",")));
	}
}
