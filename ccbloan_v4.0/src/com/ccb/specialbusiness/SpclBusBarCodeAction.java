package com.ccb.specialbusiness;

import com.ccb.dao.LNSPCLBUSCUST;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import pub.platform.advance.utils.PropertyManager;
import pub.platform.db.RecordSet;
import pub.platform.form.control.Action;
import pub.platform.utils.BusinessDate;
import pub.platform.utils.StringUtils;

import java.util.Date;

/**
 * Created by huzy on 2014/9/15.
 */
public class SpclBusBarCodeAction extends Action {
    // 日志对象
    private static final Log logger = LogFactory.getLog(SpclBusBarCodeAction.class);

    public int edit() {
        LNSPCLBUSCUST cust = new LNSPCLBUSCUST();
        for (int i = 0; i < this.req.getRecorderCount(); i++) {
            try {
                // 初始化数据bean
                cust.initAll(i, req);
                cust.setModifydate(BusinessDate.getToday());
                cust.setModifyoperid(this.getOperator().getOperid());

                if (cust.updateByWhere(" where custno='" + req.getFieldValue(i, "custno") + "'") < 0) {
                    this.res.setType(0);
                    this.res.setResult(false);
                    this.res.setMessage("保存LN_SPCLBUS_CUST表出错。");
                    return -1;
                }

            } catch (Exception ex1) {
                logger.error(ex1.getMessage());
                ex1.printStackTrace();
                this.res.setType(0);
                this.res.setResult(false);
                this.res.setMessage(PropertyManager.getProperty("300"));
                return -1;
            }
        }
        this.res.setType(0);
        this.res.setResult(true);
        this.res.setMessage(PropertyManager.getProperty("200"));
        return 0;
    }

}
