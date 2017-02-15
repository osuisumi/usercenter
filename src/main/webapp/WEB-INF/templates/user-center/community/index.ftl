<#include "/user-center/include/layout.ftl"/>
<@layout>
<@communityStatDirective userId=Session.loginer.id>
	<#assign signStat=(communityStat.signStat)!>
</@communityStatDirective>

<@communityResultsDirective userId=Session.loginer.id orders='START_TIME.DESC'>
	<#if (communityResults?size>0)>
		<#assign communityResult=(communityResults[0])!>
	</#if>
	<#assign communityResults=communityResults> 
</@communityResultsDirective>

<#assign trainIds = []>
<#list communityResults as result>
	<#if '' != (result.relation.id)!''>
		<#assign trainIds = trainIds + [result.relation.id]>
	</#if>
</#list>

<#if (trainIds?size>0)>
	<@trainMapDirective ids=trainIds>
		<#assign trainMap=trainMap >
	</@trainMapDirective>
</#if>
<div class="g-auto">
	<div class="m-user-community">
	    <div class="m-teach-wsTl">
	        <h3 class="m-user-tl"><i></i>研修社区</h3>
	    </div>
	    <div class="m-user-communityTxt">
	       <!--  <div class="m-COMbd-who">
	            <a href="javascript:;">
	                <span class="imgwho"><i></i></span>
	                <span class="name">$</span>
	            </a>
	            <span class="who-icon"></span>
	        </div>         -->
	        <div class="m-COMbd-nav">
	
	            <ul class="m-COMbd-navR">
	                <li>
	                    <a href="javascript:;">
	                        <strong>${(signStat.signLastNum)!0 }</strong>
	                        <p class="txt"><i class="unstop-times"></i>连续签到(天)</p>
	
	                    </a>
	                </li>
	                <li>
	                    <a href="javascript:;">
	                        <strong>${(signStat.signNum)!0 }</strong>
	                        <p class="txt"><i class="u-all-times"></i>总天数(天)</p>
	                    </a>
	                </li>
	                <li>
	                    <a href="javascript:;">
	                        <strong>${(communityStat.discussionNum)!0 }</strong>
	                        <p class="txt"><i class="u-speaking"></i>发表研说</p>
	
	                    </a>
	                </li>
	                <li>
	                    <a href="javascript:;">
	                        <strong>${(communityStat.lessonNum)!0 }</strong>
	                        <p class="txt"><i class="u-thinking"></i>创课想法</p>
	                    </a>
	                </li>
	                <li>
	                    <a href="javascript:;">
	                        <strong>${(communityStat.movementNum)!0 }</strong>
	                        <p class="txt"><i class="u-active"></i>参与活动</p>
	
	                    </a>
	                </li>   
	                <li>
	                    <a href="javascript:;">
	                        <strong>${(communityStat.score)!0 }</strong>
	                        <p class="txt"><i class="u-score"></i>培训期积分</p>
	                    </a>
	                </li>                                                
	            </ul> 
	            <#if '/user-center/lingnan' != (app_path)!'' >
	            	<a href="${PropertiesLoader.get('cmts.domain') }" target="_blank" class="m-bulid-wsbtn">进入研修社区&gt;</a>
	            <#else>	
	            	<a href="${PropertiesLoader.get('cmts.domain') }cmts/indexWithDept" target="_blank" class="m-bulid-wsbtn">进入校本社区&gt;</a>
	            	<br><br>
	            	<a href="${PropertiesLoader.get('cmts.domain') }" target="_blank" class="m-bulid-wsbtn">进入区域社区&gt;</a>
	            </#if>
	        </div>               
	    </div>
	    <div  class="m-user-commun-Reslut">
	        <div class="m-comm-Rtl">
	            <h3>培训研修社区成绩</h3> 
	            <a href="/userCenter/community/point">了解积分规则？</a>
	        </div>
	        <table class="m-WS-train-table" style="width: 95%">
                <thead>
                    <tr>
                        <th>培训项目</th>
                        <th>考核时间</th>
                        <th>状态</th>
                        <th>获得积分</th>
                        <th>研修成绩</th>
                        <th>优秀勋章</th>
                    </tr>                                
                </thead>
                <tbody>
                	<#if (communityResults?size > 0)>
                		<#list communityResults as result>
	                		<tr>
		                        <td class="h-txt">${(trainMap[result.relation.id].name)!}</td>
		                        <td>
		                        	${(result.communityRelation.timePeriod.startTime)?string('yyyy/MM/dd')!} 
		                        	~ 
		                        	${(result.communityRelation.timePeriod.endTime)?string('yyyy/MM/dd')!} 
		                        </td>
		                        <td>
		                        	<#if !TimeUtils.hasBegun((result.communityRelation.timePeriod.startTime)!'')>
		                        		<i class="u-tab-end"></i>未开始
		                        	<#elseif TimeUtils.hasEnded((result.communityRelation.timePeriod.endTime)!'')>
		                        		<i class="u-tab-end"></i>已结束
		                        	<#else>	
		                        		<i class="u-tab-starting"></i>进行中
		                        	</#if>
		                        </td>
		                        <td class="tab-bold">${(result.score)!0}</td>
		                        <td>
									<#if 'excellent' == (result.state)!''>
										优秀
									<#elseif 'passed' == (result.state)!''>
										合格
									<#else>
										--
									</#if>
								</td>
		                        <td>
		                        	<#if 'excellent' == (result.state)!''>
		                        		<i class="who-icon"></i>
		                        	</#if>
		                        </td>
		                    </tr>
	                	</#list>
                	<#else>
                		<tr>
		                	<td colspan="6">您还未参与社区研修</td>
                	</#if>
	            </tbody>
	        </table>    
	    </div>
	    <@communityNumStatDirective>
		    <div class="m-commun-count">
		        <div class="m-comm-Rtl">
		            <h3>培训研修社区统计</h3> 
		        </div>
		        <!-- <p class="time">统计日期：2016/03/01</p> -->
		        <ul class="m-echart-cont">
		            <li>
		                <div id="main" class="cont">
		                    
		                </div>
		                <div class="discr-txt">
		                    <h3>研说参与率</h3>
		                    <p>共有 <strong>${communityNumStat.discussionCreatorNum } </strong>人</p>
		                    <p>发表 <strong>${communityNumStat.discussionNum } </strong> 条研说</p>
		                </div>
		                <div class="icon-speack-bg echart-ico"></div>
		                <div class="rate-txt">
		                    <p><strong>${(communityNumStat.discussionPostCreatorNum / communityNumStat.personNum * 100) }%</strong> 对他人研说发表过评论</p>
		                    <p><strong>${(communityNumStat.discussionCreatorNum / communityNumStat.personNum * 100) }%</strong> 学员发表过研说</p>
		                    <p><strong>${(communityNumStat.discussionNotAttemptNum / communityNumStat.personNum * 100) }%</strong> 未参与应用</p>
		                </div>
		            </li>
		            <li>
		                <div id="main2" class="cont">
		                    
		                </div>
		                <div class="discr-txt">
		                    <h3>创课参与率</h3>
		                    <p>共有 <strong>${communityNumStat.lessonNum } </strong>人发表 ${communityNumStat.lessonNum } 个创课想法</p>
		                    <p>发表 <strong>${communityNumStat.adviceNum }</strong>个创课建议</p>
		                    <p>发表 <strong>${communityNumStat.lessonPassNum }</strong>个创课通过专家评审</p>
		                </div>
		                <div class="icon-build-bg echart-ico"></div>
		                <div class="rate-txt">
		                    <p><strong>${communityNumStat.adviceCreatorNum  / communityNumStat.personNum * 100 }%</strong> 参加过他人的创课</p>
		                    <p><strong>${communityNumStat.lessonCreatorNum  / communityNumStat.personNum * 100 }%</strong> 学员发起过创课</p>
		                    <p><strong>${communityNumStat.lessonNotAttemptNum  / communityNumStat.personNum * 100 }%</strong> 未参与应用</p>
		                    
		                </div>                            
		            </li>
		            <li>
		                <div id="main3" class="cont">
		                    
		                </div>
		                <div class="discr-txt">
		                    <h3>活动参与率</h3>
		                    <p>共有 <strong>${communityNumStat.movementNum } </strong>个活动</p>
		                    <p>报名 <strong>${communityNumStat.movementRegisterNum }</strong>人次</p>
		                </div>
		                <div class="icon-actv-bg echart-ico"></div>
		                <div class="rate-txt">
		                    <p><strong>${communityNumStat.movementRegisterCreatorNum  / communityNumStat.personNum * 100 }%</strong> 参与活动</p>
		                    <p><strong>${communityNumStat.movementCreatorNum  / communityNumStat.personNum * 100 }%</strong> 学员发起过活动</p>
		                    <p><strong>${communityNumStat.movementNotAttemptNum  / communityNumStat.personNum * 100}%</strong> 未参与应用</p>
		                </div>                            
		            </li>
		        </ul>                    
		    </div>         
		</@communityNumStatDirective>         
	</div>
</div>
<script type="text/javascript" src="${ctx }/common/js/echarts/echarts.min.js"></script>
<script>
	$(function(){
		changeTab('community');
	});
	
	$(function(){

	    //echarts（资源统计）
	    // 基于准备好的dom，初始化echarts实例
	    var myChart = echarts.init(document.getElementById('main'));

	    // 指定图表的配置项和数据
	    var dataStyle = {
	        normal: {
	            label: {show:false},
	            labelLine: {show:false}
	        }
	    };
	    var placeHolderStyle = {
    		normal : {
                color: 'rgba(0,0,0,0)',
                label: {show:false},
                labelLine: {show:false}
            },
            emphasis : {
                color: 'rgba(0,0,0,0)'
            }
	    };
	    option = {
	        title: {
	            
	            x: 'center',
	            y: 'center',
	            itemGap: 20,
	            textStyle : {
	                color : 'rgba(30,144,255,0.8)',
	                fontFamily : '微软雅黑',
	                fontSize : 35,
	                fontWeight : 'bolder'
	            }
	        },
	        tooltip : {
	            show: true,
	            formatter: "{a} <br/>{b} : {c} ({d}%)"
	        },
	        legend: {
	            orient : 'vertical',
	            x : document.getElementById('main').offsetWidth / 2,
	            y : 20,
	            itemGap:12,
	            // data:['70% 对他人研说发表过评论','68% 学员发表过研说','60% 未参与应用']
	        },
	        // toolbox: {
	        //     show : true,
	        //     feature : {
	        //         mark : {show: true},
	        //         dataView : {show: true, readOnly: false},
	        //         restore : {show: true},
	        //         saveAsImage : {show: true}
	        //     }
	        // },

	        series : [
	            {
	                type:'pie',
	                clockWise:false,
	                center: ['40%', '50%'],
	                radius : [80, 100],
	                itemStyle : dataStyle,
	                data:[
	                    {
	                        value:"${(communityNumStat.discussionPostCreatorNum / communityNumStat.personNum * 100) }",
	                    },
	                    {
	                        value:"${100 - (communityNumStat.discussionPostCreatorNum / communityNumStat.personNum * 100) }",
	                        itemStyle : placeHolderStyle
	                    }
	                ]
	            },
	            {
	                type:'pie',
	                clockWise:false,
	                center: ['40%', '50%'],
	                radius : [60, 80],
	                itemStyle : dataStyle,
	                data:[
	                      {
		                        value:"${(communityNumStat.discussionCreatorNum / communityNumStat.personNum * 100) }",
		                    },
		                    {
		                        value:"${100 - (communityNumStat.discussionCreatorNum / communityNumStat.personNum * 100) }",
		                        itemStyle : placeHolderStyle
		                    }
	                ]
	            },
	            {
	                type:'pie',
	                clockWise:false,
	                center: ['40%', '50%'],
	                radius : [40, 60],
	                itemStyle : dataStyle,
	                data:[
	                     {
	                        value:"${communityNumStat.discussionNotAttemptNum / communityNumStat.personNum * 100}",
	                    },
	                    {
	                        value:"${100 - (communityNumStat.discussionNotAttemptNum / communityNumStat.personNum * 100)}",
	                        itemStyle : placeHolderStyle
	                    }
	                ]
	            }
	        ],
	        color : ['#cf502a','#f76e02','#ffb530']
	    };
	    // 使用刚指定的配置项和数据显示图表。
	    myChart.setOption(option);


	    //echarts（资源统计）
	    // 基于准备好的dom，初始化echarts实例
	    var myChart = echarts.init(document.getElementById('main2'));

	    option2 = {
	        title: {
	            x: 'center',
	            y: 'center',
	            itemGap: 20,
	            textStyle : {
	                color : 'rgba(30,144,255,0.8)',
	                fontFamily : '微软雅黑',
	                fontSize : 35,
	                fontWeight : 'bolder'
	            }
	        },
	        tooltip : {
	            show: true,
	            formatter: "{a} <br/>{b} : {c} ({d}%)"
	        },
	        legend: {
	            orient : 'vertical',
	            x : document.getElementById('main2').offsetWidth / 2,
	            y : 20,
	            itemGap:12,
	            // data:['70% 对他人研说发表过评论','68% 学员发表过研说','50% 未参与应用']
	        },
	        // toolbox: {
	        //     show : true,
	        //     feature : {
	        //         mark : {show: true},
	        //         dataView : {show: true, readOnly: false},
	        //         restore : {show: true},
	        //         saveAsImage : {show: true}
	        //     }
	        // },

	        series : [
	            {
	                type:'pie',
	                clockWise:false,
	                center: ['40%', '50%'],
	                radius : [80, 100],
	                itemStyle : dataStyle,
	                data:[
	                     {
	                        value:"${communityNumStat.adviceCreatorNum / communityNumStat.personNum * 100}",
	                    },
	                    {
	                        value:"${100 - (communityNumStat.adviceCreatorNum / communityNumStat.personNum * 100)}",
	                        itemStyle : placeHolderStyle
	                    }
	                ]
	            },
	            {
	                type:'pie',
	                clockWise:false,
	                center: ['40%', '50%'],
	                radius : [60, 80],
	                itemStyle : dataStyle,
	                data:[
	                     {
	                        value:"${communityNumStat.lessonCreatorNum / communityNumStat.personNum * 100}",
	                    },
	                    {
	                        value:"${100 - (communityNumStat.lessonCreatorNum / communityNumStat.personNum * 100)}",
	                        itemStyle : placeHolderStyle
	                    }
	                ]
	            },
	            {
	                type:'pie',
	                clockWise:false,
	                center: ['40%', '50%'],
	                radius : [40, 60],
	                itemStyle : dataStyle,
	                data:[
	                     {
	                        value:"${communityNumStat.lessonNotAttemptNum / communityNumStat.personNum * 100}",
	                    },
	                    {
	                        value:"${100 - (communityNumStat.lessonNotAttemptNum / communityNumStat.personNum * 100)}",
	                        itemStyle : placeHolderStyle
	                    }
	                ]
	            }
	        ],
	        color : ['#457fc1','#4f92db','#88bbff']
	    };
	    // 使用刚指定的配置项和数据显示图表。
	    myChart.setOption(option2);



	    //echarts（资源统计）
	    // 基于准备好的dom，初始化echarts实例
	    var myChart = echarts.init(document.getElementById('main3'));

	    option3 = {
	        title: {
	            x: 'center',
	            y: 'center',
	            itemGap: 20,
	            textStyle : {
	                color : 'rgba(30,144,255,0.8)',
	                fontFamily : '微软雅黑',
	                fontSize : 35,
	                fontWeight : 'bolder'
	            }
	        },
	        tooltip : {
	            show: true,
	            formatter: "{a} <br/>{b} : {c} ({d}%)"
	        },
	        legend: {
	            orient : 'vertical',
	            x : document.getElementById('main3').offsetWidth / 2,
	            y : 20,
	            itemGap:12,
	            // data:['70% 对他人研说发表过评论','68% 学员发表过研说','50% 未参与应用']
	        },
	        // toolbox: {
	        //     show : true,
	        //     feature : {
	        //         mark : {show: true},
	        //         dataView : {show: true, readOnly: false},
	        //         restore : {show: true},
	        //         saveAsImage : {show: true}
	        //     }
	        // },

	        series : [
	            {
	                type:'pie',
	                clockWise:false,
	                center: ['40%', '50%'],
	                radius : [80, 100],
	                itemStyle : dataStyle,
	                data:[
	                      {
	                        value:"${communityNumStat.movementRegisterCreatorNum / communityNumStat.personNum * 100}",
	                    },
	                    {
	                        value:"${100 - (communityNumStat.movementRegisterCreatorNum / communityNumStat.personNum * 100)}",
	                        itemStyle : placeHolderStyle
	                    }
	                ]
	            },
	            {
	                type:'pie',
	                clockWise:false,
	                center: ['40%', '50%'],
	                radius : [60, 80],
	                itemStyle : dataStyle,
	                data:[
	                    {
	                        value:"${communityNumStat.movementCreatorNum / communityNumStat.personNum * 100}",
	                    },
	                    {
	                        value:"${100 - (communityNumStat.movementCreatorNum / communityNumStat.personNum * 100)}",
	                        itemStyle : placeHolderStyle
	                    }
	                ]
	            },
	            {
	                type:'pie',
	                clockWise:false,
	                center: ['40%', '50%'],
	                radius : [40, 60],
	                itemStyle : dataStyle,
	                data:[
	                    {
	                        value:"${communityNumStat.movementNotAttemptNum / communityNumStat.personNum * 100}",
	                    },
	                    {
	                        value:"${100 - (communityNumStat.movementNotAttemptNum / communityNumStat.personNum * 100)}",
	                        itemStyle : placeHolderStyle
	                    }
	                ]
	            }
	        ],
	        color : ['#949901','#b1b504','#d6da28']
	    };
	    // 使用刚指定的配置项和数据显示图表。
	    myChart.setOption(option3);

	});
</script>
</@layout>