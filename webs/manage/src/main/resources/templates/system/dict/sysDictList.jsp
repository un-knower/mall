<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="shiro" uri="http://shiro.apache.org/tags" %>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<head>
    <title>洋桃跨境供应链后台管理中心-数据字典列表</title>
    <jsp:include page="../../member/common/memberCommon.jsp"></jsp:include>
</head>
<body>
<div class="main">
    <div class="table-container">
        <shiro:hasPermission name="sysDict:add">
            <div class="function-button">
                 <button type="button"  class="button button-ffac00" onclick="editOrAddDict()">新增</button>
            </div>
        </shiro:hasPermission>
        <div class="main-content">
            <div class="word-screen word-screen-hide">
                <div class="word-screen-operation">
                    <a class="word-screen-button gatherTableList-qry" id="sysDict-qry" href="javascript:;"><i></i>搜索</a>
                    <a class="click-show-hide" href="javascript:;"><i></i><span></span></a>
                </div>
                <div class="word-screen-cont">
                    <form id="searchForm">
                        <ul>
                            <li>
                                <label class="name">字典编码：</label>
                                <input class="type-text" type="text" id="dictCode"/>
                            </li>
                            <li>
                                <label class="name">字典名称：</label>
                                <input class="type-text" type="text" id="dictValue"/>
                            </li>
                            <li>
                                <label class="name">状态：</label>
                                <div class="select-box">
                                    <select id="sysDictState">
                                        <option value="">请选择</option>
                                        <c:forEach items="${statusMap}" var="m">
                                            <option value="${m.key}">${m.value}</option>
                                        </c:forEach>
                                    </select>
                                    <i></i>
                                </div>
                            </li>
                        </ul>
                    </form>
                    <div class="clear"></div>
                </div>
            </div>

            <div class="yt-table" >
                <table id="sysDictlist" class="easyui-datagrid" style="width:98%;height: 464px;"></table>
            </div>
        </div>
    </div>
</div>
<script>
    $(function(){
        $('#sysDictlist').datagrid({
            url : '/sysDict/paging',
            fit : true,
            nowrap : true,
            fitColumns : true,
            pagination : true,
            rownumbers : true,
            pageSize : 10,
            pageList : [10, 20, 30, 40, 50 ],
            idField : 'id',
            columns : [ [/* {
                field : 'idx',
                checkbox:true
            },*/

            {
                field : 'control',
                align : 'center',
                width : "15%",
                title : '操作',
                formatter : function(value, rowData, rowIndex){
                    var array=[];
                    array.push('<a class="margin-auto click-icon click-icon-check" href="javascript:void(0)" title="查看" onclick="showForDict('+rowData.idx+')"></a>');
                    if(rowData.status == '1'){
                        <shiro:hasPermission name="sysDict:disabled">
                        array.push('<a class="margin-auto click-icon click-icon-off" href="javascript:void(0)" title="禁用" onclick="$updateStatus(\'/sysDict/updateStatus/'+rowData.idx+'/2\', null, \'sysDictlist\');"></a>');
                        </shiro:hasPermission>
                        <shiro:hasPermission name="sysDict:edit">
                        array.push('<a class="margin-auto click-icon click-icon-edit" href="javascript:void(0)" title="编辑" onclick="editOrAddDict('+rowData.idx+')"></a>');
                        </shiro:hasPermission>
                        <shiro:hasPermission name="sysDict:del">
                        array.push('<a class="margin-auto click-icon click-icon-del" href="javascript:void(0)" title="删除" onclick="$updateStatus(\'/sysDict/updateStatus/'+rowData.idx+'/0\', null, \'sysDictlist\');"></a>');
                        </shiro:hasPermission>
                    }
                    if(rowData.status == '2'){
                        <shiro:hasPermission name="sysDict:recover">
                        array.push('<a class="margin-auto click-icon click-icon-open" href="javascript:void(0)" title="激活" onclick="$updateStatus(\'/sysDict/updateStatus/'+rowData.idx+'/1\', null, \'sysDictlist\');"></a>');
                        </shiro:hasPermission>
                        <shiro:hasPermission name="sysDict:del">
                        array.push('<a class="margin-auto click-icon click-icon-del" href="javascript:void(0)" title="删除" onclick="$updateStatus(\'/sysDict/updateStatus/'+rowData.idx+'/0\', null, \'sysDictlist\');"></a>');
                        </shiro:hasPermission>
                    }
                    return array.join('');
                }
            },
            {
                field : 'idx',
                align : 'center',
                width : 30,
                sortable : true,
                title : 'ID'
            }, {
                field : 'dictCode',
                align : 'center',
                width : 30,
                sortable : true,
                title : '字典编码'
            },{
                field : 'dictKey',
                align : 'center',
                width : 30,
                sortable : true,
                title : '字典值'
            },{
                field : 'dictValue',
                align : 'center',
                width : 30,
                sortable : true,
                title : '字典名称'
            },{
                field : 'zindex',
                align : 'center',
                width : 20,
                sortable : true,
                title : '排序'
            }
            ,{
                field : 'status',
                align : 'center',
                width : 20,
                title : '状态',
                    sortable : true,
                formatter : function(value, rowData, rowIndex){
                    return '<span class="state-'+value+'">' + ${statusMapJson}[value] + '</span>';
                }
            } ] ],
            onLoadSuccess: function (data) {
                $(this).datagrid("fixRownumber");/* 表格行数宽度随内容变化 */
                $('#sysDictlist').datagrid('clearSelections');
            }
        });

        $('#sysDict-qry').on('click',function () {
            $('#sysDictlist').datagrid('load',{
                dictCode:$.trim($('#dictCode').val()),
                dictValue:$.trim($('#dictValue').val()),
                status:$.trim($('#sysDictState').val())
            });
        });

    });



    /**
     *  编辑或者新增
     * @param idx 主键idx
     */
    function editOrAddDict(idx) {
        var url = idx ? '/sysDict/edit/'+idx : '/sysDict/add/1';
        var title =idx ? '修改数据字典' : '新增数据字典';
        //页面层
        parent.layer.open({
            title: title,
            type: 2,
            btnAlign: 'c',
            btn: ['保存','关闭'],
            resize:false,
            area: ['530px', '466px'], //宽高
            content: [url, 'no'],
            yes: function(index, layero){
                parent.layer.load(2,{
                    shade : 0.01,
                    time : 5000
                });
                var iframeWin = parent.window[layero.find('iframe')[0]['name']];
                iframeWin.submitForm($('#sysDictlist'));
                return false;
            }
        });
    }
    /**
     *  编辑或者新增
     * @param idx 主键idx
     */
    function showForDict(idx) {
        var url = '/sysDict/view/'+idx ;
        var title ='查看数据字典';
        //页面层
        parent.layer.open({
            title: title,
            type: 2,
            btnAlign: 'c',
            btn: ['关闭'],
            resize:false,
            area: ['530px', '466px'], //宽高
            content: [url, 'no']
        });
    }
</script>
<!-- 使用easyui的tabs head标签的东西，在首页读取不到，只会把css和js放在body中 -->
<link rel="stylesheet" href="${static$domain}/css/common/current.css?_v=${css$version}"/>

</body>
</html>

