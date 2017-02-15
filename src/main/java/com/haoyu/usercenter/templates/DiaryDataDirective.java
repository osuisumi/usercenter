package com.haoyu.usercenter.templates;

import java.io.IOException;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.commons.lang3.StringUtils;
import org.springframework.stereotype.Component;

import com.github.miemiedev.mybatis.paginator.domain.Order;
import com.github.miemiedev.mybatis.paginator.domain.PageBounds;
import com.github.miemiedev.mybatis.paginator.domain.PageList;
import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import com.haoyu.ncts.utils.PageSplitUtils;
import com.haoyu.sip.attitude.entity.AttitudeUser;
import com.haoyu.sip.attitude.service.IAttitudeService;
import com.haoyu.sip.core.utils.ThreadContext;
import com.haoyu.sip.diary.entity.Diary;
import com.haoyu.sip.diary.service.IDiaryService;
import com.haoyu.sip.utils.Collections3;
import com.haoyu.usercenter.zone.diary.utils.DiaryVisitPermissionType;

import freemarker.core.Environment;
import freemarker.ext.beans.BeanModel;
import freemarker.template.DefaultObjectWrapper;
import freemarker.template.TemplateDirectiveBody;
import freemarker.template.TemplateDirectiveModel;
import freemarker.template.TemplateException;
import freemarker.template.TemplateModel;
import uk.ac.ed.ph.jqtiplus.node.content.xhtml.table.Thead;
@Component
public class DiaryDataDirective implements TemplateDirectiveModel{

	@Resource
	private IDiaryService diaryService;
	@Resource
	private IAttitudeService attitudeService;
	
	@Override
	public void execute(Environment env, Map params, TemplateModel[] loopVars, TemplateDirectiveBody body)
			throws TemplateException, IOException {
		List<Diary> diaries = Lists.newArrayList();
		PageBounds pageBounds = PageSplitUtils.getPageBounds(params, env);
		pageBounds.setOrders(Order.formString("IS_TOP.DESC,CREATE_TIME.DESC"));
		if (params.containsKey("diary") && params.get("diary") != null) {
			String userId = params.get("userId").toString();
			BeanModel beanModel = (BeanModel) params.get("diary");
			if (beanModel != null) {
				Diary diary = (Diary) beanModel.getWrappedObject();
				Map<String, Object> param = Maps.newHashMap();
				param.put("creator", userId);
				if (diary.getDiaryCategory() != null && diary.getDiaryCategory().getId() != null) {
					param.put("diaryCategory", diary.getDiaryCategory().getId());
				}
				if(!ThreadContext.getUser().getId().equals(userId)){
					param.put("visitPermission",DiaryVisitPermissionType.PUBLIC);
				}
				param.put("title", diary.getTitle());
				diaries = diaryService.listDiary(param, pageBounds);
				env.setVariable("diaries", new DefaultObjectWrapper().wrap(diaries));
			}
		}
		if(Collections3.isNotEmpty(diaries)){
			Map<String,AttitudeUser> attitudeUsers =  attitudeService.getAttitudesByRelationIdsAndRelationType(Collections3.extractToList(diaries, "id"), "zoneDiary",ThreadContext.getUser().getId());
			env.setVariable("attitudeUsers" , new DefaultObjectWrapper().wrap(attitudeUsers));
		}
		if (pageBounds != null && pageBounds.isContainsTotalCount()) {
			PageList pageList = (PageList)diaries;
			env.setVariable("paginator" , new DefaultObjectWrapper().wrap(pageList.getPaginator()));
		}
		body.render(env.getOut());
	}
}