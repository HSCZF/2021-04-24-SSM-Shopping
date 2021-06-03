package com.czf.service.impl;

import com.czf.dao.CommentDao;
import com.czf.dao.OrderDao;
import com.czf.model.*;
import com.czf.service.CommentService;
import org.apache.ibatis.annotations.Param;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

@Service
@Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
public class CommentServiceImpl implements CommentService {

    @Autowired
    private CommentDao commentDao;

    @Autowired
    private OrderDao orderDao;

    @Override
    public void insertComment(Comment comment) {
        commentDao.insertComment(comment);
    }

    @Override
    public Comment getOrderUserId(Integer orderId) {
        return commentDao.getOrderUserId(orderId);
    }

    @Override
    public Comment getOneCommentById(Integer id) {
        return commentDao.getOneCommentById(id);
    }

    @Override
    public List<Comment> getAllComments() {
        return commentDao.getAllComments();
    }

    /**
     * 模糊查询
     * @param comment
     * @return
     */
    @Override
    public List<Comment> getParamsByCommentInput(Comment comment) {
        return commentDao.getParamsByCommentInput(comment);
    }

    /**
     * 这里查comment,根据配送员id 和 订单状态查询订单
     *
     * @param deliverId
     * @param status
     * @return
     */
    @Override
    public List<Comment> getAllCommentsByDeliverIdAndStatus(Integer deliverId, Integer status) {
        return commentDao.getAllCommentsByDeliverIdAndStatus(deliverId, status);
    }

    @Override
    public List<Comment> getAllCommentsByDeliverIdAndStatusNoAll(Integer deliverId) {
        return commentDao.getAllCommentsByDeliverIdAndStatusNoAll(deliverId);
    }


    /**
     * 根据用户id ，附带有评论或无评论一起查
     *
     * @param userId
     * @return
     */
    @Override
    public List<Comment> getAllCommentsUserId(Integer userId) {
        return commentDao.getAllCommentsUserId(userId);
    }

    /**
     * 根据用户id、配送员id，附带有评论或无评论一起查
     *
     * @param userId
     * @param deliverId
     * @return
     */
    @Override
    public List<Comment> getAllCommentsUserIdAndDeliverId(Integer userId, Integer deliverId) {
        return commentDao.getAllCommentsUserIdAndDeliverId(userId, deliverId);
    }

    /**
     * 根据用户id 和 订单id 的配送订单，附带有评论或无评论一起查
     *
     * @param userId
     * @param orderId
     * @return
     */
    @Override
    public List<Comment> getAllCommentsUserIdAndOrderId(Integer userId, Integer orderId) {
        return commentDao.getAllCommentsUserIdAndOrderId(userId, orderId);
    }

    /**
     * 根据用户id、配送员id、订单id，附带有评论或无评论一起查
     *
     * @param userId
     * @param deliverId
     * @param orderId
     * @return
     */
    @Override
    public List<Comment> getAllCommentByUserIdAndDeliverIdAndOrderId(Integer userId, Integer deliverId, Integer orderId) {
        return commentDao.getAllCommentByUserIdAndDeliverIdAndOrderId(userId, deliverId, orderId);
    }


    /*===================================== updateDeliverOrderStatusByDeliverIdAndOrderId 重载函数=============================*/

    /**
     * 取货确认过程用户不需要变更状态     *
     * @param deliverId
     * @param orderId
     * @param deliverStatus
     * @return
     */
    @Override
    public Boolean updateDeliverOrderStatusByDeliverIdAndOrderId(Integer deliverId, Integer orderId, Integer deliverStatus) {
        int sum = commentDao.updateDeliverOrderStatusByDeliverIdAndOrderId(deliverId, orderId, deliverStatus);
        if (sum >= 1) {
            return true;
        }
        return false;
    }

    /**
     * 更改未配送、配送中、配送完成  三合一  配送员 状态修改合集
     *
     * @param deliverId
     * @param userId
     * @param orderId
     * @param deliverStatus
     * @param userStatus
     * @return
     */
    @Override
    public Boolean updateDeliverOrderStatusByDeliverIdAndOrderId(Integer deliverId, Integer orderId, Integer deliverStatus, Integer userId, Integer userStatus) {
        int sum = commentDao.updateDeliverOrderStatusByDeliverIdAndOrderId(deliverId, orderId, deliverStatus);
        int sum1 = orderDao.updateUserOrderStatusByUserIdAndOrderId(userId, orderId, userStatus);
        if (sum >= 1 && sum1 >= 1) {
            return true;
        }
        return false;
    }

    /**
     * 更新配送完成的时间
     * @param deliverId
     * @param orderId
     * @param date
     * @return
     */
    @Override
    public Boolean updateFinishedByDeliverAndOrderId(Integer deliverId, Integer orderId, Date date) {
        int sum = commentDao.updateFinishedByDeliverAndOrderId(deliverId, orderId, date);
        if(sum >= 1){
            return true;
        }
        return false;
    }

    /**
     * 更新配送完成的时间
     * @param comment
     * @return
     */
    @Override
    public Boolean updateComment(String comment,Integer orderId) {
        int sum = commentDao.updateComment(comment, orderId);
        if(sum >= 1){
            return true;
        }
        return false;
    }

    @Override
    public Boolean updateAddress(String userAddress ,Integer id) {
        int sum = commentDao.updateAddress(userAddress, id);
        if(sum >= 1){
            return true;
        }
        return false;
    }




}
