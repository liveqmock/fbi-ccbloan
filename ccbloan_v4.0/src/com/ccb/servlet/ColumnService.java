package com.ccb.servlet;

/**
 * Created with IntelliJ IDEA.
 * User: vincent
 * Date: 13-4-17
 * Time: 下午4:40
 * To change this template use File | Settings | File Templates.
 */
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

public class ColumnService {

    public static List<Column> cols_zn = new ArrayList<Column>(Arrays.asList(new Column[]{
            new Column("流水号",100,"flowsn","left",null),
            new Column("借款人",120,"cust_name","left",null),
            new Column("贷款金额",120,"rt_orig_loan_amt","left",null),
            new Column("贷款期限",120,"rt_term_incr","left",null)
    }));

    public static List<Column> cols_en = new ArrayList<Column>(Arrays.asList(new Column[]{
            new Column("flowsn",100,"flowsn","left",null),
            new Column("cust_name",120,"cust_name","left",null),
            new Column("rt_orig_loan_amt",120,"rt_orig_loan_amt","left",null),
            new Column("rt_term_incr",120,"rt_term_incr","left",null)
    }));
}
