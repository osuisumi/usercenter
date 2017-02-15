package com.haoyu.usercenter.templates;

import java.io.IOException;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.TimeUnit;

import javax.annotation.Resource;

import org.apache.commons.lang3.StringUtils;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.data.redis.core.ValueOperations;

import com.google.common.collect.Maps;
import com.haoyu.cmts.community.entity.CommunityRelation;
import com.haoyu.cmts.community.entity.CommunityResult;
import com.haoyu.cmts.community.service.ICommunityRelationService;
import com.haoyu.cmts.community.service.ICommunityResultService;
import com.haoyu.ncts.course.entity.Course;
import com.haoyu.ncts.course.entity.CourseRegister;
import com.haoyu.ncts.course.service.ICourseRegisterService;
import com.haoyu.ncts.course.service.ICourseResultService;
import com.haoyu.ncts.course.utils.CourseRegisterState;
import com.haoyu.ncts.course.utils.CourseResultState;
import com.haoyu.sip.core.freemarker.AbstractTemplateDirectiveModel;
import com.haoyu.sip.core.mapper.JsonMapper;
import com.haoyu.sip.core.utils.PropertiesLoader;
import com.haoyu.sip.utils.Collections3;
import com.haoyu.tip.train.entity.Train;
import com.haoyu.tip.train.service.ITrainService;
import com.haoyu.wsts.workshop.entity.WorkshopUser;
import com.haoyu.wsts.workshop.service.IWorkshopUserService;
import com.haoyu.wsts.workshop.utils.WorkshopType;
import com.haoyu.wsts.workshop.utils.WorkshopUserRole;
import com.haoyu.wsts.workshop.utils.WorkshopUserState;

import freemarker.core.Environment;
import freemarker.template.DefaultObjectWrapper;
import freemarker.template.TemplateDirectiveBody;
import freemarker.template.TemplateException;
import freemarker.template.TemplateModel;

public class TrainResultDirective extends AbstractTemplateDirectiveModel{
	
	@Resource
	private ITrainService trainService;
	@Resource
	private ICourseRegisterService courseRegisterService;
	@Resource
	private ICourseResultService courseResultService;
	@Resource
	private IWorkshopUserService workshopUserService;
	@Resource
	private ICommunityResultService communityResultService;
	@Resource
	private ICommunityRelationService communityRelationService;
	@Resource
	private RedisTemplate redisTemplate;
	
	@Override
	public void execute(Environment env, Map params, TemplateModel[] loopVars, TemplateDirectiveBody body) throws TemplateException, IOException {
		Map<String,Object> parameter = getSelectParam(params);
		String trainId = (String) parameter.get("trainId");
		String userId = (String) parameter.get("userId");
		String key = PropertiesLoader.get("redis.app.key") + ":userCenterProgess:"+userId+":"+trainId;
		ValueOperations<String,Map<String, Object>> valueOper = redisTemplate.opsForValue();
		if(redisTemplate.hasKey(key)){
			Map<String, Object> trainResult = valueOper.get(key);
			env.setVariable("trainResult", new DefaultObjectWrapper().wrap(trainResult));
		}else{
			Map<String, Object> trainResult = Maps.newHashMap();
			Train train = trainService.findTrainById(trainId);
			String type = train.getType();
			if (StringUtils.isNotEmpty(type)) {
				String[] array = type.split(",");
				List<String> types = Arrays.asList(array);
				if (Collections3.isNotEmpty(types)) {
					if (types.contains("course")) {
						Map<String, Object> param = Maps.newHashMap();
						param.put("userId", userId);
						param.put("relationId", trainId);
						param.put("state", CourseRegisterState.PASS);
						List<CourseRegister> courseRegisters = courseRegisterService.listCourseRegister(param, null);
						int registerCourseNum = courseRegisters.size();
						int passCourseNum = 0;
						if (Collections3.isNotEmpty(courseRegisters)) {
							List<Course> courses = Collections3.extractToList(courseRegisters, "course");
							List<String> courseIds = Collections3.extractToList(courses, "id");
							param = Maps.newHashMap();
							param.put("userId", userId);
							param.put("courseIds", courseIds);
							param.put("state", CourseResultState.PASS);
							passCourseNum = courseResultService.getCount(param);
						}
						trainResult.put("registerCourseNum", registerCourseNum);
						trainResult.put("passCourseNum", passCourseNum);
					}
					if (types.contains("workshop")) {
						Map<String, Object> param = Maps.newHashMap();
						param.put("userId", userId);
						param.put("state", WorkshopUserState.PASS);
						param.put("relationId", trainId);
						param.put("type", WorkshopType.TRAIN);
						param.put("role", WorkshopUserRole.STUDENT);
						List<WorkshopUser> workshopUsers = workshopUserService.findWorkshopUsers(param, null);
						double wstsPoint = 0;
						double getWstsPoint = 0;
						if (Collections3.isNotEmpty(workshopUsers)) {
							wstsPoint = workshopUsers.get(0).getWorkshop().getQualifiedPoint()==null?0:workshopUsers.get(0).getWorkshop().getQualifiedPoint();
							getWstsPoint = workshopUsers.get(0).getWorkshopUserResult().getPoint()==null?0:workshopUsers.get(0).getWorkshopUserResult().getPoint();
//							if (TimeUtils.hasBegun(workshopUsers.get(0).getWorkshop().getTimePeriod().getStartTime(), train.getTrainingTime().getStartTime())) {
//								wstsState = "ing";
//							}
							trainResult.put("wstsState", workshopUsers.get(0).getWorkshopUserResult().getWorkshopResult());
						}
						trainResult.put("wstsPoint", wstsPoint);
						trainResult.put("getWstsPoint", getWstsPoint);
					}
					if (types.contains("community")) {
						Map<String, Object> param = Maps.newHashMap();
						param.put("relationId", trainId);
						CommunityRelation communityRelation = communityRelationService.getCommunityRelation(param);
						double cmtsPoint = 0;
						double getCmtsPoint = 0;
						if(communityRelation != null){
							param.put("userId", userId);
							List<CommunityResult> communityResults = communityResultService.listCommunityResult(param, null);
							cmtsPoint = communityRelation.getScore()==null?0:communityRelation.getScore().doubleValue();
							if (Collections3.isNotEmpty(communityResults)) {
								getCmtsPoint = communityResults.get(0).getScore()==null?0:communityResults.get(0).getScore().doubleValue();
//								if (TimeUtils.hasBegun(communityResults.get(0).getCommunityRelation().getTimePeriod().getStartTime(), train.getTrainingTime().getStartTime())) {
//									cmtsState = "ing";
//								}
							}
						}
						trainResult.put("cmtsPoint", cmtsPoint);
						trainResult.put("getCmtsPoint", getCmtsPoint);
					}
				}
			}
			String studyHoursType = train.getStudyHoursType();
			if (!"no_limit".equals(studyHoursType)) {
				Map<String, Object> map = new JsonMapper().fromJson(studyHoursType, HashMap.class);
				if (map != null) {
					if (map.containsKey("course")) {
						trainResult.put("courseStudyHours", Double.parseDouble((String)map.get("course")));
					}
					if (map.containsKey("workshop")) {
						trainResult.put("wstsStudyHours", Double.parseDouble((String)map.get("workshop")));
					}
					if (map.containsKey("community")) {
						trainResult.put("cmtsStudyHours", Double.parseDouble((String)map.get("community")));
					}
				}
			}
			valueOper.set(key, trainResult);
			redisTemplate.expire(key, 1, TimeUnit.HOURS);
			env.setVariable("trainResult", new DefaultObjectWrapper().wrap(trainResult));
		}
		body.render(env.getOut());
	}

}
