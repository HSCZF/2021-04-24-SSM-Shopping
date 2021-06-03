package com.czf.service.impl;

import com.czf.dao.UserDao;
import com.czf.model.User;
import com.czf.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
public class UserServiceImpl implements UserService {

    @Autowired
    private UserDao userDao;

    /**
     * 登录
     *
     * @return
     */
    @Override
    public List<User> findAllUser() {
        return userDao.findAllUser();
    }

    @Override
    public User selectByLoginNameAndPassword(String userName, String passWord) {
        User user = userDao.selectByLoginNameAndPassword(userName, passWord);
        //System.out.println("UserServiceImpl层selectByLoginNameAndPassword");
        //System.out.println("user = " + user);
        return user;
    }

    /**
     * 用户名是否存在验证
     *
     * @param username
     * @return
     */
    @Override
    public int findByUserName(String username) {
        if (userDao.findByUserName(username) == 0) {
            return 0;
        }
        return 1;
    }

    @Override
    public User findByUserNameReturnUser(String username) {
        return userDao.findByUserNameReturnUser(username);
    }

    @Override
    public User getByUserId(Integer userId) {
        return userDao.getByUserId(userId);
    }

    /**
     * 管理员管理用户 多条件模糊查询
     * @param user
     * @return
     */
    @Override
    public List<User> findUsersByParams(User user) {
        return userDao.findUsersByParams(user);
    }

    /**
     * 添加用户
     *
     * @param user
     * @return
     */
    @Override
    public void insertUser(User user) {
        userDao.insertUser(user);
    }

    @Override
    public void updateUser(User user) {
        userDao.updateUser(user);
    }

    @Override
    public Boolean updateUserPassWord(User user) {
        int num = (Integer)userDao.updateUserPassWord(user);
        //System.out.println("num = " + num);
        if(num >= 1){
            return true;
        }
        return false;
    }

    @Override
    public int deleteByUserId(Integer userId) {
        int sum = userDao.deleteByUserId(userId);
        if(sum >= 1){
            return 1;
        }
        return 0;
    }

    @Override
    public int deleteByManyUserId(Integer[] ids) {
        int sum = userDao.deleteByManyUserId(ids);;
        if(sum >= 1){
            return 1;
        }
        return 0;
    }

}
