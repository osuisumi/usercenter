<#include "/user-center/include/layout.ftl"/>
<@layout>
	<div class="g-user-bd">
        <div class="g-auto">
            <div class="m-user">
                <div class="g-CourseList-tp">
                    <h2 class="tt">&nbsp;项目工作坊管理<span>Workshop management</span></h2>
                    <#--<label class="m-srh">
                        <input type="text" vaule="" class="ipt" placeholder="搜索">
                        <i class="u-srh1-ico"></i>
                    </label>-->
                </div>
                <div class="g-courseList-bd">
                    <#--<div class="g-clist-optRow">
                        <div class="m-clist-tabli">
                            <a href="javascript:void(0);" class="z-crt"><span>全部</span><i class="trg"></i></a>
                            <a href="javascript:void(0);"><span>已发布</span>（24）<i class="trg"></i></a>
                            <a href="javascript:void(0);"><span>未发布</span>（3）<i class="trg"></i></a>
                        </div>
                        <div class="m-viewMode">
                            <a href="workshop-manage.html" class="u-view-list z-crt" title="列表模式"><i class="u-viewL-ico"></i></a>
                            <a href="workshop-manage2.html" class="u-view-tiled" title="平铺模式"><i class="u-viewT-ico"></i></a>
                        </div>
                    </div>-->
                    <@workshopsDirective type='train' roles='mastermember' userId=Session.loginer.id getTrainName='Y'>
                    	<#assign workshops = workshops>
                    </@workshopsDirective>
                    <#assign workshopIds = []>
					<#if workshops??>
						<#list workshops as workshop>
							<#assign workshopIds = workshopIds + [workshop.id]/>
						</#list>
					</#if>
					<#if (workshopIds?size>0)>
						<@workshopUsersMapDirective workshopIds=workshopIds!>
							<#assign workshopUserMap=workshopUserMap>
						</@workshopUsersMapDirective>
					</#if>
	                    <div class="g-clist-cont">
	                        <ul class="m-user-selectList m-user-selectList2">
	                        	<#list workshops as workshop>
	                        		<#if (workshopUserMap[workshop.id])??>
										<#list workshopUserMap[workshop.id] as wu>
											<#if (wu.user.id) == Session.loginer.id>
												<#assign role=((wu.role)!'') />
												<#assign workshopUser = wu>
											</#if>
										</#list>
									</#if>
		                            <li>
		                                <a href="${PropertiesLoader.get('wsts.domain') }workshop/${workshop.id}" target="_blank">
		                                	<#import "/common/image.ftl" as image/>
											<@image.imageFtl url="${(workshop.imageUrl)! }" default="${app_path }/images/defaultWorkshop.png" />	
		                                	<#if ((workshop.type)!'') = 'train'>
												<#if ((workshop.isTemplate)!'') = 'Y'>
													<span class="tip-ws example-ws">示范性工作坊</span>
													<#assign wtype='template'>
												<#else>
													<span class="tip-ws item-ws">项目工作坊</span>
													<#assign wtype='train'>
												</#if>
											<#else>
												<span class="tip-ws person-ws">个人工作坊</span>
												<#assign wtype='personal'>
											</#if>
		                                </a>
		                                <div class="m-user-selectList-txt">
		                                    <div class="link-tl">
		                                    	<#if 'master' = (role)!''>
													<ins class="unpass">坊主</ins>
												<#elseif 'student' = (role)!''>
													<ins class="verifying">学员</ins>
												<#elseif 'member' = (role)!''>
													<ins class="pass">助理</ins>
												</#if>
		                                        <h4><a href="${PropertiesLoader.get('wsts.domain') }workshop/${workshop.id}" target="_blank">
		                                        	${workshop.title!}
		                                        </a></h4>                                        
		                                    </div>
		                                    <#if '' != (workshop.trainName)!''>
		                                    	<p>
			                                        <span class="con1"><i class="u-user-sl-ico u-user-sl-ico02"></i>${(workshop.trainName)!}</span>
			                                    </p>
		                                    </#if>
		                                    <#--<p>
		                                        <span class="con1">
		                                            <i class="u-user-sl-ico u-user-sl-ico03"></i>开始时间：<span>2015/12/17</span> 
		                                            <em class="u-get-tip u-excellent-tip">未开始</em>
		                                        </span>                                   
		
		                                    </p>-->                                   
		                                </div>
		                                <a href="${PropertiesLoader.get('wsts.domain') }workshop/${workshop.id}" target="_blank" class="m-user-selectList-go">进入辅导&gt;</a>
		                            </li>
		                       	</#list>
	                        </ul>
	                        
	                    </div>
	            
                </div>
            </div>
        </div>
    </div>
</@layout>
