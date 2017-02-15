package com.haoyu.usercenter.templates;

import java.io.IOException;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.lang3.StringUtils;
import org.springframework.stereotype.Component;

import com.google.common.collect.Lists;
import com.haoyu.sip.attitude.entity.AttitudeUser;
import com.haoyu.sip.attitude.service.IAttitudeService;
import com.haoyu.sip.comment.entity.Comment;
import com.haoyu.sip.comment.service.ICommentService;
import com.haoyu.sip.core.entity.Relation;
import com.haoyu.sip.core.utils.ThreadContext;
import com.haoyu.sip.core.web.SearchParam;
import com.haoyu.sip.gallery.entity.Photo;
import com.haoyu.sip.gallery.service.IPhotoService;
import com.haoyu.sip.utils.Collections3;

import freemarker.core.Environment;
import freemarker.template.DefaultObjectWrapper;
import freemarker.template.TemplateDirectiveBody;
import freemarker.template.TemplateDirectiveModel;
import freemarker.template.TemplateException;
import freemarker.template.TemplateModel;

@Component
public class PhotoGalleryPhotoDataDirective implements TemplateDirectiveModel{
	@Resource
	private IPhotoService photoService;
	@Resource
	private ICommentService commentService;
	@Resource
	private IAttitudeService attitudeService;
	
	@Override
	public void execute(Environment env, Map params, TemplateModel[] loopVars, TemplateDirectiveBody body) throws TemplateException, IOException {
		if(params.containsKey("id")){
			String id = params.get("id").toString();
			Photo photo = photoService.findPhotoById(id);
			if(params.containsKey("commentRelationId")){
				String commentRelationId = params.get("commentRelationId").toString();
				SearchParam searchParam = new SearchParam();
				searchParam.getParamMap().put("relationId", commentRelationId);
				searchParam.getParamMap().put("getChild", true);
				List<Comment> comments = commentService.list(searchParam, null, true);
				int commentNum = 0;
				if(CollectionUtils.isNotEmpty(comments)){
					commentNum = comments.size();
					comments = buildTree(comments);
				}
				if(CollectionUtils.isNotEmpty(comments)){
					env.setVariable("comments", new DefaultObjectWrapper().wrap(comments));
					env.setVariable("commentNum", new DefaultObjectWrapper().wrap(commentNum));
				}
			}
			if(params.containsKey("isGetattitude")){
				if(params.get("isGetattitude").toString().equals("Y")){
					List<String> relationId = Lists.newArrayList();
					relationId.add(id);
					Map<String, AttitudeUser> myAttitudeUserMap = attitudeService.getAttitudesByRelationIdsAndRelationType(relationId, "photo", ThreadContext.getUser().getId());
					env.setVariable("myAttitudeUserMap", new DefaultObjectWrapper().wrap(myAttitudeUserMap));
					Relation relation = new Relation(id);
					relation.setType("photo");
					List<AttitudeUser> attitudeUsers = attitudeService.findAttitudeUserByAttitudeAndRelation("support", relation, null);
					int supportNum = 0;
					if(CollectionUtils.isNotEmpty(attitudeUsers)){
						supportNum = attitudeUsers.size();
					}
					env.setVariable("supportNum", new DefaultObjectWrapper().wrap(supportNum));
				}
			}
			env.setVariable("photo", new DefaultObjectWrapper().wrap(photo));
		}
		body.render(env.getOut());
	}
	
	private List<Comment> buildTree(List<Comment> comments) {
		List<Comment> root = Lists.newArrayList();
		if (CollectionUtils.isNotEmpty(comments)) {
			Map<String, Comment> commentMap = Collections3.extractToMap(comments, "id", null);
			for (Comment comment : comments) {
				if(StringUtils.isNotEmpty(comment.getParentId())){
					comment.setParentComment(commentMap.get(comment.getParentId()));
				}
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
