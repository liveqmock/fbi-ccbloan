package com.ccb.creditrating;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

/**
 * Created with IntelliJ IDEA.
 * User: Administrator
 * Date: 13-9-5
 * Time: ����9:23
 * To change this template use File | Settings | File Templates.
 */
public class FieldUtil {
    private static ArrayList<String> attrList;
    private static Map<String, String> fieldNameMaps;
    static {
        fieldNameMaps = new HashMap<String, String>();
        fieldNameMaps.put("AGE", "����");
        fieldNameMaps.put("SEX", "�Ա�");
        fieldNameMaps.put("MARISTA", "����״��");
        fieldNameMaps.put("HEALTH", "����״��");
        fieldNameMaps.put("LIVETYPE", "��������");
        fieldNameMaps.put("EDUCATION", "�Ļ��̶�");
        fieldNameMaps.put("CORPTYPE", "��λ���");
        fieldNameMaps.put("CORPFIN", "��λ����״��");
        fieldNameMaps.put("BUSIFUTURE", "������ҵ��չǰ��");
        fieldNameMaps.put("POSTTYPE", "ְ�񼶱�");
        fieldNameMaps.put("POSTLEVEL", "ְ��");
        fieldNameMaps.put("INCOME", "������");
        fieldNameMaps.put("HOMEAVEINCOME", "��ͥ�˾�������");
        fieldNameMaps.put("MEMBERFLG", "�Ƿ���Ա��");
        fieldNameMaps.put("ACTFLG", "�����˻�");
        fieldNameMaps.put("WORKYEARS", "��������");
        fieldNameMaps.put("SAVBAL", "���д�����");
        fieldNameMaps.put("BUSIRATE", "����ҵ������");
        fieldNameMaps.put("LOANSTA", "���н�����");
        fieldNameMaps.put("NATURE_SITUATION", "��Ȼ���");
        fieldNameMaps.put("PROFESSIONAL_SITUATION", "ְҵ���");
        fieldNameMaps.put("FAMILY_SITUATION", "��ͥ���");
        fieldNameMaps.put("BANK_SITUATION", "�����������");
        fieldNameMaps.put("OTHERLOANSTA", "�����������");
        //--------------------���ֱ�׼����----------------------------
        attrList = new ArrayList<String>();
        attrList.add("custname");
        attrList.add("sex");
        attrList.add("birthday");
        attrList.add("idno");
        attrList.add("corptype");
        attrList.add("corpname");
        attrList.add("corpfin");
        attrList.add("busifuture");
        attrList.add("corpzip");
        attrList.add("corptel");
        attrList.add("corpaddr");
        attrList.add("homeaddr");
        attrList.add("homezip");
        attrList.add("tel1");
        attrList.add("tel2");
        attrList.add("mobile1");
        attrList.add("livetype");
        attrList.add("education");
        attrList.add("marista");
        attrList.add("postlevel");
        attrList.add("deptname");
        attrList.add("post");
        attrList.add("posttype");
        attrList.add("workyears");
        attrList.add("income");
        attrList.add("homeincome");
        attrList.add("homepersons");
        attrList.add("homeaveincome");
        attrList.add("health");
        attrList.add("memberflg");
        attrList.add("actflg");
        attrList.add("savbal");
        attrList.add("busirate");
        attrList.add("loansta");
        attrList.add("otherloansta");
        attrList.add("spousename");
        attrList.add("spouseidno");
        attrList.add("spousecorpaddr");
        attrList.add("spousetel");
        attrList.add("spouseincome");
        attrList.add("taxregno");
        attrList.add("busilicno");
        attrList.add("remark");
    }

    public static String getValue(String key, String value) {
        String temp = "";
        if (key.equals("sex")) {
            if (value.equals("0")) temp = "Ů";
            else temp = "��";
        } else if (key.equals("idtype")) {
            if (value.equals("01")) temp = "���֤";
            else if (value.equals("02")) temp = "����֤";
            else if (value.equals("03")) temp = "�侯����֤";
        } else if (key.equals("corptype")) {
            if (value.equals("01")) temp = "������ҵ��λ";
            else if (value.equals("02")) temp = "����";
            else if (value.equals("03")) temp = "���пعɹ�˾";
            else if (value.equals("04")) temp = "���вιɹ�˾";
            else if (value.equals("05")) temp = "��������";
            else if (value.equals("06")) temp = "��Ӫ��ҵ";
            else if (value.equals("07")) temp = "����";
        } else if (key.equals("corpfin")) {
            if (value.equals("01")) temp = "����";
            else if (value.equals("02")) temp = "һ��";
            else if (value.equals("03")) temp = "�ϲ�";
        } else if (key.equals("busifuture")) {
            if (value.equals("01")) temp = "����";
            else if (value.equals("02")) temp = "һ��";
            else if (value.equals("03")) temp = "�ϲ�";
        } else if (key.equals("livetype")) {
            if (value.equals("01")) temp = "��ס����";
            else if (value.equals("02")) temp = "��ػ���";
        } else if (key.equals("education")) {
            if (value.equals("01")) temp = "�о�������";
            else if (value.equals("02")) temp = "��ѧ����";
            else if (value.equals("03")) temp = "��ר";
            else if (value.equals("04")) temp = "��ר������";
            else if (value.equals("05")) temp = "����";
        } else if (key.equals("marista")) {
            if (value.equals("1")) temp = "�ѻ�����Ů";
            else if (value.equals("2")) temp = "�ѻ�����Ů";
            else if (value.equals("3")) temp = "δ��";
            else if (value.equals("4")) temp = "����";
        } else if (key.equals("postlevel")) {
            if (value.equals("0")) temp = "��";
            else if (value.equals("1")) temp = "����";
            else if (value.equals("2")) temp = "�м�";
            else if (value.equals("3")) temp = "�߼�";
        } else if (key.equals("posttype")) {
            if (value.equals("01")) temp = "��λ���ܻ򴦼�����";
            else if (value.equals("02")) temp = "�������ܻ�Ƽ�����";
            else if (value.equals("03")) temp = "����";
        } else if (key.equals("health")) {
            if (value.equals("01")) temp = "����";
            else if (value.equals("02")) temp = "һ��";
            else if (value.equals("03")) temp = "�ϲ�";
        } else if (key.equals("memberflg")) {
            if (value.equals("0")) temp = "��";
            else if (value.equals("1")) temp = "��";
        } else if (key.equals("actflg")) {
            if (value.equals("0")) temp = "��";
            else if (value.equals("1")) temp = "�д��";
            else if (value.equals("2")) temp = "�����ÿ�";
        } else if (key.equals("savbal")) {
            if (value.equals("0")) temp = "��";
            else if (value.equals("1")) temp = "�ϵ�";
            else if (value.equals("2")) temp = "�ϸ�";
        } else if (key.equals("busirate")) {
            if (value.equals("1")) temp = "��";
            else if (value.equals("2")) temp = "һ��";
            else if (value.equals("3")) temp = "Ƶ��";
        } else if (key.equals("loansta")) {
            if (value.equals("1")) temp = "��δ���";
            else if (value.equals("2")) temp = "�ѽ�������Ƿ";
            else if (value.equals("3")) temp = "����Ƿ�޲���";
            else if (value.equals("4")) temp = "δ��������Ƿ";
        } else if (key.equals("judgetype")) {
            if (value.equals("01")) temp = "��������";
            else if (value.equals("02")) temp = "�߶�����";
            else if (value.equals("03")) temp = "������";
            else if (value.equals("04")) temp = "��������";
            else if (value.equals("05")) temp = "��������";
        } else {
            temp = value;
        }
        return temp;
    }

    public static ArrayList<String> getAttrList() {
        return attrList;
    }

    public static Map<String, String> getFieldNameMaps() {
        return fieldNameMaps;
    }
}



