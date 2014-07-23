package com.ccb.mortgage;

import pub.platform.db.RecordSet;
import pub.platform.form.control.Action;

/**
 * 根据抵押中心查询当天是否超过抵押申请限制数量
 */
public class SelectAppNumAction extends Action {
    public int doBusiness() {
        // 交易中心
        String mortCenterCD ="";
        // 抵押限制数量
        int limiteNum = 0;
        // 抵押限制数量贷款类型
        String limit_ln_typ = "009";
        // 目前既要申请的数量
        String strAppNum = "";
        int currAppNum = 0;
        // 交易中心
        mortCenterCD = this.req.getFieldValue("mortCenterCD");

        strAppNum = this.req.getFieldValue("currAppNum");
        currAppNum = Integer.parseInt(strAppNum);

        String SQLStr = "select LIMITDATE from LN_MORTLIMIT where LN_TYP='" + limit_ln_typ
                + "' and MORTECENTERCD='" + mortCenterCD + "'";

        RecordSet rs = dc.executeQuery(SQLStr);

        while (rs.next()) {
            limiteNum = rs.getInt("LIMITDATE");
        }
        // rs关闭
        if (rs != null) {
            rs.close();
        }
        //日期
        String appDate = this.req.getFieldValue("appt_date");
        //是否超过数量标志
        boolean isOver = false;
        //当前申请数量
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
//            this.res.setMessage("该中心申请数量最大为："+limiteNum+"!当前能够申请的最大数量为："+(limiteNum-appCount));
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
