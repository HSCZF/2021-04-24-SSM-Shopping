package com.czf.controller.shop;

import com.czf.model.Shop;
import com.czf.model.ShopVo;
import com.czf.model.User;
import com.czf.service.ShopService;
import com.czf.utils.Msg;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.ObjectUtils;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpSession;
import java.util.HashMap;
import java.util.Map;

@Controller
@RequestMapping("/shop")
public class ShopController {

    @Autowired
    private ShopService shopService;

    /**
     * 添加用户配送地址
     * @param ShopVo
     * @param session
     * @param model
     * @return
     */
    @RequestMapping("toAddShop")
    @ResponseBody
    public Msg toAddShop(ShopVo ShopVo, HttpSession session, Model model) {
        System.out.println("==========================================");
        System.out.println("添加用户配送地址。。。。");
        User user = (User)session.getAttribute("session_user");
        if (ObjectUtils.isEmpty(user)) {
            //用户没有登录，则提示让他登录
            return Msg.fail().add("vag", "请登录在操作");
        }
        try {
            int shopId = shopService.addShop(ShopVo, user.getId());
            model.addAttribute("shopId", shopId);
            return Msg.success().add("vag", "地址新增成功");
        } catch (Exception e) {
            return Msg.fail().add("vag", "地址新增失败");
        }
    }
    
    /**
     * 显示用户的一个地址信息
     * @param shopId
     * @param session
     * @return
     */
    @RequestMapping("getOneAddressShop")
    @ResponseBody
    public Msg getOneAddressShop(Integer shopId, HttpSession session) {
        System.out.println("==========================================");
        System.out.println("显示用户的一个地址信息。。。。");
        User user = (User)session.getAttribute("session_user");
        if (ObjectUtils.isEmpty(user)) {
            //用户没有登录，则提示让他登录
            return Msg.fail().add("vag", "请登录在操作");
        }
        try {
            Shop shop = shopService.findShopByUserIdAndShopId(user.getId(), shopId);
            System.out.println("shop = " + shop);
            return Msg.success().add("shop", shop);

        } catch (Exception e) {
            return Msg.fail().add("vag", "获取用户一个地址失败");
        }
    }

    /**
     * 用户修改配送地址
     * @param shopVo
     * @param session
     * @return
     */
    @RequestMapping("updateShopAddress")
    @ResponseBody
    public Msg updateShopAddress(ShopVo shopVo, HttpSession session){
        System.out.println("========================================================");
        System.out.println("用户修改配送地址。。。。");
        User user = (User)session.getAttribute("session_user");
        if (ObjectUtils.isEmpty(user)) {
            //用户没有登录，则提示让他登录
            return Msg.fail().add("vag", "请登录在操作");
        }
        //System.out.println("用户修改配送地址="+shopVo);  // 一直拿的是第一个
        Boolean flag = shopService.updateShopAddress(shopVo, user.getId());
        if (flag) {
            return Msg.success().add("vag","地址修改成功");
        }
        return Msg.fail().add("vag","地址修改失败");
    }

    /**
     * 检查校验省份信息，boostrap校验，封装map
     * @param receiverProvince
     * @return
     */
    @RequestMapping("checkValidateProvince")
    @ResponseBody
    public Map<String, Object> checkValidateProvince(String receiverProvince) {
        Map<String, Object> map = new HashMap<>();
        // 用"".equals的匹配顺序的写法，避免空指针异常
        if (receiverProvince == null || "省份".equals(receiverProvince)) {
            // 校验固定的存放写法，必须是valid、message
            map.put("valid", false);
            map.put("message", "请选择省份");
            return map;
        }
        map.put("valid", true);
        return map;
    }

    /**
     * 检查校验城市信息，boostrap校验，封装map
     * @param receiverCity
     * @return
     */
    @RequestMapping("checkValidateCity")
    @ResponseBody
    public Map<String, Object> checkValidateCity(String receiverCity) {
        Map<String, Object> map = new HashMap<>();
        if (receiverCity == null || "地级市".equals(receiverCity)) {
            map.put("valid", false);
            map.put("message", "请选择地级市");
            return map;
        }
        map.put("valid", true);
        return map;
    }

    /**
     * 检查校验区县信息，boostrap校验，封装map
     * @param receiverDistrict
     * @return
     */
    @RequestMapping("checkValidateDistrict")
    @ResponseBody
    public Map<String, Object> checkValidateDistrict(String receiverDistrict) {
        Map<String, Object> map = new HashMap<>();
        if (receiverDistrict == null || "县级市".equals(receiverDistrict)) {
            map.put("valid", false);
            map.put("message", "请选择县级市");
            return map;
        }
        map.put("valid", true);
        return map;
    }

    /**
     * 用户删除一个地址
     * @param shopId
     * @param session
     * @return
     */
    @RequestMapping("/deleteShopAddress")
    @ResponseBody
    public Msg deleteShopAddress(Integer shopId, HttpSession session){
        System.out.println("========================================================");
        System.out.println("用户删除一个地址。。。。");
        User user = (User)session.getAttribute("session_user");
        if (ObjectUtils.isEmpty(user)) {
            //用户没有登录，则提示让他登录
            return Msg.fail().add("vag", "请登录在操作");
        }
        if(shopService.deleteShopAddress(shopId, user.getId())){
            return Msg.success().add("vag", "该地址已移除");
        }
        return Msg.fail().add("vag", "移除地址失败");
    }

}
