package com.haoyu.usercenter.templates;

import java.io.IOException;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.data.redis.core.ValueOperations;
import org.springframework.stereotype.Component;

import com.github.miemiedev.mybatis.paginator.domain.PageBounds;
import com.github.miemiedev.mybatis.paginator.domain.PageList;
import com.google.common.collect.Lists;
import com.haoyu.sip.core.freemarker.AbstractTemplateDirectiveModel;
import com.haoyu.sip.core.utils.PropertiesLoader;
import com.haoyu.wsts.workshop.entity.Workshop;
import com.haoyu.wsts.workshop.service.IWorkshopService;

import freemarker.core.Environment;
import freemarker.template.DefaultObjectWrapper;
import freemarker.template.TemplateDirectiveBody;
import freemarker.template.TemplateException;
import freemarker.template.TemplateModel;

@Component
public class UCCacheAbleWorkshopsDirective extends AbstractTemplateDirectiveModel {
	@Resource
	private IWorkshopService workshopService;
	@Resource
	private RedisTemplate redisTemplate;
	@Override
	public void execute(Environment env, Map params, TemplateModel[] loopVars, TemplateDirectiveBody body) throws TemplateException, IOException {
		Map<String, Object> param = getSelectParam(params);
		PageBounds pageBounds = getPageBounds(params);
		List<Workshop> workshops = Lists.newArrayList();
		ValueOperations<String, List<Workshop>> valueOper = redisTemplate.opsForValue();
		String key =  PropertiesLoader.get("redis.app.key") + ":userCenterIndexPage:workshops:" + param.get("userId") + ":" + param.get("relationId");
		if(redisTemplate.hasKey(key)){
			workshops = valueOper.get(key);
		}else{
			workshops = workshopService.findWorkshops(param, pageBounds);
			if(workshops!=null&&!workshops.isEmpty()){
				valueOper.set(key, workshops);
			}
		}
		env.setVariable("workshops", new DefaultObjectWrapper().wrap(workshops));
		if (pageBounds != null && pageBounds.isContainsTotalCount()) {
			PageList pageList = (PageList) workshops;
			env.setVariable("paginator", new DefaultObjectWrapper().wrap(pageList.getPaginator()));
		}
		body.render(env.getOut());

	}

}
