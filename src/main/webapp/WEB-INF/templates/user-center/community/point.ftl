<#include "/user-center/include/layout.ftl"/> <@layout>
<div class="g-auto">
	<div class="m-community-score">
		<div class="g-crm c1">
			<span class="txt">您当前的位置： </span>
			<a href="/userCenter/community" title="首页">首页 </a> 
			<span class="trg">&gt;</span> 
			<em>积分规则</em>
		</div>
		<ul class="m-community-scoreinner">
			<li class="m-community-scoreinner1">
				<div class="m-comm-Rtl">
					<h3>
						<i class="u-comm-decrib"></i>研修社区概述
					</h3>
				</div>
				<p class="discrible">研修社区是教师培训中学、研、用培训思路中体现”用“的功能模块，主要围绕活跃教研学习氛围，促进交流拉近研修距离，体现学习成果实现教学实践进行建设，目的是让教师分享教学的宝贵经验和想法，共同提高教学创新能力。研修社区主要分为研说、创课、活动三大交流互动版块。</p>
				<ul class="discrible-list">
					<li><span>1、研说：</span>教师通过网站及移动APP，可发表培训感言、教学反思、教学随笔，学习日志等，由管理员进行内容监督及推优等管理；</li>
					<li><span>2、创课：</span>学员可通过教学想法的展示分享，一方面可以获得自我成就感和认同感，从而激发课堂教学创新的热情，另一方面还可以获得来自大众用户的反馈与建议，不断优化教学方式，获得喜欢的创新课堂教学想法可以得到平台支持在活动版区中进行课程的推广。</li>
					<li><span>3、活动：</span>通过活动版区，管理员可组织专家与学员进行线上线下互动问答，并从创课版区中选出最受大家喜欢并想观摩的课程组织创课观摩活动，学员可以通过报名的方式参与活动，报名后观加线下活动并可观看活动视频回放。</li>
				</ul>
			</li>
			<li class="m-community-scoreinner2">
				<div class="m-comm-Rtl">
					<h3>
						<i class="u-comm-score"></i>研修社区积分
					</h3>
				</div>
				<table class="m-WS-train-table">
					<thead>
						<tr>
							<th width="20%">序号</th>
							<th width="50%">获得积分项</th>
							<th width="30%">分值</th>
						</tr>
					</thead>
					<tbody>
						<@pointStrategysDirective relationId='cmts' orders='CREATE_TIME.DESC'>
							<#if pointStrategys??>
								<#list pointStrategys as pointStrategy>
									<tr>
										<td>${pointStrategy_index +1}</td>
										<td>${(pointStrategy.summary)!}</td>
										<td class="btheme-color">
											<#if pointStrategy.point??>
												${(pointStrategy.point)!}
											<#else>	
												扣除所得积分
											</#if>
										</td>
									</tr>
								</#list>
							</#if>
						</@pointStrategysDirective>
					</tbody>
				</table>
			</li>
		</ul>
	</div>
</div>
</@layout>
