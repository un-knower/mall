<!DOCTYPE html>
<head>
    <title>洋桃跨境供应链后台管理中心-选择资源组列表</title>
    <#include "../../common/memberCommon.jsp"/>
</head>
<body>
<link rel="stylesheet" href="/css/common/current.css?_v="/>

<section class="main" style="padding: 10px;background: #fff;">
    <div class="table-container" style="height: 543px;">

        <div class="main-content">
            <div class="screen" >
                <div class="screen-row">
                    <label class="name">名称：</label>
                    <input class="txt" type="text" id="resourceGourpName2">

                    <span class="search" id="resourceGourplist-qry2"><i></i>搜索</span>
                </div>
            </div>

            <div class="yt-table" >

                <table id="resourceGourplist2" class="easyui-datagrid" style="width:98%;height:420px">

                </table>

            </div>
        </div>
    </div>

</section>
<script type="text/javascript">
    var txtArr = [],defalutIdxArr = ${resourceGroupIdxsJson! '[]'} ;
    $(function(){
        $('#resourceGourplist2').datagrid({
            url : '/resourceGroup/paging',
            fit : true,
            nowrap : true,
            fitColumns : true,
            pagination : true,
            rownumbers : true,
            pageSize : 10,
            pageList : [10, 20, 30, 40, 50 ],
            idField : 'id',
            columns : [ [ {
                field : 'id',
                checkbox:true
            }, {
                field : 'idx',
                align : 'center',
                width : 50,
                sortable : true,
                title : 'ID'
            }, {
                field : 'name',
                align : 'center',
                width : 50,
                sortable : true,
                title : '资源组名称'
            },{
                field : 'code',
                align : 'center',
                width : 50,
                sortable : true,
                title : '编码'
            }] ],
            onSelect:function(index,row){
                girdAddRow(row, defalutIdxArr, txtArr);
            },
            onUnselect:function(index,row){
                girdRemoveRow(row, defalutIdxArr, txtArr)
            },
            onSelectAll:function(rows){
                girdAddAll(rows, defalutIdxArr, txtArr);

            },
            onUnselectAll:function(rows){
                girdRemoveAll(rows, defalutIdxArr, txtArr);
            },
            onLoadSuccess: function (data) {
                $(this).datagrid("fixRownumber");/* 表格行数宽度随内容变化 */
                // 将之前数据库中保存的默认选中
                if(defalutIdxArr.length >0 && data){
                    $.each(data.rows, function(index, item){
                        if($.inArray(item.idx+"", defalutIdxArr)>-1){
                            $('#resourceGourplist2').datagrid('checkRow', index);
                        }
                    });
                }

            }
        });

        $('#resourceGourplist-qry2').on('click',function () {
            $('#resourceGourplist2').datagrid('load',{
                name:$.trim($('#resourceGourpName2').val())
            });
        });

    });

    // 获取选中的资源组idx ， name
    function chooseResult(){

       // 获取idx|name 数组中idx
        var tmpIdxArr =[];
        for(var i in txtArr){
           var idx =  txtArr[i].split("|")[0];
            tmpIdxArr.push(idx);
        }
        for (var i in defalutIdxArr){
            if($.inArray(defalutIdxArr[i], tmpIdxArr) == -1){
                txtArr.push(defalutIdxArr[i]+"|"+"");
            }
        }

        var index = parent.layer.getFrameIndex(window.name); //获取窗口索引
        parent.layer.close(index);
        return txtArr.join(",");
    }
</script>
</body>
</html>
