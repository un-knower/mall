/**
 * 广州市两棵树网络科技有限公司版权所有
 * DT Group Technology & commerce Co., LtdAll rights reserved.
 * <p>
 * 广州市两棵树网络科技有限公司，创立于2009年。旗下运营品牌洋葱小姐。
 * 洋葱小姐（Ms.Onion） 下属三大业务模块 [洋葱海外仓] , [洋葱DSP] , [洋葱海外聚合供应链]
 * [洋葱海外仓]（DFS）系中国海关批准的跨境电商自营平台(Cross-border ecommerce platform)，
 * 合法持有海外直邮保税模式的跨境电商营运资格。是渠道拓展，平台营运，渠道营运管理，及客户服务等前端业务模块。
 * [洋葱DSP]（DSP）系拥有1.3亿消费者大数据分析模型。 是基于客户的消费行为，消费轨迹，及多维度云算法(MDPP)
 * 沉淀而成的精准消费者模型。洋葱DSP能同时为超过36种各行业店铺 及200万个销售端口
 * 进行多店铺高精度配货，并能预判消费者购物需求进行精准推送。同时为洋葱供应链提供更前瞻的商品采买需求模型 。
 * [洋葱海外聚合供应链]（Super Supply Chain）由中国最大的进口贸易集团共同
 * 合资成立，拥有20余年的海外供应链营运经验。并已入股多家海外贸易企业，与欧美澳等9家顶级全球供应商达成战略合作伙伴关系。
 * 目前拥有835个国际品牌直接采买权，12万个单品的商品供应库。并已建设6大海外直邮仓库，为国内客户提供海外商品采买集货供应，
 * 跨境 物流，保税清关三合一的一体化模型。目前是中国唯一多模式聚合的海外商品供应链 。
 * <p>
 * 洋葱商城：http://m.msyc.cc/wx/indexView?tmn=1
 * <p>
 * 洋桃商城：http://www.yunyangtao.com
 */
package com.whl.mall.core.base.service.ext.impl;

/**
 * @Title: ShopRabbitmqServiceImpl
 * @Package: com.shop.common.base.service.impl
 * @Description:
 * @Company: 广州市两棵树网络科技有限公司
 * @Author: WangHongLin timo-wang@msyc.cc
 * @Date: 2018/3/28
 * @Version: V2.0.10
 * @Modify-by: WangHongLin timo-wang@msyc.cc
 * @Modify-date: 2018/3/28
 * @Modify-version: 2.1.5
 * @Modify-description: 新增：增，删，改，查方法
 */

import com.whl.mall.core.MallException;
import com.whl.mall.core.annotations.MallMQ;
import com.whl.mall.core.base.pojo.MallBasePoJo;
import com.whl.mall.core.base.service.ext.MallMQServiceExt;
import com.whl.mall.core.common.constants.MallConstants;
import com.whl.mall.core.common.constants.MallStatus;
import com.whl.mall.core.common.utils.MallJsonUtils;
import com.whl.mall.core.log.MallLog4jLog;
import org.apache.commons.lang3.StringUtils;
import org.springframework.amqp.AmqpException;
import org.springframework.amqp.core.Message;
import org.springframework.amqp.core.MessageBuilder;
import org.springframework.amqp.core.MessageProperties;
import org.springframework.amqp.rabbit.core.RabbitTemplate;
import org.springframework.amqp.rabbit.support.CorrelationData;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

/**
 * @ClassName: ShopRabbitmqServiceImpl
 * @Description: Rabbitmq 服务
 * @Company: 广州市两棵树网络科技有限公司
 * @Author: WangHonglin timo-wang@msyc.cc
 * @Date: 2018/3/28
 */
@Service("mqService")
public class MallRabbitmqServiceImpl<T extends MallBasePoJo> extends MallMQServiceExt<T> {
    /**
     * rabbitTemplate 必须多例，否则会导致发送A队列变成发送到B队列了
     */
    @Autowired
    private RabbitTemplate rabbitTemplate;

    @Override
    public void sendMsg(T po) throws MallException{
        MallMQ mq = po.getClass().getAnnotation(MallMQ.class);
        if (mq == null) {
            return;
        }
        String module = mq.module();
        String exchangeName = mq.exchangeName();
        String routingkey = mq.routingKey();
        String tag = mq.tag();
        if (!isSendMQ(module, exchangeName, routingkey)) {
            return;
        }
        try {
            // 消息体
            byte[] body = MallJsonUtils.objectToJson(po).getBytes();
            // 消息特性
            MessageProperties messageProperties = new MessageProperties();
            messageProperties.setDeliveryMode(mq.persistent());
            messageProperties.setContentEncoding(MallConstants.DEFAULT_ENCODING);
            Message message = new Message(body, messageProperties);

            // 消息唯一标识
            CorrelationData correlationData = new CorrelationData();
            correlationData.setId(tag);

            rabbitTemplate.setExchange(exchangeName);
            rabbitTemplate.convertAndSend(routingkey, message, correlationData);
        } catch (AmqpException e) {
            throw new MallException(MallStatus.HTTP_STATUS_500, String.format("DB save success, %s=", "消息发送阶段失败"));
        } catch (Exception e) {
            throw new MallException(MallStatus.HTTP_STATUS_500, String.format("DB save success, %s=", "消息初始化阶段失败"));
        }
    }

    /**
     * 判断是否需要发送MQ
     *
     * @param module
     * @param exchangeName
     * @param routingkey
     * @return
     */
    private boolean isSendMQ(String module, String exchangeName, String routingkey) throws MallException {
        if (StringUtils.isEmpty(module) || StringUtils.isEmpty(exchangeName) || StringUtils.isEmpty(routingkey)) {
            return false;
        }
        return true;
    }
}
