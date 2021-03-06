package pub.platform.advance.utils;

import pub.platform.db.RecordSet;
import pub.platform.utils.*;

/**
 * Java实体类统一生成器
 * 
 * 命名规范：表名（去掉下划线，全部大写）+Bean
 * 
 * @author wu $Date: 2006/04/18 06:51:20 $
 * @version 1.0
 * 
 *          版权：青岛公司
 */

public class DAOGenerator {
  // 默认的包名
  private static final String schme = "CCB";
  public static final String PACKAGE = "com.ccb.dao";
  static JavaBeanGenerator jbg = new JavaBeanGenerator();

  /**
   * 根据指定表名生成数据文件
   * 
   * @param tableName
   *          String
   */
  public static void generateTable(String tableName) {
    if (hasTable(tableName))
      jbg.generate(PACKAGE, getBeanName(tableName), tableName);
    else
      System.out.println("输入的表名【" + tableName + "】在数据库中不存在，请仔细检查！！！");
  }

  /**
   * 生成CIMS下面所有的表的数据文件
   */
  public static void generateAllTables() {
    RecordSet rs = DbUtil.getRecord("select * from sys.all_tables where owner='" + schme + "'");

    while (rs.next()) {
      generateTable(rs.getString("table_name"));
    }
  }

  /**
   * 判断是否有表名
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
   * 根据表名生成数据文件名 去掉下划线，全部大写
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
    // 生成单个表的文件
//    generateAllTables();
//     generateTable("LN_ARCHIVE_INFO");
     generateTable("LN_ARCHIVE_FLOW");
//     generateTable("LN_MORTINFO");
//     generateTable("LN_MORTLIMIT");
//     generateTable("LN_SPCLBUS_FLOW");
//     generateTable("LN_SPCLBUS_INFO");
//     generateTable("LN_SPCLBUS_CUST");
//     generateTable("LN_ODSB_REPAY_ACCT_PMIS");
  }
}
