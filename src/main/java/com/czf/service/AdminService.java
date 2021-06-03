package com.czf.service;


import com.czf.model.Admin;

import java.util.List;

public interface AdminService {

    // 查找所有管理员账号
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
    public void updateAdmin(Admin admin);

    /**
     * 删除单个管理员
     * @param adminId
     * @return
     */
    public void deleteByAdminId(Integer adminId);

    /**
     * 删除多个管理员
     * @param ids
     * @return
     */
    public void deleteByManyAdminId(Integer[] ids);

}
