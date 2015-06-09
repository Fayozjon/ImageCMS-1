<section class="mini-layout">
    <div class="frame_title clearfix">
        <div class="pull-left">
            <span class="help-inline"></span>
            <span class="title">Список заказов</span>
        </div>
        <div class="pull-right">
            <div class="d-i_b">
                <button class="btn btn-small btn-danger disabled action_on" id="del_in_search" onclick="$('.modal').modal();" disabled="disabled"><i class="icon-trash icon-white"></i>Удалить</button>
                <a href="/admin/components/cp/cart/settings/form" class="btn btn-small pjax btn-success"><i class="icon-cog icon-white"></i>Настройки</a>
                <a href="/admin/components/cp/cart/about" class="btn btn-small pjax btn-info"><i class="icon-book icon-white"></i>Документация</a>
            </div>
        </div>
    </div> 
    {if $orders}
        <table class="table table-bordered table-condensed content_big_td">
            <thead>
            <th class="t-a_c span1">
                <span class="frame_label">
                    <span class="niceCheck">
                        <input type="checkbox">
                    </span>
                </span>
            </th>
            <th width="30">ID</th>
            <th>Персональная информация</th>
            <th>Список товаров</th>
            <th width="90">Пользователь</th>
            <th width="120">Статус</th>
            <th width="90">Оформлен</th>
            </thead>
            <tbody>
                {foreach $orders as $item}
                    <tr>
                        <td class="t-a_c">
                            <span class="frame_label">
                                <span class="niceCheck">
                                    <input type="checkbox" name="ids" value="{$item.id}">
                                </span>
                            </span>
                        </td>
                        <td>{$item.id}</td>
                        
			<td>{$item.user_info}</td>
                        
			<td>{$item.list_item}</td>
                        
			<td>{$item.user}</td>
                        
			<td>
                            <select onChange="Acart.change_status({$item.id});" id="order_status">
                                <option value="В обработке" {if $item.status == 'В обработке'} selected="selected" {/if}>В обработке</option>
                                <option value="В исполнении" {if $item.status == 'В исполнении'} selected="selected" {/if}>В исполнении</option>
                                <option value="Выполнен" {if $item.status == 'Выполнен'} selected="selected" {/if}>Выполнен</option>
                                <option value="Отменён" {if $item.status == 'Отменён'} selected="selected" {/if}>Отменён</option>
                            </select>
                        </td>
                        
			<td>{date('d-m-Y H:i', $item.date)}</td>
                        
                    </tr>
                {/foreach}
            </tbody>
        </table>
    {else:}
        <div class="alert alert-info m-t_20">
            Заказов нет.
        </div>
    {/if}
</section>

<div class="modal hide fade products_delete_dialog">
    <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
        <h3>Удалить заказ</h3>
    </div>
    <div class="modal-footer">
        <a href="#" class="btn" onclick="$('.modal').modal('hide');">Отмена</a>
        <a href="#" class="btn btn-primary" onclick="Acart.deleteOrderConfirm();$('.modal').modal('hide');">Удалить</a>
    </div>
</div>
        {literal}
            <script>
            var Acart = new Object({
                deleteOrderConfirm:function(){
                    var ids = new Array();
                $('input[name=ids]:checked').each(function() {
                    ids.push($(this).val());
                });
                $.post('/admin/components/cp/cart/delete_order', {
                    id: ids
                }, function(data) {
                    $('#mainContent').after(data);
                    $.pjax({
                        url: window.location.pathname,
                        container: '#mainContent',
                        timeout: 3000
                    });
                });
                $('.modal').modal('hide');
                return false;
                },
                change_status : function(id)
                {
                    $.post('/admin/components/cp/cart/edit_status/'+id,{status:$('#order_status').val()},function(data){
                        showMessage('Готово','Статус изменён');
                    });
                }
            });
            </script>
        {/literal}