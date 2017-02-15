package com.haoyu.controller;

import javax.annotation.Resource;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.haoyu.sip.core.service.Response;
import com.haoyu.sip.core.web.AbstractBaseController;
import com.haoyu.sip.textbook.service.ITextBookRelationService;

@Controller
@RequestMapping("test1")
public class Test1Controller extends AbstractBaseController{

	@Resource
	private ITextBookRelationService textBookRelationService;
	
	@RequestMapping("import")
	public void import1(){
		String url = "import.xlsx";
		textBookRelationService.importUtil(url);
	}
	
}
