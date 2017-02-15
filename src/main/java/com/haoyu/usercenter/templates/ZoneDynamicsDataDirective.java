package com.haoyu.usercenter.templates;

import java.io.IOException;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.lang3.StringUtils;
import org.springframework.stereotype.Component;

import com.github.miemiedev.mybatis.paginator.domain.PageBounds;
import com.github.miemiedev.mybatis.paginator.domain.PageList;
import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import com.haoyu.ncts.utils.PageSplitUtils;
import com.haoyu.sip.attitude.entity.AttitudeUser;
import com.haoyu.sip.attitude.service.IAttitudeService;
import com.haoyu.sip.comment.entity.Comment;
import com.haoyu.sip.comment.service.ICommentService;
import com.haoyu.sip.core.utils.ThreadContext;
import com.haoyu.sip.core.web.SearchParam;
import com.haoyu.sip.dynamic.entity.Dynamic;
import com.haoyu.sip.utils.Collections3;
import com.haoyu.usercenter.dynamic.service.IDynamicBizService;

import freemarker.core.Environment;
import freemarker.template.DefaultObjectWrapper;
import freemarker.template.TemplateDirectiveBody;
import freemarker.template.TemplateDirectiveModel;
import freemarker.template.TemplateException;
import freemarker.template.TemplateModel;
import freemarker.template.TemplateModelException;

@Component
public class ZoneDynamicsDataDirective implements TemplateDirectiveModel {

	@Resource
	private IDynamicBizService dynamicBizService;
	@Resource
	private IAttitudeService attitudeService;
	@Resource
	private ICommentService commentService;

	@Override
	public void execute(Environment env, Map params, TemplateModel[] loopVars, TemplateDirectiveBody body) throws TemplateException, IOException {
		if(params.containsKey("userId")){
			String userId = params.get("userId").toString();
			PageBounds pageBounds = PageSplitUtils.getPageBounds(params, env);
			Map<String, Object> param = Maps.newHashMap();
			param.put("relationType", "zone");
			param.put("userId",userId);
			List<Dynamic> dynamics = dynamicBizService.ListDynamic(param, pageBounds, userId.equals(ThreadContext.getUser().getId()));
			if (CollectionUtils.isNotEmpty(dynamics)) {
				List<String> zoneDynamicIds = Collections3.extractToList(dynamics, "id");
				// 查询我的点赞情况
				Map<String, AttitudeUser> myAttitudeUserMap = attitudeService.getAttitudesByRelationIdsAndRelationType(zoneDynamicIds, "zoneDynamic", ThreadContext.getUser().getId());
				env.setVariable("myAttitudeUserMap", new DefaultObjectWrapper().wrap(myAttitudeUserMap));
				// 查询点赞的人
				setAttitudeUserMap(zoneDynamicIds, env);
				// 查询回复
				setComments(zoneDynamicIds, env);
			}
			if (pageBounds != null && pageBounds.isContainsTotalCount()) {
				PageList pageList = (PageList) dynamics;
				env.setVariable("paginator", new DefaultObjectWrapper().wrap(pageList.getPaginator()));
			}
			env.setVariable("zoneDynamics", new DefaultObjectWrapper().wrap(dynamics));
		}
		body.render(env.getOut());
	}

	private void setAttitudeUserMap(List<String> zoneDynamicIds, Environment env) throws TemplateModelException {
		Map<String, Object> parameter = Maps.newHashMap();
		parameter.put("relationIds", zoneDynamicIds);
		parameter.put("relationType", "zoneDynamic");
		parameter.put("attitude", "support");
		List<AttitudeUser> attitudeUsers = attitudeService.findAttitudeUserByParameter(parameter, null);
		if (CollectionUtils.isNotEmpty(attitudeUsers)) {
			Map<String, List<AttitudeUser>> attitudeUsersMap = Maps.newHashMap();
			for (AttitudeUser attitudeUser : attitudeUsers) {
				if (!attitudeUsersMap.containsKey(attitudeUser.getRelation().getId())) {
					List<AttitudeUser> item = Lists.newArrayList();
					item.add(attitudeUser);
					attitudeUsersMap.put(attitudeUser.getRelation().getId(), item);
				} else {
					attitudeUsersMap.get(attitudeUser.getRelation().getId()).add(attitudeUser);
				}
			}
			env.setVariable("attitudeUserMap", new DefaultObjectWrapper().wrap(attitudeUsersMap));
		}
	}

	private void setComments(List<String> zoneDynamicIds, Environment env) throws TemplateModelException {
		SearchParam searchParam = new SearchParam();
		searchParam.getParamMap().put("relationIds", zoneDynamicIds);
		List<Comment> comments = buildTree(commentService.list(searchParam, null,true));
		if (CollectionUtils.isNotEmpty(comments)) {
			Map<String, List<Comment>> commentsMap = Maps.newHashMap();
			for (Comment c : comments) {
				if (!commentsMap.containsKey(c.getRelation().getId())) {
					List<Comment> item = Lists.newArrayList();
					item.add(c);
					commentsMap.put(c.getRelation().getId(), item);
				} else {
					commentsMap.get(c.getRelation().getId()).add(c);
				}
			}
			env.setVariable("commentsMap", new DefaultObjectWrapper().wrap(commentsMap));
		}
	}

	private List<Comment> buildTree(List<Comment> comments) {
		List<Comment> root = Lists.newArrayList();
		if (CollectionUtils.isNotEmpty(comments)) {
			Map<String, Comment> commentMap = Collections3.extractToMap(comments, "id", null);
			for (Comment comment : comments) {
				if (StringUtils.isNotEmpty(comment.getMainId()) && !comment.getMainId().equals("null")) {
					Comment parent = commentMap.get(comment.getMainId());
					parent.getChildComments().add(comment);
				} else {
					root.add(commentMap.get(comment.getId()));
				}
			}
		}
		return root;
	}

}
