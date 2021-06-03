package com.czf.test;

import com.czf.dao.AdminDao;
import com.czf.model.Admin;
import com.czf.service.AdminService;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import org.apache.ibatis.session.SqlSession;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.springframework.ui.Model;
import org.springframework.web.servlet.ModelAndView;

import javax.annotation.Resource;
import java.sql.Timestamp;
import java.util.Date;
import java.util.List;
import java.util.UUID;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(locations = {"classpath:applicationContext.xml"})
public class adminTest {

    @Autowired
    private AdminService adminService;

    @Autowired
    AdminDao adminDao;

    @Autowired
    SqlSession sqlSession;

    /**
     * 查找所有管理员
     */
    @Test
    public void findAllAdmin() {
        System.out.println("Test：查找所有管理员");
        List<Admin> admins = adminService.findAll();
        for (Admin admin : admins) {
            admin.setCreateTime(new Timestamp(admin.getCreateTime().getTime()));
            System.out.println(admin);
        }
    }

    /**
     * 插入管理员测试！
     */
    @Test
    public void insertAdmin() {
        System.out.println("Test：插入管理员");
        Admin admin = new Admin();
        admin.setAdminName("option1");
        admin.setAdminPassWord("123");
        admin.setRole("普通管理员");

        Date date = new Date();
        Timestamp timestamp = new Timestamp(date.getTime());
        admin.setCreateTime(timestamp);
        admin.setUpdateTime(timestamp);

        int sum = adminService.findByAdminName(admin.getAdminName());
        if (sum == 0) {
            adminService.insertAdmin(admin);
            System.out.println("插入成功！");
        } else {
            System.out.println("插入失败,已有该管理员！");
        }


    }

    /**
     * 最近插入上百条管理员数据
     */
    @Test
    public void Random() {
        AdminDao mapper = sqlSession.getMapper(AdminDao.class);
        for (int i = 0; i < 100; i++) {
            String name = UUID.randomUUID().toString().substring(0, 5) + "" + i;
            String password = UUID.randomUUID().toString().substring(0, 5) + "" + i;
            Date date = new Date();
            Timestamp timestamp = new Timestamp(date.getTime());
            // String adminName, String adminPassWord, String role, Date createTime, Timestamp updateTime
            Admin admin = new Admin(name, password, "普通管理员", timestamp, timestamp);
            mapper.insertAdmin(admin);
        }
    }

    /**
     * 分页查询
     */
    @Test
    public void PageInfoFindAll() {

        PageHelper.startPage(1, 5);

        List<Admin> empAll = adminService.findAll();
        for (Admin admin : empAll) {
            System.out.println(admin);
        }
    }

    /**
     * 根据id获取管理员
     */
    @Test
    public void getByAdminId(){

        int id = 10;
        Admin admin = adminService.getByAdminId(id);
        System.out.println(admin);

    }

    /**
     * 根据id编辑管理员信息
     */
    @Test
    public void updateAdmin(){
        Admin admin = adminDao.getByAdminId(87);
        admin.setAdminPassWord("admin3");
        System.out.println(admin);
        adminDao.updateAdmin(admin);

    }

    /**
     * 删除单个管理员
     */
    @Test
    public void deleteAdmin(){
        System.out.println("deleteAdminTest...");
        int id = 106;
        adminService.deleteByAdminId(106);

    }

    /**
     * 删除多个管理员
     */
    @Test
    public void deleteManyAdmin(){

        System.out.println("deleteManyAdminTest...");
        Integer[] ids = {107,108};
        adminDao.deleteByManyAdminId(ids);


    }

}
