package base;

import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;

public class Base {
	public static ApplicationContext ac = new ClassPathXmlApplicationContext("applicationContext.xml");
	
	public static void main(String[] args) {
		System.out.println(ac.getBean("scheduleHandler"));
	}
}
