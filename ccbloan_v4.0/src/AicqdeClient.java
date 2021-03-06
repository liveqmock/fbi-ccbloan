import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.io.UnsupportedEncodingException;
import java.net.Socket;

/**
 * 工商E线通测试 client
 * 注：未作通讯粘包处理
 * User: zhanrui
 * Date: 13-11-27
 */
public class AicqdeClient {
    private String ip;
    private int port;

    public AicqdeClient(String ip, int port) {
        this.ip = ip;
        this.port = port;
    }

    public byte[] call(byte[] sendbuf) {
        Socket socket = null;
        OutputStream os = null;
        byte[] recvbuf = null;
        try {
            socket = new Socket(ip, port);
            socket.setSoTimeout(10000);

            os = socket.getOutputStream();
            os.write(sendbuf);
            os.flush();

            InputStream is = socket.getInputStream();
            recvbuf = new byte[4];
            int readNum = is.read(recvbuf);
            if (readNum < 4) {
                throw new RuntimeException("读取报文长度出错！");
            }
            int msgLen = Integer.parseInt(new String(recvbuf).trim());
            recvbuf = new byte[msgLen];

            readNum = is.read(recvbuf);
            if (readNum != msgLen -4) {
                throw new RuntimeException("读取报文长度出错！");
            }
        }catch (IOException e) {
            e.printStackTrace();
        } finally {
            try {
                assert os != null;
                os.close();
                socket.close();
            } catch (IOException e) {
                //
            }
        }
        return recvbuf;
    }


    public static void main(String[] argv) throws UnsupportedEncodingException {
        AicqdeClient mock = new AicqdeClient("192.168.4.87", 54110);

        //1070：入资登记预交易
/*
        String msg = "" +
                "1070" + //交易码
                "02" + //银行代码	2	CHAR	中行代码统一使用01
                "1111111" + //柜员号	7	CHAR	右补空格
                "22222" +  //机构号	5	CHAR	右补空格
                "3333" +   //地区码	4	CHAR	右补空格
                "44" +  //工商局编号	2	CHAR
                "12345678901234567890123456789012"; //预登记号	32	CHAR	右补空格
*/
        String msg = "" +
                "1010" + //交易码
                "02" + //银行代码	2	CHAR	中行代码统一使用01
                "1111111" + //柜员号	7	CHAR	右补空格
                "22222" +  //机构号	5	CHAR	右补空格
                "3810" +   //地区码	4	CHAR	右补空格
                "13" +  //工商局编号	2	CHAR
                "0020131218000                   "+
                "aic                             "+
                "1234567890123456789012"+
                "1.00                 "+
                "1             "+
                "name                                                                    " +
                "ccb                                               " +
                "1   " +
                "a                                                 " +
                "1                               " +
                "1.00            " +
                "20131218" +
                "ccb                                               " +
                "1                               " +
                ""; //预登记号	32	CHAR	右补空格

        String strLen = "" +  (msg.getBytes("GBK").length + 4);
        String lpad = "";
        for (int i =0; i < 4 - strLen.length(); i++) {
            lpad += "0";
        }
        strLen = lpad + strLen;
        System.out.println(strLen + msg);
        byte[] recvbuf = mock.call((strLen + msg).getBytes("GBK"));
        System.out.printf("服务器返回：%s\n", new String(recvbuf, "GBK"));
    }

}
