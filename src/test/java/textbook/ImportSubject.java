package textbook;

import com.haoyu.sip.textbook.service.impl.TextBookRelationService;

import base.Base;

public class ImportSubject  extends Base{
	
	public static void main(String[] args) {
		TextBookRelationService tr  = (TextBookRelationService) ac.getBean("textBookRelationService");
		tr.importUtil("import.xls");
		
	}

}
