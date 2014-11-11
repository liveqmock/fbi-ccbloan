package pub.platform.advance.utils;

import pub.platform.db.RecordSet;
import pub.platform.utils.*;

/**
 * Javaʵ����ͳһ������
 * 
 * �����淶��������ȥ���»��ߣ�ȫ����д��+Bean
 * 
 * @author wu $Date: 2006/04/18 06:51:20 $
 * @version 1.0
 * 
 *          ��Ȩ���ൺ��˾
 */

public class DAOGenerator {
  // Ĭ�ϵİ���
  private static final String schme = "CCB";
  public static final String PACKAGE = "com.ccb.dao";
  static JavaBeanGenerator jbg = new JavaBeanGenerator();

  /**
   * ����ָ���������������ļ�
   * 
   * @param tableName
   *          String
   */
  public static void generateTable(String tableName) {
    if (hasTable(tableName))
      jbg.generate(PACKAGE, getBeanName(tableName), tableName);
    else
      System.out.println("����ı�����" + tableName + "�������ݿ��в����ڣ�����ϸ��飡����");
  }

  /**
   * ����CIMS�������еı�������ļ�
   */
  public static void generateAllTables() {
    RecordSet rs = DbUtil.getRecord("select * from sys.all_tables where owner='" + schme + "'");

    while (rs.next()) {
      generateTable(rs.getString("table_name"));
    }
  }

  /**
   * �ж��Ƿ��б���
   * 
   * @param tableName
   *          String
   * @return boolean
   */
  public static boolean hasTable(String tableName) {
    RecordSet rs = DbUtil.getRecord("select * from sys.all_tables where owner='" + schme + "' and table_name='"
        + tableName.toUpperCase() + "'");

    while (rs.next()) {
      return true;
    }

    return false;
  }

  /**
   * ���ݱ������������ļ��� ȥ���»��ߣ�ȫ����д
   * 
   * @param tableName
   *          String
   * @return String
   */
  private static String getBeanName(String tableName) {
    tableName = tableName.replaceAll("_", "");
    tableName = tableName.toUpperCase();

    return tableName;

  }

  public static void main(String[] argv) {
    // ���ɵ�������ļ�
//    generateAllTables();
//     generateTable("LN_ARCHIVE_INFO");
//     generateTable("LN_ARCHIVE_FLOW");
//     generateTable("LN_MORTINFO");
//     generateTable("LN_MORTLIMIT");
//     generateTable("LN_SPCLBUS_FLOW");
//     generateTable("LN_SPCLBUS_INFO");
     generateTable("LN_SPCLBUS_CUST");
//     generateTable("LN_ODSB_REPAY_ACCT_PMIS");
  }
}
