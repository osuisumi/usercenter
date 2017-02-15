package com.haoyu.usercenter.templates;

import java.io.IOException;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.commons.lang3.StringUtils;
import org.springframework.stereotype.Component;

import com.github.miemiedev.mybatis.paginator.domain.PageBounds;
import com.github.miemiedev.mybatis.paginator.domain.PageList;
import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import com.haoyu.ncts.utils.PageSplitUtils;
import com.haoyu.sip.category.entity.Category;
import com.haoyu.sip.category.service.ICategoryService;
import com.haoyu.sip.core.entity.Relation;
import com.haoyu.sip.core.utils.ThreadContext;
import com.haoyu.tip.resource.entity.Resources;
import com.haoyu.tip.resource.service.IResourceService;
import com.haoyu.usercenter.zone.resource.utils.ResourceCategoryRelationType;
import com.haoyu.usercenter.zone.resource.utils.ResourceBelongType;
import com.haoyu.usercenter.zone.resource.utils.ResourcePrivikegeType;

import freemarker.core.Environment;
import freemarker.ext.beans.BeanModel;
import freemarker.template.DefaultObjectWrapper;
import freemarker.template.TemplateDirectiveBody;
import freemarker.template.TemplateDirectiveModel;
import freemarker.template.TemplateException;
import freemarker.template.TemplateModel;

@Component
public class ResourcesDataDirective implements TemplateDirectiveModel{

	@Resource
	private IResourceService resourceService;
	@Resource
	private ICategoryService categoryService;
	
	@Override
	public void execute(Environment env, Map params, TemplateModel[] loopVars, TemplateDirectiveBody body)
			throws TemplateException, IOException {
		List<Resources> resources = Lists.newArrayList();
		List<Category> categories = Lists.newArrayList();
		String userId = "";
		Map<String, String> resourceTypeNames = Maps.newHashMap();

		PageBounds pageBounds = PageSplitUtils.getPageBounds(params, env);
		if(params.containsKey("userId")){
			userId = params.get("userId").toString();
			
			Map<String, Object> m = Maps.newHashMap();
			Relation relation = new Relation();
			relation.setType(ResourceCategoryRelationType.ZONE_RESOURCE);
			relation.setId(userId);
			m.put("relation",relation);
			categories = categoryService.listCategory(m, null);
			
			for (Category category : categories) {
				resourceTypeNames.put(category.getId(), category.getName());
			}
			
		}
		if (params.containsKey("resource") && params.get("resource") != null) {
			BeanModel beanModel = (BeanModel) params.get("resource");
			if (beanModel != null) {
				Resources resource = (Resources) beanModel.getWrappedObject();
				Map<String, Object> param = Maps.newHashMap();
				param.put("creator",userId);
				if(StringUtils.isNotEmpty(resource.getType())){
					param.put("type", resource.getType());
				}
				if (StringUtils.isNoneEmpty(userId)) {
					param.put("relationId", userId);
				}
				param.put("relationType", "zone");
				param.put("belong", ResourceBelongType.PERSONAL);
				if(!ThreadContext.getUser().getId().equals(userId)){
					param.put("privilege", ResourcePrivikegeType.PUBLIC);
				}
				resources = resourceService.list(param, pageBounds,true);
				env.setVariable("resources", new DefaultObjectWrapper().wrap(resources));
			}
		}
		if (pageBounds != null && pageBounds.isContainsTotalCount()) {
			PageList pageList = (PageList)resources;
			env.setVariable("paginator" , new DefaultObjectWrapper().wrap(pageList.getPaginator()));
		}

		env.setVariable("categories", new DefaultObjectWrapper().wrap(categories));
		env.setVariable("resourceTypeNames", new DefaultObjectWrapper().wrap(resourceTypeNames));
		body.render(env.getOut());
	}

}
