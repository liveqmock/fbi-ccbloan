package com.ccb.specialbusiness;
import com.ccb.dao.LNSPCLBUSCUST;
import com.ccb.dao.LNSPCLBUSFLOW;
import com.ccb.dao.LNSPCLBUSINFO;
import com.ccb.mortgage.MortUtil;
import com.ccb.util.CcbLoanConst;
import com.sun.deploy.net.HttpRequest;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import pub.platform.advance.utils.PropertyManager;
import pub.platform.db.RecordSet;
import pub.platform.form.config.SystemAttributeNames;
import pub.platform.form.control.Action;
import pub.platform.security.OperatorManager;
import pub.platform.system.manage.dao.PtDeptBean;
import pub.platform.utils.BusinessDate;
import pub.platform.utils.StringUtils;

import javax.mail.Session;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.UUID;

/**
 * Created by huzy on 2014/9/9.
 */
public class SpclBusCustAction extends Action {
    // 日志对象
    private static final Log logger = LogFactory.getLog(SpclBusCustAction.class);
    public int add() {
        LNSPCLBUSCUST cust = new LNSPCLBUSCUST();
        for (int i = 0; i < this.req.getRecorderCount(); i++) {
            try {
                // 初始化数据bean
                cust.initAll(i, req);
                cust.setCreatedate(BusinessDate.getTodaytime());
                cust.setOperdate(BusinessDate.getToday());
                cust.setOperid( this.getOperator().getOperid()); // 建立柜员id
                cust.setBankid(this.getDept().getDeptid());  // 建立机构号
                int custSeq = 0;
                String deptid=this.getDept().getDeptid();
                RecordSet rs = dc.executeQuery("select max(lp.seq) as custmax from ln_spclbus_cust lp where lp.bankid = '" + deptid + "' and (to_char(sysdate,'yyyy-mm-dd') = to_char(lp.createdate,'yyyy-mm-dd'))");

                while (rs.next()) {
                    custSeq =rs.getInt("custmax")+1;
                }
                String custno = deptid +9 + StringUtils.toDateFormat(new Date(), "yyyyMMdd")+ StringUtils.addPrefix(custSeq + "", "0", 2);
                cust.setSeq(custSeq);
                cust.setCustno(custno);


                if (cust.insert() < 0) {
                    this.res.setType(0);
                    this.res.setResult(false);
                    this.res.setMessage("LN_SPCLBUS_CUST添加失败，业务流水号重复或字段填写有误。");
                    return -1;
                }
            } catch (Exception ex1) {
                logger.error(ex1.getMessage());
                this.res.setType(0);
                this.res.setResult(false);
                this.res.setMessage("处理异常.");
                return -1;
            }
        }
        this.res.setType(0);
        this.res.setResult(true);
        this.res.setMessage("处理成功.");
        return 0;
    }

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

    /**
     * <p/>
     * 删除接口
     * <p/>
     * 删除一条记录
     */
    public int delete() {
        LNSPCLBUSCUST cust = new LNSPCLBUSCUST();
        try {
            for (int i = 0; i < this.req.getRecorderCount(); i++) {
                cust.initAll(i, req);

                //删除基础信息信息和流程信息
                if (cust.deleteByWhere(" where custno='" + req.getFieldValue(i, "custno") + "' ") < 0) {
                    this.res.setType(0);
                    this.res.setResult(false);
                    this.res.setMessage(PropertyManager.getProperty("300"));
                    return -1;
                }

            }
        } catch (Exception e) {
            logger.error(e.getMessage());
            e.printStackTrace();
            this.res.setType(0);
            this.res.setResult(false);
            this.res.setMessage(PropertyManager.getProperty("300"));
            return -1;
        }

        this.res.setType(0);
        return 0;
    }

}

