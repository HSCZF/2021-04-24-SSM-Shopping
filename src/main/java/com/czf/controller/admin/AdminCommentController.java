package com.czf.controller.admin;

import com.czf.model.Admin;
import com.czf.model.Comment;
import com.czf.model.Order;
import com.czf.service.*;
import com.czf.utils.Msg;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.ObjectUtils;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpSession;
import java.util.List;

@Controller
@RequestMapping("/admin/comment")
public class AdminCommentController {


    @Autowired
    private OrderService orderService;

    @Autowired
    private OrderItemService orderItemService;

    @Autowired
    private CommentService commentService;

    @Autowired
    private UserService userService;

    /**
     * 管理员分页所有配送订单
     *
     * @param pageNum
     * @param model
     * @return
     */
    @RequestMapping("getAllComments")
    public String getAllComments(Integer pageNum, Model model, HttpSession session) {
        System.out.println("管理员：配送订单/评论分页");
        Admin admin = (Admin) session.getAttribute("session_admin");
        if (ObjectUtils.isEmpty(admin)) {
            // 传回来为空，则设为 1
            return "system/login";
        }
        if (ObjectUtils.isEmpty(pageNum)) {
            // 传回来为空，则设为 1
            pageNum = 1;
        }
        PageHelper.startPage(pageNum, 5);
        List<Comment> commentList = commentService.getAllComments();
        PageInfo<Comment> pageInfo = new PageInfo<>(commentList);
        model.addAttribute("pageInfo", pageInfo);
        return "/system/comments";
    }

    /**
     * 配送订单模糊查询
     *
     * @param pageNum
     * @param model
     * @param comment
     * @param session
     * @return
     */
    @RequestMapping("/getParamsByCommentInput")
    public String getParamsByCommentInput(Integer pageNum, Model model, Comment comment, HttpSession session) {
        System.out.println("用户模糊搜索");
        Admin admin = (Admin) session.getAttribute("session_admin");
        if (ObjectUtils.isEmpty(admin)) {
            // 传回来为空，则设为 1
            return "system/login";
        }
        if (ObjectUtils.isEmpty(pageNum)) {
            // 传回来为空，则设为 1
            pageNum = 1;
        }
        System.out.println("pageNum = " + pageNum);
        PageHelper.startPage(pageNum, 5);
        List<Comment> commentList = commentService.getParamsByCommentInput(comment);
        PageInfo<Comment> pageInfo = new PageInfo<>(commentList);
        model.addAttribute("pageInfo", pageInfo);
        model.addAttribute("params", comment);
        return "/system/comments";
    }

    /**
     * 获取一个配送信息
     *
     * @param id
     * @return
     */
    @RequestMapping("/getOneCommentById")
    @ResponseBody
    public Msg getOneCommentById(Integer id) {
        Comment comment = commentService.getOneCommentById(id);
        if (comment != null) {
            return Msg.success().add("comment", comment);
        } else {
            return Msg.fail().add("vag", "取数据失败");
        }
    }

    /**
     * 修改配送订单
     *
     * @return
     */
    @RequestMapping("/updateComment")
    @ResponseBody
    public Msg updateComment(Integer id, String address) {

        Comment comment = commentService.getOneCommentById(id);
        Boolean flag = commentService.updateAddress(address, id);
        orderService.updateOrderByAdmin(comment.getOrderId(), address);
        if (flag) {
            return Msg.success();
        } else {
            return Msg.fail();
        }

    }


}
