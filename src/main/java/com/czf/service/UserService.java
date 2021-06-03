package com.czf.service;

import com.czf.model.User;
import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface UserService {

    /**
     * 登录
     * @return
     */
    public List<User> findAllUser();

    /**
     * 根据用户名和密码判断登陆
     *
     * @return
     */
    public User selectByLoginNameAndPassword(@Param("userName") String userName,
                                             @Param("passWord") String passWord);

    /**
     * 根据用户名查找用户
     * @param username
     * @return
     */
    public int findByUserName(String username);

    /**
     * 根据用户名查找用户,返回user
     *
     * @param username
     * @return
     */
    public User findByUserNameReturnUser(String username);

    /**
     * 根据id查找用户
     * @param userId
     * @return
     */
    public User getByUserId(Integer userId);

    /**
     * 管理员管理用户 多条件模糊查询
     * @param user
     * @return
     */
    public List<User> findUsersByParams(User user);

    /**
     * 添加用户
     * @param user
     * @return
     */
    public void insertUser(User user);

    /**
     * 用户更新信息
     * @param user
     */
    public void updateUser(User user);

    /**
     * 用户修改密码
     * @param user
     * @return
     */
    public Boolean updateUserPassWord(User user);

    /**
     * 删除单个用户
     * @param userId
     * @return
     */
    public int deleteByUserId(Integer userId);

    /**
     * 删除多个用户
     * @param ids
     * @return
     */
    public int deleteByManyUserId(Integer[] ids);

}
