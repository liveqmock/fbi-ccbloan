var dw_column;

/**
 * 初始化form表单内容，根据主键取出详细信息，包括查询、删除、修改
 */
function formInit() {

    // 初始化数据窗口，校验的时候用
    dw_column = new DataWindow(document.getElementById("editForm"), "form");
    // 设置默认焦点；柜号
    document.getElementById("appt_date").focus();
    document.getElementById("clientNames").value = window.dialogArguments.clientNames;
    document.getElementById("mortCenterCD").value = window.dialogArguments.mortCenterCD;
    document.getElementById("currAppNum").value = window.dialogArguments.currAppNum;
}

function saveClick() {
    if (onSearchAppNumInfo()!=0){
        alert("当前日期预约数量已满！");
        window.close();
        return;
    }

    var doType = document.all.doType.value;
    if (dw_column.validate() != null)
        return;
    var retxml = "";
    var arg = new Object();
    if (operation = "edit") {
        arg.appt_date = document.getElementById("appt_date").value;
        var  appt_date_init = document.getElementById("appt_date_init").value;
        var  appt_date_pre = document.getElementById("appt_date_pre").value;
        if (arg.appt_date < appt_date_init) {
            alert("请提前 " + appt_date_pre +  " 天进行抵押处理预约...");
            return;
        }
        var appt_times = document.getElementsByName("appt_time");
        for (var i = 0; i < appt_times.length; i++) {
            if (appt_times[i].checked) {
                arg.appt_time = appt_times[i].value;
            }
        }
        arg.appt_remark = document.getElementById("appt_remark").value;
        window.returnValue = arg;
        window.close();
    }
}

function onSearchAppNumInfo() {
    var appDate = trimStr(document.getElementById("appt_date").value);
    if (appDate == "") {
        alert('请输入预约日期.');
        return -1;
    }

    //检查是否超过预约数量 TODO
    var retxml = createselect(editForm, "com.ccb.mortgage.SelectAppNumAction");
    if (retxml == "false") {
        alert("当天预约数量已经超过最大预约数。");
        return -1;
    }
    var xmlDoc = createDomDocument();
    xmlDoc.loadXML(retxml);
    var rootNode = xmlDoc.documentElement.firstChild;
    if (rootNode != null && rootNode.getAttribute("result") == "true" && rootNode.firstChild.xml != "null") {
        return 0;
    } else {
        return(rootNode.firstChild.xml);
    }
}