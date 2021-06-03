package com.czf.test;

import com.czf.model.Comment;
import com.czf.model.Order;
import com.czf.service.CommentService;
import com.czf.service.OrderService;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import java.util.Date;
import java.util.List;


@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(locations = {"classpath:applicationContext.xml"})

public class commentTest {

    @Autowired
    private CommentService commentService;

    @Autowired
    private OrderService orderService;

    @Test
    public void getAll(){
        /*List<Comment> comments = commentService.getAllComments();
        for (Comment comment : comments) {
            System.out.println(comment);
        }*/
        commentService.updateAddress("11", 8);
    }

    @Test
    public void insert() {

        List<Order> orders = orderService.getUserAllOrdersByAdminOrDeliver();
        for (Order order : orders) {
            //System.out.println(order);
        }
        List<Comment> comments = commentService.getAllComments();
        for (Order order : orders) {
            for (Comment comment1 : comments) {
                Comment comment = new Comment();
                /* 重复订单编号就不要加了 */
                if (comment1.getOrderNumber() != order.getOrderNumber()) {
                    List<Comment> comment2 = commentService.getAllCommentsUserIdAndOrderId(order.getCustomerId(), order.getId());
                    if(comment2.size() == 0){
                        comment.setOrderNumber(order.getOrderNumber());
                        comment.setUserId(order.getCustomerId());
                        comment.setUserName(order.getUser().getUserName());
                        comment.setUserPhone(order.getUser().getPhone());
                        comment.setUserAddress(order.getAddress());
                        comment.setOrderId(order.getId());
                        comment.setCommentStatus(order.getStatus());
                        comment.setCreateTime(new Date());
                        commentService.insertComment(comment);
                    }
                }
            }
        }
    }

    @Test
    public void testOrder() {

        int userId = 106;
        int deliverId = 13;
        int orderId = 120;

        List<Comment> comments1 = commentService.getAllCommentsUserId(userId);
        List<Comment> comments2 = commentService.getAllCommentsUserIdAndDeliverId(userId, deliverId);
        List<Comment> comments3 = commentService.getAllCommentByUserIdAndDeliverIdAndOrderId(userId, deliverId, orderId);

        for (Comment comment : comments1) {
            System.out.println(comment);
        }

        System.out.println("==================================");
        for (Comment comment : comments2) {
            System.out.println(comment);
        }

        System.out.println("==================================");
        for (Comment comment : comments3) {
            System.out.println(comment);
        }


    }

}
