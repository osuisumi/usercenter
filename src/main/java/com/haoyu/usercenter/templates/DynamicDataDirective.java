package com.haoyu.usercenter.templates;

import java.io.IOException;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Component;

import com.github.miemiedev.mybatis.paginator.domain.PageBounds;
import com.github.miemiedev.mybatis.paginator.domain.PageList;
import com.google.common.collect.Maps;
import com.haoyu.ncts.utils.PageSplitUtils;
import com.haoyu.sip.dynamic.entity.Dynamic;
import com.haoyu.usercenter.dynamic.service.IDynamicBizService;

import freemarker.core.Environment;
import freemarker.template.DefaultObjectWrapper;
import freemarker.template.TemplateDirectiveBody;
import freemarker.template.TemplateDirectiveModel;
import freemarker.template.TemplateException;
import freemarker.template.TemplateModel;

@Component
public class DynamicDataDirective implements TemplateDirectiveModel{
	@Resource
	private IDynamicBizService dynamicBizService;
	
	@Override
	public void execute(Environment env, Map params, TemplateModel[] loopVars, TemplateDirectiveBody body) throws TemplateException, IOException {
		PageBounds pageBounds = PageSplitUtils.getPageBounds(params, env);
		Map<String,Object> param = Maps.newHashMap();
		List<Dynamic> dynamics = dynamicBizService.ListDynamic(param, pageBounds,false);
		if(pageBounds != null && pageBounds.isContainsTotalCount()){
			PageList pageList = (PageList)dynamics;
			env.setVariable("paginator" , new DefaultObjectWrapper().wrap(pageList.getPaginator()));
		}
		env.setVariable("dynamics" , new DefaultObjectWrapper().wrap(dynamics));
		body.render(env.getOut());
		
	}

}
