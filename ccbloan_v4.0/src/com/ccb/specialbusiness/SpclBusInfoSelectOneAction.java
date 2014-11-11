package com.ccb.specialbusiness;

import pub.platform.form.control.Action;

/**
 * ����ҵ����ˮ�Ų��ҵ���������������
 */
public class SpclBusInfoSelectOneAction extends Action {
    public int doBusiness() {
        String SQLStr = "select  flowsn,cust_name,ln_typ,bustype,bankid,cust_bankid,custmgr_id," +
                "realcustmgr_id from ln_spclbus_info where (flowsn='" +
                this.req.getFieldValue("flowsn") + "')";

        this.rs = this.dc.executeQuery(SQLStr);

        this.res.setFieldName("FLOWSN;CUST_NAME;LN_TYP;BUSTYPE;BANKID;CUST_BANKID;CUSTMGR_ID;REALCUSTMGR_ID");
        this.res.setFieldType("text;text;text;text;text;text;text;text");
        this.res.setEnumType("0;0;0;0;0;0;0;0");
        //this.res.setType(1);

        if (this.rs.getRecordCount() == 0) {
            this.res.setType(0);
            this.res.setResult(false);
            this.res.setMessage("�޴���ˮ����ϸ��¼��");
            return -1;
        } else {
            this.res.setType(1);
            this.res.setResult(true);
            this.res.setRecordset(this.rs);
        }
        return 0;
    }
}
