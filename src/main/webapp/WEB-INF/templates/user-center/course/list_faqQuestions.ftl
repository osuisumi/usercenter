<@faqs faqQuestion=faqQuestion pageBounds=pageBounds>
<#list faqQuestions as faq>
	<li>
		<div class="box">
			<div class="q-block">
				<h3 class="tt">${faq.content}</h3>
			</div>
			<ul class="m-studyA-lst">
				<#list faq.faqAnswers as answer>
				<li>
					<div class="a-block">
						<div class="sign">
							<span>答</span>
						</div>
						<p class="a-txt">
							${answer.content}
						</p>
					</div>
				</li>
				</#list>
			</ul>
		</div>
	</li>
</#list>
<script>
	$(function(){
		$('#faqCount').text('${(paginator.totalCount)!}');
		var warpDiv = $('#faqQuestionList').closest('div');
		var pageInput = $(warpDiv).find('.page').eq(0);
		var limitInput = $(warpDiv).find('.limit').eq(0);
		var totalCountInput = $(warpDiv).find('.totalCount').eq(0);
		var page = '${(paginator.page)!1}';
		var limit = '${(paginator.limit)!0}';
		var totalCount = '${(paginator.totalCount)!0}';
		pageInput.val(page);
		limitInput.val(limit);
		totalCountInput.val(totalCount);
		if(totalCount<=limit){
			$('#pageDiv').hide();
		}
	})
</script>
</@faqs>