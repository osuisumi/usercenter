//package message;
//
//import java.util.List;
//
//import org.junit.Test;
//
//import com.google.common.collect.Lists;
//import com.haoyu.sip.core.entity.User;
//import com.haoyu.sip.core.utils.ThreadContext;
//import com.haoyu.sip.message.entity.Message;
//import com.haoyu.sip.message.service.IMessageService;
//
//import base.Base;
//
//public class MessageServiceTest extends Base{
//	
//	public static IMessageService messageService = (IMessageService) ac.getBean("messageService");
//	private Message getMessage(){
//		Message message = new Message();
//		return message;
//	}
//	
//	@Test
//	public void testSave(){
//		Message message = getMessage();
//		message.setSenderId("isumi");
//		message.setReceiverId("jojo");
//		message.setContent("请收我为徒");
//		messageService.createMessage(message);
//	}
//	
//	@Test
//	public void testSendToAll(){
//		ThreadContext.bind(new User("发Ius电话费"));
//		Message message = getMessage();
//		message.setTitle("系统通知");
//		message.setSenderId("超级管理员");
//		message.setContent("你好！欢迎来到二次元");
//		messageService.sendMessageToAllUser(message);
//	}
//	
//	@Test
//	public void testSendToUsers(){
//		ThreadContext.bind(new User("王金伟"));
//		Message message = getMessage();
//		message.setTitle("系统通知");
//		message.setSenderId("超级管理员");
//		message.setContent("明天炸火车");
//		List<String> reIds = Lists.newArrayList();
//		reIds.add("1");
//		reIds.add("2");
//		reIds.add("8e085b24-053f-11e6-a6db-00ff34dbf6f0");
//		reIds.add("8e0fa7e1-053f-11e6-a6db-00ff34dbf6f0");
//		messageService.sendMessageToUsers(message, reIds);
//	}
//
//}
