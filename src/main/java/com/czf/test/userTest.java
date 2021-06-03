package com.czf.test;

import com.czf.controller.Alipay.AlipayController;
import com.czf.dao.UserDao;
import com.czf.model.Admin;
import com.czf.model.User;
import com.czf.service.AdminService;
import com.czf.service.UserService;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.apache.ibatis.session.SqlSession;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import java.io.File;
import java.sql.Timestamp;
import java.text.DecimalFormat;
import java.util.Date;
import java.util.List;
import java.util.UUID;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(locations = {"classpath:applicationContext.xml"})
public class userTest {

    public static Log log = LogFactory.getLog(userTest.class);

    @Autowired
    private UserService userService;

    @Autowired
    private SqlSession sqlSession;

    @Autowired
    private AdminService adminService;

    /**
     * 最近插入上百条用户数据
     */
    @Test
    public void Random() {
        UserDao mapper = sqlSession.getMapper(UserDao.class);
        for (int i = 0; i < 100; i++) {
            String userName = UUID.randomUUID().toString().substring(0, 5) + "" + i;
            String passWord = UUID.randomUUID().toString().substring(0, 5) + "" + i;
            String trueName = "李" + i;
            String phone = "";
            if (i < 10) {
                phone = "1378944800" + i;
            } else {
                phone = "137894480" + i;
            }
            String address = "广西" + i;
            Date date = new Date();
            Timestamp timestamp = new Timestamp(date.getTime());
            String sex = "女";
            if (i % 2 == 0) {
                sex = "男";
            }
            User user = new User(userName, phone, passWord, trueName, sex, address, 0, "普通用户", timestamp, timestamp);
            mapper.insertUser(user);
        }
    }

    /**
     * 添加用户
     */
    @Test
    public void insert() {
        System.out.println("Test：添加用户");
        String userName = "黄磊6";
        String phone = "15778446350";
        String passWord = "xulei123";
        String trueName = "黄磊";
        String sex = "男";
        Integer status = 0;
        String role = "普通用户";


        Date time = new Date();
        Timestamp addTime = new Timestamp(time.getTime());
        Timestamp updateTime = new Timestamp(time.getTime());
        User user = new User(userName, phone, passWord, trueName, sex, "光州", status, role, addTime, updateTime);
        System.out.println(user);
        int sum = userService.findByUserName(userName);
        if (sum == 0) {
            userService.insertUser(user);
            System.out.println("插入成功！");
        } else {
            System.out.println("插入失败！已有该用户信息");
        }

    }

    /**
     * 测试查找所有用户
     */
    @Test
    public void findAllUser() {
        DecimalFormat df = new java.text.DecimalFormat("#.00");
        double d = 3.14159;
        df.format(d);
        String total_amount = df.format(d);
       // Double to = (Double)df.format(d);
        System.out.println(df.format(d));
        System.out.println(df.format(2.0));
        System.out.println(df.format(2));
       /* System.out.println("Test：查找所有用户");
        List<User> users = userService.findAllUser();
        for (User user : users) {
            user.setAddTime(new Timestamp(user.getAddTime().getTime()));
            System.out.println(user);
        }*/
    }

    /**
     * 模糊搜索
     */
    @Test
    public void findAllParamsUser() {
        User user = new User();
        user.setUserName("s");
        user.setAddress("");
        //System.out.println(user);

        /*List<User> users = userService.findUsersByParams(user);
        for (User user1 : users) {
           System.out.println(user1);
        }*/

        PageHelper.startPage(1, 5);
        List<User> userList = userService.findAllUser();
        List<Admin> admins = adminService.findAll();

        PageInfo pageInfo = new PageInfo(userList, 5);
        PageInfo pageInfo1 = new PageInfo(admins, 5);
        PageInfo<User> pageInfo3 = new PageInfo<>(userList);

        System.out.println(pageInfo.toString());
        System.out.println(pageInfo1.toString());
        System.out.println(pageInfo3.toString());

    }


    /**
     * 更新用户
     */
    @Test
    public void updateUser() {
        System.out.println("测试开始 updateUserTest....");
        User user = userService.getByUserId(108);
        user.setSex("男");
        userService.updateUser(user);
        System.out.println("更新完毕");
    }

    /**
     * 其他测试
     */
    @Test
    public void otherTest() {
        System.out.println("otherTest：。。。");
        String regTrue = "[\\u4e00-\\u9fa5]+";//表示+表示一个或多个中文
        String[] str = {"123", "", "woshi", "我是1", "1我", "s1", "李四"};
        // 错误的匹配方式
        for (String s : str) {
            System.out.println(s + " = " + regTrue.matches(s));
        }
        // 正确的匹配方式
        for (String s : str) {
            System.out.println(s + " = " + s.matches(regTrue));
        }
    }

    // 查询用户原始密码是否正确
    @Test
    public void checkOriginalPassWord() {
        // 获取文件路径
        File directory = new File("");//参数为空
        String courseFile = directory.getAbsolutePath();
        System.out.println(courseFile);

        String username = "user";
        String password = "user123";
        User user = userService.selectByLoginNameAndPassword(username, password);
        System.out.println(user);

    }


    @Test
    public void ty() {

        int num = 1;
        log.info("你好 = " + num);
    }

    @Test
    public void AlipayControllerTest(){
        int num = 200;
        log.info("czftest = " + num);
        log.info("czfk = " + num);
        log.info("czfy = " + num);
    }

    //@Test
    public static void main(String[] args) {
        userTest userTest = new userTest();
        userTest.ty();
    }

}
