<div id="calendar"></div>
<script>
	$(function() {
		changeZoneItem('schedule');
    	activityCalenda.init();
    	loadSchedules();
	})
	function loadSchedules() {
		var sections = $('#add-bg-content dd p');
		var relationIds = '';
		$.each(sections, function(i, n) {
			if (relationIds == '') {
				relationIds = $(n).attr('id');
			} else {
				relationIds = relationIds + ',' + $(n).attr('id');
			}
		});
		var view = $('#calendar').fullCalendar('getView');
		var startDate = (new Date(view.start)).format('yyyy-MM-dd');
		var endDate = (new Date(view.end)).format('yyyy-MM-dd');
		$.get('${ctx}/study/schedule/api', {
			minStartTime : startDate,
			maxStartTime : endDate,
			"creator.id" : $('#userId').val()
		}, function(response) {
			$.each(response, function(i, sche) {
				activityCalenda.add_schedule(sche);
			});
			$('#calendar .fc-first').children('div').attr('style', '');
			removeDelBtn();
		});
	}

	function jump(p) {
		if ($(p).attr('type') == 'course_study') {
			window.location.href = $(p).attr('url');
		}
	}
	
	function removeDelBtn(){
		var currentUserId = "${ThreadContext.getUser().getId()}";
		var zoneUserId = $('#userId').val();
		if(zoneUserId != currentUserId){
			$('.td-add-dl').remove();
		}
	}
	
</script>

