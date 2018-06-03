package com.whl.mall.core.transcation.pojo;
/**
 * @Title: AbstractTranscatonDBPojo
 * @Package: com.whl.mall.core.base.pojo
 * @Description:
 * @Author: WangHongLin
 * @Date: 2018-06-02 上午 10:56
 * @Version: V2.0.0
 */

import com.whl.mall.core.base.pojo.MallAbstractBasePoJo;
import com.whl.mall.core.transcation.common.enums.RoleTranscationPropertiesEnum;

/**
 * @ClassName: AbstractTranscatonDBPojo
 * @Description:
 * @Author: WangHongLin
 * @Date: 2018-06-02 上午 10:56
 */
public abstract class MallAbstractTranscatonDBPojo extends MallAbstractBasePoJo implements MallTranscationPoJo{
    @Override
    public Enum[] getEnum() {
        return RoleTranscationPropertiesEnum.values();
    }
}
