package com.ccb.specialbusiness;

import com.sun.deploy.net.HttpRequest;
import org.apache.commons.lang.StringUtils;
import pub.platform.form.config.SystemAttributeNames;
import pub.platform.form.control.Action;
import pub.platform.security.OperatorManager;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

/**
 * 根据业务流水号查找档案卷宗资料数据
 */
public class SpclBusCustSelectOneAction extends Action {
    public int doBusiness() {

        String SQLStr = "select  custno as flowsn,custname as cust_name,loantype as ln_typ,bustype,OPERATINGCENTER as cust_bankid,CUSTOMERMANAGER as realcustmgr_id ,AGENCIES as bankid,MARKETINGMANAGER as custmgr_id " +
               " from ln_spclbus_cust where (custno='" +
               this.req.getFieldValue("flowsn") + "')";

        this.rs = this.dc.executeQuery(SQLStr);
        this.res.setFieldName("FLOWSN;CUST_NAME;LN_TYP;BUSTYPE;CUST_BANKID;REALCUSTMGR_ID;BANKID;CUSTMGR_ID;");
        this.res.setFieldType("text;text;text;text;text;text;text;text;");
        this.res.setEnumType("0;0;0;0;0;0;0;0;");
        //this.res.setType(1);
        if (this.rs.getRecordCount() == 0) {
            this.res.setType(0);
            this.res.setResult(false);
            this.res.setMessage("无此流水号明细记录。");
            return -1;
        } else {
            this.res.setType(1);
            this.res.setResult(true);
            this.res.setRecordset(this.rs);
        }
        return 0;
    }
}
