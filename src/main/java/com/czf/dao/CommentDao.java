package com.czf.dao;

import com.czf.model.Comment;
import org.apache.ibatis.annotations.Param;

import java.util.Date;
import java.util.List;

public interface CommentDao {

    /**
     * 插入配送订单和评论
     */
    public void insertComment(Comment comment);

    /**
     * 获取订单下的用户id
     *
     * @param orderId
     * @return
     */
    public Comment getOrderUserId(@Param("orderId") Integer orderId);

    /**
     * 根据id查配送
     *
     * @param id
     * @return
     */
    public Comment getOneCommentById(@Param("id") Integer id);

    /**
     * 查询所有配送/评论
     *
     * @return
     */
    List<Comment> getAllComments();

    /**
     * 模糊查询
     *
     * @param comment
     * @return
     */
    List<Comment> getParamsByCommentInput(Comment comment);

    /**
     * 根据配送员id 和 订单状态查询订单
     *
     * @param deliverId
     * @param status
     * @return
     */
    List<Comment> getAllCommentsByDeliverIdAndStatus(@Param("deliverId") Integer deliverId,
                                                     @Param("commentStatus") Integer status);

    /**
     * 根据配送员id 和 订单状态不是 5 的订单
     *
     * @param deliverId
     * @return
     */
    List<Comment> getAllCommentsByDeliverIdAndStatusNoAll(@Param("deliverId") Integer deliverId);


    /**
     * 根据用户id，附带有评论或无评论一起查
     *
     * @param userId
     * @return
     */
    List<Comment> getAllCommentsUserId(@Param("userId") Integer userId);

    /**
     * 根据用户id、配送员id，附带有评论或无评论一起查
     *
     * @param userId
     * @param deliverId
     * @return
     */
    List<Comment> getAllCommentsUserIdAndDeliverId(@Param("userId") Integer userId, @Param("deliverId") Integer deliverId);

    /**
     * 根据用户id 和 订单id 的配送订单，附带有评论或无评论一起查
     *
     * @param userId
     * @param orderId
     * @return
     */
    List<Comment> getAllCommentsUserIdAndOrderId(@Param("userId") Integer userId, @Param("orderId") Integer orderId);

    /**
     * 根据用户id、配送员id、订单id，附带有评论或无评论一起查
     *
     * @param userId
     * @param deliverId
     * @param orderId
     * @return
     */
    List<Comment> getAllCommentByUserIdAndDeliverIdAndOrderId(@Param("userId") Integer userId,
                                                              @Param("deliverId") Integer deliverId,
                                                              @Param("orderId") Integer orderId);

    /**
     * 更改未配送、配送中、配送完成  三合一  配送员 状态修改合集
     *
     * @param deliverId
     * @param orderId
     * @param status
     * @return
     */
    public int updateDeliverOrderStatusByDeliverIdAndOrderId(@Param("deliverId") Integer deliverId,
                                                             @Param("orderId") Integer orderId,
                                                             @Param("commentStatus") Integer status);

    /**
     * 更新配送完成的时间
     *
     * @param date
     * @return
     */
    public int updateFinishedByDeliverAndOrderId(@Param("deliverId") Integer deliverId,
                                                 @Param("orderId") Integer orderId,
                                                 @Param("endTime") Date date);

    /**
     * 更新配送完成的时间
     *
     * @param comment
     * @return
     */
    public int updateComment(@Param("comment") String comment,
                             @Param("orderId") Integer orderId);

    /**
     * 更新地址
     *
     * @param id
     * @param userAddress
     * @return
     */
    public int updateAddress(@Param("userAddress") String userAddress,
                             @Param("id") Integer id);

}
