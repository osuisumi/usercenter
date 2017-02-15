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
import com.haoyu.sip.core.entity.Relation;
import com.haoyu.sip.core.entity.User;
import com.haoyu.sip.follow.entity.Follow;
import com.haoyu.sip.follow.service.IFollowService;
import com.haoyu.sip.user.entity.UserInfo;
import com.haoyu.sip.user.service.IUserInfoService;
import com.haoyu.sip.utils.Collections3;
import com.haoyu.usercenter.zone.follow.utils.UserFollowType;

import freemarker.core.Environment;
import freemarker.template.DefaultObjectWrapper;
import freemarker.template.TemplateDirectiveBody;
import freemarker.template.TemplateDirectiveModel;
import freemarker.template.TemplateException;
import freemarker.template.TemplateModel;

@Component
public class FollowUserDataDirective implements TemplateDirectiveModel{
	
	@Resource
	private IUserInfoService userInfoService;
	@Resource
	private IFollowService followService;

	@Override
	public void execute(Environment env, Map params, TemplateModel[] loopVars, TemplateDirectiveBody body) throws TemplateException, IOException {
		List<UserInfo> result = Lists.newArrayList();
		if(params.containsKey("type")&&params.get("type")!=null){
			String userId = params.get("userId").toString();
			String type = params.get("type").toString();
			if(type.equals("follow")){
				String followName = params.get("followName").toString();
				Follow follow = new Follow();
				follow.setCreator(new User(userId));
				Relation relation = new Relation();
				relation.setType(UserFollowType.FOLLOW_TYPE);
				follow.setFollowEntity(relation);
				PageBounds pageBounds = PageSplitUtils.getPageBounds(params, env);
				List<Follow> follows = followService.findFollowByFollow(follow, null);
				if(CollectionUtils.isNotEmpty(follows)){
					Map<String,Object> param = Maps.newHashMap();
					param.put("ids",Collections3.extractToList(follows,"followEntity.id"));
					if(StringUtils.isNotEmpty(followName)){
						param.put("realName",followName);
					}
					result = userInfoService.listUser(param, pageBounds);
					if(pageBounds!=null && pageBounds.isContainsTotalCount()){
						PageList pageList = (PageList)result;
						env.setVariable("paginator" , new DefaultObjectWrapper().wrap(pageList.getPaginator()));
					}
				}
				
			}else if(type.equals("fans")){
				String fansName = params.get("fansName").toString();
				Follow follow = new Follow();
				Relation relation = new Relation(userId);
				relation.setType(UserFollowType.FOLLOW_TYPE);
				follow.setFollowEntity(relation);
				PageBounds pageBounds = PageSplitUtils.getPageBounds(params, env);
				List<Follow> follows = followService.findFollowByFollow(follow, null);
				if(CollectionUtils.isNotEmpty(follows)){
					Map<String,Object> param = Maps.newHashMap();
					param.put("ids",Collections3.extractToList(follows, "creator.id"));
					if(StringUtils.isNotEmpty(fansName)){
						param.put("realName",fansName);
					}
					result = userInfoService.listUser(param,pageBounds);
					if(pageBounds!=null &&pageBounds.isContainsTotalCount()){
						PageList pageList = (PageList)result;
						env.setVariable("paginator" , new DefaultObjectWrapper().wrap(pageList.getPaginator()));
					}
				}

			}
		}
		env.setVariable("userInfos" , new DefaultObjectWrapper().wrap(result));
		body.render(env.getOut());
	}

}
