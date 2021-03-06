var dw_column;
var operation;
// tab enter键 zhan
document.onkeydown = function(evt) {
    var isie = (document.all) ? true : false;
    var key;
    var srcobj;
    if (isie) {
        key = event.keyCode;
        srcobj = event.srcElement;
    } else {
        key = evt.which;
        srcobj = evt.target;
    }
    if (key == 13 && srcobj.type != 'button' && srcobj.type != 'submit' && srcobj.type != 'reset'
            && srcobj.type != 'textarea' && srcobj.type != '') {
        if (isie) {
            event.keyCode = 9;
        } else {
            var el = getNextElement(evt.target);
            if (el.type != 'hidden')
                el.focus();
            else
                while (el.type == 'hidden')
                    el = getNextElement(el);
            el.focus();
            return false;
        }
    }
}
function getNextElement(field) {
    var form = field.form;
    for (var e = 0; e < form.elements.length; e++) {
        if (field == form.elements[e])
            break;
    }
    return form.elements[++e % form.elements.length];
}
/**
 * 把输入框的onkedown调用函数队列里加入回车键等于Tab键
 */
function addKeyDownEvent(iupt) {
    var oldpress = iupt.onkeydown;
    if (typeof iupt.onkeydown != "function") {
        iupt.onkeydown = jumpNext;
    } else {
        iupt.onkeydown = function() {
            oldpress();
            jumpNext();
        };
    }
}
function jumpNext() {
    if (event.keyCode == 13) {
        event.keyCode = 9;
    }

}
/**
 * 初始化form表单内容，根据主键取出详细信息，包括查询、删除、修改
 */
function formInit() {
	// 初始化事件
	var arg = window.dialogArguments;

	if (arg) {
		operation = arg.doType;
		if (operation != "add") {
			load_form();
            document.getElementById("CUST_BANKID").value = document.getElementById("custbankid").value;
            operReSelectCustMgr();
            // 客户经理初始化
            document.getElementById("CUSTMGR_ID").value = document.getElementById("custMgrID").value;
		}

		// 只读情况下，页面所有空间禁止修改
		if (operation == "select" || operation == "delete") {
			readFun(document.getElementById("editForm"));
		}

	}
	// 初始化数据窗口，校验的时候用
	dw_column = new DataWindow(document.getElementById("editForm"), "form");
}

/**
 * 根据经办行联动
 */
function reSelect() {
    operReSelectCustMgr();
}
/**
 * 根据经办行联动下拉项目:客户经理ID
 *
 * @return
 */
function operReSelectCustMgr() {
    refresh_select("CUSTMGR_ID", "select OPERID as value ,OPERNAME as text  from ptoper where" + " deptid='"
            + document.getElementById("CUST_BANKID").value + "'");
}


function saveClick() {
    var doType = document.all.doType.value;
    if (dw_column.validate() != null)
		return;
	var retxml = "";
    document.getElementById("busiNode").value = BUSINODE_180;
    if (operation == "add") {
        retxml = createExecuteform(editForm, "insert", "prom01", "add");
    } else if (operation == "edit") {
        retxml = createExecuteform(editForm,"update","prom01","edit");
    }
    if (analyzeReturnXML(retxml) + "" == "true") {
        window.returnValue = "1";
        window.close();
    }
}