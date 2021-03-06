var SQLStr;
var gWhereStr = "";

/**
 * 初始化form函数,
 * <p>
 * ■初始化焦点定位在查询条件第一个控件上;
 * <p>
 * ■每次查询完毕后焦点自动定位到第一个控件，且全选；
 * 
 */
function body_resize() {
    divfd_loanTab.style.height = document.body.offsetHeight - 230;
    // divfd_loanTab.style.height = "350px";
    loanTab.fdwidth = "4800px";
    initDBGrid("loanTab");
    // 初始化页面焦点
    body_init(queryForm, "cbRetrieve");
    // document.getElementById("MORTDATE").focus();
}

/**
 * <p>
 * ■检索函数，检索完成后焦点自动定位到检索区域第一个条件中， 并且全选中;
 * <p>
 * ■系统根据姓名处输入的汉字或者拼音查询 汉字与拼音查询是“or”的关系;
 * <p>
 * ■汉字与拼音都支持前端一致、后端模糊查询；
 * <p>
 * ■按下回车键自动支持查询；
 * </p>
 * 
 * @param ：form名字或者ID
 */

function cbRetrieve_Click(formname) {

    // 增加系统锁检查
    if (getSysLockStatus() == "1") {
        alert(MSG_SYSLOCK);
        return;
    }

    if (checkForm(queryForm) == "false")
        return;
    var whereStr = "";
    // 日期
    if (trimStr(document.getElementById("REPORTDATE").value) != "") {
        //whereStr += " and b.REPORTDATE <='" + trimStr(document.getElementById("REPORTDATE").value) + "'";
        whereStr += " and (b.chgpaperrtndate is  null or b.chgpaperrtndate > '" +  trimStr(document.getElementById("REPORTDATE").value)  + "' )"
    }

    // 天数
    if (trimStr(document.getElementById("DAYNUM").value) != "") {
        whereStr += " and floor(to_date('" + trimStr(document.getElementById("REPORTDATE").value) + "','yyyy-mm-dd') - to_date(b.chgpaperdate,'yyyy-mm-dd')) >= " + trimStr(document.getElementById("DAYNUM").value);
    }

    // 经办行id
    //if (trimStr(document.getElementById("bankid").value) != "") {
    //    whereStr += " and a.bankid in(select deptid from ptdept start with deptid='"+document.getElementById("bankid").value+"' connect by prior deptid=parentdeptid)";
    //}

    //whereStr += " order by b.mortecentercd,a.bankid,a.cust_name   ";
    whereStr +=  " and b.chgpaperreasoncd = '01' and a.bankid in(select deptid from ptdept start with deptid='" + deptid + "' connect by prior deptid=parentdeptid) order by b.mortecentercd,a.bankid,a.cust_name ";

    //alert(whereStr);
    document.all["loanTab"].whereStr = whereStr;
    document.all["loanTab"].RecordCount = "0";
    document.all["loanTab"].AbsolutePage = "1";
    // Table_Refresh in dbgrid.js pack
    Table_Refresh("loanTab", false, body_resize);
}

/**
 * report
 * 
 * @param 
 * @param doType:select
 *            操作类型
 */
function loanTab_expExcel_click() {

    // 增加系统锁检查
    if (getSysLockStatus() == "1") {
        alert(MSG_SYSLOCK);
        return;
    }
    document.getElementById("queryForm").target = "_blank";
    document.getElementById("queryForm").action = "basicReport.jsp";
    document.getElementById("queryForm").submit();
}