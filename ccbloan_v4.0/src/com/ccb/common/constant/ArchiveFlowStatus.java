package com.ccb.common.constant;

import java.util.Hashtable;

/**
 * ��������
 * User: zhanrui
 * Date: 11-7-23
 * Time: ����3:30
 */
public enum ArchiveFlowStatus implements EnumApp {
    ACCEPT("10", "�Ѵ��"),
    REJECT("20", "���ط�"),
    HANGUP("30", "���н������");

    private String code = null;
    private String title = null;
    private static Hashtable<String, ArchiveFlowStatus> aliasEnums;

    ArchiveFlowStatus(String code, String title) {
        this.init(code, title);
    }

    @SuppressWarnings("unchecked")
    private void init(String code, String title) {
        this.code = code;
        this.title = title;
        synchronized (this.getClass()) {
            if (aliasEnums == null) {
                aliasEnums = new Hashtable();
            }
        }
        aliasEnums.put(code, this);
        aliasEnums.put(title, this);
    }

    public static ArchiveFlowStatus valueOfAlias(String alias) {
        return aliasEnums.get(alias);
    }

    public String getCode() {
        return this.code;
    }

    public String getTitle() {
        return this.title;
    }
}
