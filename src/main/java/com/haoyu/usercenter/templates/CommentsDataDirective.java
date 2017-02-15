package com.haoyu.usercenter.templates;

import java.io.IOException;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.lang3.StringUtils;
import org.springframework.stereotype.Component;

import com.google.common.collect.Lists;
import com.haoyu.sip.comment.entity.Comment;
import com.haoyu.sip.comment.service.ICommentService;
import com.haoyu.sip.core.entity.Relation;
import com.haoyu.sip.utils.Collections3;

import freemarker.core.Environment;
import freemarker.template.DefaultObjectWrapper;
import freemarker.template.TemplateDirectiveBody;
import freemarker.template.TemplateDirectiveModel;
import freemarker.template.TemplateException;
import freemarker.template.TemplateModel;

@Component
public class CommentsDataDirective implements TemplateDirectiveModel{

	@Resource
	private ICommentService commentService;
	@Override
	public void execute(Environment env, Map params, TemplateModel[] loopVars, TemplateDirectiveBody body) throws TemplateException, IOException {
		if(params.containsKey("relationId") && params.get("relationId")!=null){
			String relationId = params.get("relationId").toString();
			Relation relation = new Relation(relationId);
			List<Comment> comments = buildTree(commentService.findCommentByRelation(relation, null));
			env.setVariable("comments" , new DefaultObjectWrapper().wrap(comments));
		}
		body.render(env.getOut());
	}
	
	
	/**
	 * @param comments
	 */
	private List<Comment> buildTree(List<Comment> comments){
		List<Comment> root = Lists.newArrayList();
		if(CollectionUtils.isNotEmpty(comments)){
			Map<String,Comment> commentMap = Collections3.extractToMap(comments, "id", null);
			for(Comment comment:comments){
				if(StringUtils.isNotEmpty(comment.getParentId())){
					comment.setParentComment(commentMap.get(comment.getParentId()));
				}
				if(StringUtils.isNotEmpty(comment.getMainId())){
					Comment parent = commentMap.get(comment.getMainId());
					parent.getChildComments().add(comment);
				}else{
					root.add(commentMap.get(comment.getId()));
				}
			}
		}
		return root;
	}
	
}
