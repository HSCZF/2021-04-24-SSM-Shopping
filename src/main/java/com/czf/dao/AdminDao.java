package com.czf.dao;

import com.czf.model.Admin;
import com.czf.model.Deliver;
import com.czf.model.User;

import java.util.List;

public interface AdminDao {

    /**
     * 查找所有管理员
     * @return
     */
    public List<Admin> findAll();

    /**
     * 管理员是否存在
     * @param adminName
     * @return
     */
    public int findByAdminName(String adminName);

    /**
     * 添加管理员
     * @param admin
     * @return
     */
    public void insertAdmin(Admin admin);

    /**
     * 根据id查询管理员
     * @param adminId
     * @return
     */
    public Admin getByAdminId(Integer adminId);

    /**
     * 管理员更新信息
     * @param admin
     */
    public int updateAdmin(Admin admin);

    /**
     * 删除单个管理员
     * @param adminId
     * @return
     */
    public int deleteByAdminId(Integer adminId);

    /**
     * 删除多个管理员
     * @param ids
     * @return
     */
    public int deleteByManyAdminId(Integer[] ids);


}
