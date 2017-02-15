package com.haoyu.usercenter.listener;

import javax.annotation.Resource;

import org.springframework.context.ApplicationListener;
import org.springframework.stereotype.Component;

import com.haoyu.sip.comment.entity.Comment;
import com.haoyu.sip.comment.event.DeleteCommentEvent;
import com.haoyu.sip.diary.entity.Diary;
import com.haoyu.sip.diary.service.IDiaryService;
import com.haoyu.sip.dynamic.entity.Dynamic;
import com.haoyu.sip.dynamic.service.IDynamicService;

@Component
public class UCDeleteCommentListener implements ApplicationListener<DeleteCommentEvent>{
	@Resource
	private IDynamicService dynamicService;
	@Resource
	private IDiaryService diaryService;

	@Override
	public void onApplicationEvent(DeleteCommentEvent event) {
		Comment comment = (Comment) event.getSource();
		if(comment.getRelation()!=null){
			if(comment.getRelation().getType().equals("dynamic")){
				Dynamic dynamic = new Dynamic();
				dynamic.setReplyNum(1);
				dynamic.setId(comment.getRelation().getId());
				dynamicService.update(dynamic);
			}
			if("zoneDiary".equals(comment.getRelation().getType())){
				Diary diary = new Diary();
				diary.setId(comment.getRelation().getId());
				diary.setCommentNum(1);
				diaryService.updateDiary(diary);
			}
		}
	}

}
