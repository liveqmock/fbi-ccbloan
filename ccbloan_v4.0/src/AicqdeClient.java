import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.io.UnsupportedEncodingException;
import java.net.Socket;

/**
 * ����E��ͨ���� client
 * ע��δ��ͨѶճ������
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
                throw new RuntimeException("��ȡ���ĳ��ȳ���");
            }
            int msgLen = Integer.parseInt(new String(recvbuf).trim());
            recvbuf = new byte[msgLen];

            readNum = is.read(recvbuf);
            if (readNum != msgLen -4) {
                throw new RuntimeException("��ȡ���ĳ��ȳ���");
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

        //1070�����ʵǼ�Ԥ����
/*
        String msg = "" +
                "1070" + //������
                "02" + //���д���	2	CHAR	���д���ͳһʹ��01
                "1111111" + //��Ա��	7	CHAR	�Ҳ��ո�
                "22222" +  //������	5	CHAR	�Ҳ��ո�
                "3333" +   //������	4	CHAR	�Ҳ��ո�
                "44" +  //���ֱ̾��	2	CHAR
                "12345678901234567890123456789012"; //Ԥ�ǼǺ�	32	CHAR	�Ҳ��ո�
*/
        String msg = "" +
                "1010" + //������
                "02" + //���д���	2	CHAR	���д���ͳһʹ��01
                "1111111" + //��Ա��	7	CHAR	�Ҳ��ո�
                "22222" +  //������	5	CHAR	�Ҳ��ո�
                "3810" +   //������	4	CHAR	�Ҳ��ո�
                "13" +  //���ֱ̾��	2	CHAR
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
                ""; //Ԥ�ǼǺ�	32	CHAR	�Ҳ��ո�

        String strLen = "" +  (msg.getBytes("GBK").length + 4);
        String lpad = "";
        for (int i =0; i < 4 - strLen.length(); i++) {
            lpad += "0";
        }
        strLen = lpad + strLen;
        System.out.println(strLen + msg);
        byte[] recvbuf = mock.call((strLen + msg).getBytes("GBK"));
        System.out.printf("���������أ�%s\n", new String(recvbuf, "GBK"));
    }

}
