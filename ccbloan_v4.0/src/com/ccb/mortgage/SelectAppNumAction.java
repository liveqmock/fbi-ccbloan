package com.ccb.mortgage;

import pub.platform.db.RecordSet;
import pub.platform.form.control.Action;

/**
 * ���ݵ�Ѻ���Ĳ�ѯ�����Ƿ񳬹���Ѻ������������
 */
public class SelectAppNumAction extends Action {
    public int doBusiness() {
        // ��������
        String mortCenterCD ="";
        // ��Ѻ��������
        int limiteNum = 0;
        // ��Ѻ����������������
        String limit_ln_typ = "009";
        // Ŀǰ��Ҫ���������
        String strAppNum = "";
        int currAppNum = 0;
        // ��������
        mortCenterCD = this.req.getFieldValue("mortCenterCD");

        strAppNum = this.req.getFieldValue("currAppNum");
        currAppNum = Integer.parseInt(strAppNum);

        String SQLStr = "select LIMITDATE from LN_MORTLIMIT where LN_TYP='" + limit_ln_typ
                + "' and MORTECENTERCD='" + mortCenterCD + "'";

        RecordSet rs = dc.executeQuery(SQLStr);

        while (rs.next()) {
            limiteNum = rs.getInt("LIMITDATE");
        }
        // rs�ر�
        if (rs != null) {
            rs.close();
        }
        //����
        String appDate = this.req.getFieldValue("appt_date");
        //�Ƿ񳬹�������־
        boolean isOver = false;
        //��ǰ��������
        int appCount = 0;

        SQLStr = "select count(*) appCount from ln_mortinfo t where t.appt_hdl_date = '"+appDate+"' and t.mortecentercd = '"+
                 mortCenterCD +"' and t.releasecondcd not in('04','05','06')";

        this.rs = this.dc.executeQuery(SQLStr);
        while (this.rs.next()){
            appCount = this.rs.getInt("appCount");
        }

        if (limiteNum<appCount + currAppNum ) {
            this.res.setType(0);
            this.res.setResult(false);
//            this.res.setMessage("�����������������Ϊ��"+limiteNum+"!��ǰ�ܹ�������������Ϊ��"+(limiteNum-appCount));
//            this.res.setMessage(String.valueOf(limiteNum-appCount));
            this.res.setMessage("1");
            return -1;
        } else {
            this.rs.next();
            this.res.setType(0);
            this.res.setResult(true);
            this.res.setMessage("0");
        }
        return 0;
    }
}
