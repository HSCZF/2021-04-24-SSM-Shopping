package com.czf.controller.comment;

import com.czf.model.User;
import com.czf.service.CommentService;
import com.czf.utils.Msg;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.util.ObjectUtils;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpSession;

@Controller
@RequestMapping("/comment")
public class CommentController {

    @Autowired
    private CommentService commentService;

    /**
     * 用户评论订单
     * @param commentOrderId
     * @param session
     * @return
     */
    @RequestMapping("/commentOrder")
    @ResponseBody
    public Msg commentOrder(Integer commentOrderId, HttpSession session){
        System.out.println("用户评论订单。。。。");
        User user = (User) session.getAttribute("session_user");
        if (ObjectUtils.isEmpty(user)) {
            //用户没有登录，则提示让他登录，
            return Msg.fail().add("vag", "请登录在操作");
        }

        

        return Msg.success().add("vag", "评论添加成功");
    }

}
