package com.czf.dao;

import com.czf.model.User;
import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface UserDao {

    /**
     * 查找所有用户
     *
     * @return
     */
    public List<User> findAllUser();

    /**
     * 管理员管理用户 多条件模糊查询
     * @param user
     * @return
     */
    List<User> findUsersByParams(User user);

    /**
     * 根据用户名和密码判断登陆
     *
     * @return
     */
    public User selectByLoginNameAndPassword(@Param("userName") String userName,
                                      @Param("passWord") String passWord);

    /**
     * 根据用户名查找用户，返回int
     *
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
     *
     * @param userId
     * @return
     */
    public User getByUserId(Integer userId);

    /**
     * 添加用户
     *
     * @param user
     * @return
     */
    public void insertUser(User user);

    /**
     * 用户更新信息
     *
     * @param user
     */
    public int updateUser(User user);

    /**
     * 用户修改密码
     * @param user
     * @return
     */
    public int updateUserPassWord(User user);

    /**
     * 删除单个用户
     *
     * @param userId
     * @return
     */
    public int deleteByUserId(Integer userId);

    /**
     * 删除多个用户
     *
     * @param ids
     * @return
     */
    public int deleteByManyUserId(Integer[] ids);


}
