var dw_form;

/**
 * ��ʼ��
 *
 * @return
 */
function payBillInit() {
  body_init(queryForm, "expExcel");
  // ��ʼ�����ݴ��ڣ�У���ʱ����
  dw_form = new DataWindow(document.getElementById("queryForm"), "form");
}

function loanTab_expExcel_click(flag) {

  // ����ϵͳ�����
  if (getSysLockStatus() == "1") {
    alert(MSG_SYSLOCK);
    return;
  }
  if (dw_form.validate() != null)
    return;

  document.getElementById("queryForm").target = "_blank";
  if (flag == 1)
    document.getElementById("queryForm").action = "payBillReport18.jsp";
  else if (flag == 2)
    document.getElementById("queryForm").action = "payBillReport21.jsp";
  else if (flag == 3)
    document.getElementById("queryForm").action = "payBillReport22.jsp";
  document.getElementById("queryForm").submit();
}