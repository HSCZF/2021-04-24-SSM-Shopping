package com.czf.service.impl;

import com.czf.dao.AdminDao;
import com.czf.model.Admin;
import com.czf.service.AdminService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
public class AdminServiceImpl implements AdminService {

    @Autowired
    private AdminDao adminDao;

    // 查找所有管理员账号
    @Override
    public List<Admin> findAll() {
        //System.out.println("业务层。。。查询");
        return adminDao.findAll();
    }

    @Override
    public int findByAdminName(String adminName) {
        if(adminDao.findByAdminName(adminName) == 0){
            return 0;
        }
        return 1;
    }

    @Override
    public void insertAdmin(Admin admin) {
        adminDao.insertAdmin(admin);
    }

    @Override
    public Admin getByAdminId(Integer adminId) {
        return adminDao.getByAdminId(adminId);
    }

    @Override
    public void updateAdmin(Admin admin) {
        adminDao.updateAdmin(admin);
    }

    @Override
    public void deleteByAdminId(Integer adminId) {
        adminDao.deleteByAdminId(adminId);
    }

    @Override
    public void deleteByManyAdminId(Integer[] ids) {
        adminDao.deleteByManyAdminId(ids);
    }


}
