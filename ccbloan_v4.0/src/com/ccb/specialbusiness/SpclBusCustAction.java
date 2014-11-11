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
    // ��־����
    private static final Log logger = LogFactory.getLog(SpclBusCustAction.class);
    public int add() {
        LNSPCLBUSCUST cust = new LNSPCLBUSCUST();
        for (int i = 0; i < this.req.getRecorderCount(); i++) {
            try {
                // ��ʼ������bean
                cust.initAll(i, req);
                cust.setCreatedate(BusinessDate.getTodaytime());
                cust.setOperdate(BusinessDate.getToday());
                cust.setOperid( this.getOperator().getOperid()); // ������Աid
                cust.setBankid(this.getDept().getDeptid());  // ����������
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
                    this.res.setMessage("LN_SPCLBUS_CUST���ʧ�ܣ�ҵ����ˮ���ظ����ֶ���д����");
                    return -1;
                }
            } catch (Exception ex1) {
                logger.error(ex1.getMessage());
                this.res.setType(0);
                this.res.setResult(false);
                this.res.setMessage("�����쳣.");
                return -1;
            }
        }
        this.res.setType(0);
        this.res.setResult(true);
        this.res.setMessage("����ɹ�.");
        return 0;
    }

    public int edit() {
        LNSPCLBUSCUST cust = new LNSPCLBUSCUST();
        for (int i = 0; i < this.req.getRecorderCount(); i++) {
            try {
                // ��ʼ������bean
                cust.initAll(i, req);
                cust.setModifydate(BusinessDate.getToday());
                cust.setModifyoperid(this.getOperator().getOperid());

                if (cust.updateByWhere(" where custno='" + req.getFieldValue(i, "custno") + "'") < 0) {
                    this.res.setType(0);
                    this.res.setResult(false);
                    this.res.setMessage("����LN_SPCLBUS_CUST�����");
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
     * ɾ���ӿ�
     * <p/>
     * ɾ��һ����¼
     */
    public int delete() {
        LNSPCLBUSCUST cust = new LNSPCLBUSCUST();
        try {
            for (int i = 0; i < this.req.getRecorderCount(); i++) {
                cust.initAll(i, req);

                //ɾ��������Ϣ��Ϣ��������Ϣ
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

